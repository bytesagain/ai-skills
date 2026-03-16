#!/usr/bin/env bash
# qr-code — QR码SVG生成工具 (pure Python QR encoder)
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
  cat << 'EOF'
📱 QR Code Generator — QR码SVG生成工具

用法: bash scripts/qr.sh <command> [options]

命令:
  generate <text> [output.svg]        生成QR码SVG文件
  wifi <ssid> <password> [enc]        WiFi连接二维码 (enc: WPA/WEP/nopass)
  vcard <name> <phone> [email] [org]  名片二维码
  url <url> [output.svg]              URL二维码
  batch <input_file> [output_dir]     批量生成 (每行一条数据)
  design                              二维码设计最佳实践

示例:
  bash scripts/qr.sh generate "Hello World" hello.svg
  bash scripts/qr.sh wifi "MyWiFi" "pass123" WPA
  bash scripts/qr.sh vcard "张三" "13800138000" "z@email.com" "BytesAgain"
  bash scripts/qr.sh url "https://bytesagain.com" site.svg

EOF
  echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

# Core QR code generator in Python — produces real SVG
generate_qr_svg() {
  local TEXT="$1"
  local OUTPUT="${2:-qr_output.svg}"
  python3 - "$TEXT" "$OUTPUT" << 'PYEOF'
import sys
import math

text = sys.argv[1]
output = sys.argv[2]

# ---- Minimal QR Code encoder (Version 1-4, Mode: Byte, ECC: M) ----
# This implements a real QR encoder for short data.

# Galois field tables for GF(256) with polynomial 0x11d
EXP_TABLE = [0] * 512
LOG_TABLE = [0] * 256
x = 1
for i in range(255):
    EXP_TABLE[i] = x
    LOG_TABLE[x] = i
    x <<= 1
    if x >= 256:
        x ^= 0x11d
for i in range(255, 512):
    EXP_TABLE[i] = EXP_TABLE[i - 255]

def gf_mul(a, b):
    if a == 0 or b == 0:
        return 0
    return EXP_TABLE[LOG_TABLE[a] + LOG_TABLE[b]]

def gf_poly_mul(p1, p2):
    result = [0] * (len(p1) + len(p2) - 1)
    for i in range(len(p1)):
        for j in range(len(p2)):
            result[i + j] ^= gf_mul(p1[i], p2[j])
    return result

def rs_generator(nsym):
    g = [1]
    for i in range(nsym):
        g = gf_poly_mul(g, [1, EXP_TABLE[i]])
    return g

def rs_encode(data, nsym):
    gen = rs_generator(nsym)
    res = data + [0] * nsym
    for i in range(len(data)):
        coef = res[i]
        if coef != 0:
            for j in range(len(gen)):
                res[i + j] ^= gf_mul(gen[j], coef)
    return res[len(data):]

# Version capacity for byte mode, ECC level M
# (version, total_codewords, ec_codewords_per_block, num_blocks, data_codewords)
VERSION_INFO = {
    1: (26, 10, 1, 16),
    2: (44, 16, 1, 28),
    3: (70, 26, 1, 44),
    4: (100, 18, 2, 64),
    5: (134, 24, 2, 86),
    6: (172, 16, 4, 108),
}

data_bytes = [ord(c) if isinstance(c, str) else c for c in text.encode('utf-8')]
data_len = len(data_bytes)

# Choose smallest version that fits
version = None
for v in sorted(VERSION_INFO.keys()):
    total, ec_per, nblocks, data_cap = VERSION_INFO[v]
    if data_len <= data_cap - 3:  # 3 bytes overhead (mode + length + terminator padding)
        version = v
        break

if version is None:
    sys.stderr.write("Error: data too long for QR Version 1-6. Max ~105 bytes.\n")
    sys.exit(1)

total_cw, ec_per_block, num_blocks, max_data = VERSION_INFO[version]
size = 17 + version * 4

# Encode data: byte mode indicator (0100) + length + data + terminator
bits = []
def add_bits(val, length):
    for i in range(length - 1, -1, -1):
        bits.append((val >> i) & 1)

add_bits(0b0100, 4)  # Byte mode
if version <= 9:
    add_bits(data_len, 8)
else:
    add_bits(data_len, 16)

for b in data_bytes:
    add_bits(b, 8)

# Terminator
needed = total_cw * 8
term_len = min(4, needed - len(bits))
for _ in range(term_len):
    bits.append(0)

# Pad to byte boundary
while len(bits) % 8 != 0:
    bits.append(0)

# Pad with alternating 0xEC, 0x11
pad_bytes = [0xEC, 0x11]
pad_idx = 0
while len(bits) < needed:
    add_bits(pad_bytes[pad_idx], 8)
    pad_idx = (pad_idx + 1) % 2

# Convert bits to codewords
codewords = []
for i in range(0, len(bits), 8):
    val = 0
    for j in range(8):
        val = (val << 1) | bits[i + j]
    codewords.append(val)

# Split into blocks and compute EC
data_cw_per_block = len(codewords) // num_blocks
blocks_data = []
blocks_ec = []
idx = 0
for blk in range(num_blocks):
    block = codewords[idx:idx + data_cw_per_block]
    idx += data_cw_per_block
    blocks_data.append(block)
    ec = rs_encode(block, ec_per_block)
    blocks_ec.append(ec)

# Interleave data codewords
final_data = []
max_dc = max(len(b) for b in blocks_data)
for i in range(max_dc):
    for blk in blocks_data:
        if i < len(blk):
            final_data.append(blk[i])

# Interleave EC codewords
for i in range(ec_per_block):
    for blk in blocks_ec:
        if i < len(blk):
            final_data.append(blk[i])

# Build matrix
matrix = [[None] * size for _ in range(size)]
reserved = [[False] * size for _ in range(size)]

def set_module(r, c, val, reserve=True):
    if 0 <= r < size and 0 <= c < size:
        matrix[r][c] = 1 if val else 0
        if reserve:
            reserved[r][c] = True

# Finder patterns
def place_finder(row, col):
    for r in range(-1, 8):
        for c in range(-1, 8):
            rr, cc = row + r, col + c
            if 0 <= rr < size and 0 <= cc < size:
                if 0 <= r <= 6 and 0 <= c <= 6:
                    if r in (0, 6) or c in (0, 6) or (2 <= r <= 4 and 2 <= c <= 4):
                        set_module(rr, cc, True)
                    else:
                        set_module(rr, cc, False)
                else:
                    set_module(rr, cc, False)

place_finder(0, 0)
place_finder(0, size - 7)
place_finder(size - 7, 0)

# Timing patterns
for i in range(8, size - 8):
    set_module(6, i, i % 2 == 0)
    set_module(i, 6, i % 2 == 0)

# Alignment patterns (version >= 2)
if version >= 2:
    positions = {
        2: [6, 18],
        3: [6, 22],
        4: [6, 26],
        5: [6, 30],
        6: [6, 34],
    }
    pos_list = positions.get(version, [])
    for ar in pos_list:
        for ac in pos_list:
            if reserved[ar][ac]:
                continue
            for r2 in range(-2, 3):
                for c2 in range(-2, 3):
                    if abs(r2) == 2 or abs(c2) == 2 or (r2 == 0 and c2 == 0):
                        set_module(ar + r2, ac + c2, True)
                    else:
                        set_module(ar + r2, ac + c2, False)

# Reserve format info areas
for i in range(9):
    if not reserved[8][i]:
        reserved[8][i] = True
        matrix[8][i] = 0
    if not reserved[i][8]:
        reserved[i][8] = True
        matrix[i][8] = 0
    if i < 8:
        ci = size - 1 - i
        if not reserved[8][ci]:
            reserved[8][ci] = True
            matrix[8][ci] = 0
        ri = size - 1 - i
        if not reserved[ri][8]:
            reserved[ri][8] = True
            matrix[ri][8] = 0

# Dark module
set_module(size - 8, 8, True)

# Version info (version >= 7 only, skip for now)

# Place data bits
all_bits = []
for byte in final_data:
    for i in range(7, -1, -1):
        all_bits.append((byte >> i) & 1)

bit_idx = 0
col = size - 1
going_up = True
while col >= 0:
    if col == 6:
        col -= 1
        continue
    rows = range(size - 1, -1, -1) if going_up else range(size)
    for row in rows:
        for dc in [0, -1]:
            c = col + dc
            if 0 <= c < size and not reserved[row][c]:
                if bit_idx < len(all_bits):
                    matrix[row][c] = all_bits[bit_idx]
                    bit_idx += 1
                else:
                    matrix[row][c] = 0
    going_up = not going_up
    col -= 2

# Apply mask pattern 0: (row + col) % 2 == 0
for r in range(size):
    for c in range(size):
        if not reserved[r][c] and matrix[r][c] is not None:
            if (r + c) % 2 == 0:
                matrix[r][c] ^= 1

# Write format info for mask 0, ECC M
# Pre-computed format info bits for M-0: 101010000010010
FORMAT_BITS = [1,0,1,0,1,0,0,0,0,0,1,0,0,1,0]

def set_format_bit(idx, val):
    if idx < 6:
        matrix[8][idx] = val
    elif idx == 6:
        matrix[8][7] = val
    elif idx == 7:
        matrix[8][8] = val
    elif idx == 8:
        matrix[7][8] = val
    else:
        matrix[14 - idx][8] = val

    if idx < 8:
        matrix[size - 1 - idx][8] = val
    else:
        matrix[8][size - 15 + idx] = val

for i, bit in enumerate(FORMAT_BITS):
    set_format_bit(i, bit)

# Generate SVG
cell = 10
margin = 4
img_size = (size + margin * 2) * cell

svg_parts = []
svg_parts.append('<?xml version="1.0" encoding="UTF-8"?>')
svg_parts.append('<svg xmlns="http://www.w3.org/2000/svg" width="{s}" height="{s}" viewBox="0 0 {s} {s}">'.format(s=img_size))
svg_parts.append('<rect width="100%" height="100%" fill="white"/>')

for r in range(size):
    for c in range(size):
        if matrix[r][c]:
            x = (c + margin) * cell
            y = (r + margin) * cell
            svg_parts.append('<rect x="{x}" y="{y}" width="{c}" height="{c}" fill="black"/>'.format(
                x=x, y=y, c=cell))

svg_parts.append('</svg>')

svg_content = '\n'.join(svg_parts)
with open(output, 'w') as f:
    f.write(svg_content)

sys.stdout.write("QR code generated: {}\n".format(output))
sys.stdout.write("Size: Version {} ({}x{} modules)\n".format(version, size, size))
sys.stdout.write("Data: {} bytes encoded\n".format(data_len))
sys.stdout.write("Open in browser to view.\n")
PYEOF
}

show_design() {
  cat << 'EOF'

=== QR Code Design Best Practices ===

📐 尺寸建议:
  - 印刷品: 最小 2cm x 2cm (300dpi)
  - 屏幕显示: 最小 200px x 200px
  - 海报/展板: 按观看距离计算，每米距离约3cm

🎨 颜色规则:
  - 前景色必须比背景色深(高对比度)
  - 不要用渐变色做前景
  - 可以用深色前景+浅色背景(非黑白)
  - 避免: 浅前景+深背景(反转)

📏 安静区(Quiet Zone):
  - 四周至少留4个模块宽度的空白
  - 这是扫描识别的关键区域
  - 不要紧贴边缘裁剪

🔧 容错级别选择:
  - L (7%)  — 数据量大，无遮挡
  - M (15%) — 一般用途(推荐)
  - Q (25%) — 可能轻微损坏
  - H (30%) — 需要加Logo

🖼️ 加Logo注意:
  - 使用H级容错
  - Logo面积不超过中心30%
  - Logo要有白色边框隔离
  - 生成后务必测试扫描

📱 测试建议:
  - 用3种以上手机测试
  - 不同距离测试
  - 不同光线条件测试
  - iOS和Android都要测

EOF
  echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

case "$CMD" in
  generate)
    TEXT="${1:?Error: need text. Usage: qr.sh generate <text> [output.svg]}"
    OUTPUT="${2:-qr_output.svg}"
    generate_qr_svg "$TEXT" "$OUTPUT"
    ;;
  wifi)
    SSID="${1:?Error: need SSID. Usage: qr.sh wifi <ssid> <password> [encryption]}"
    PASS="${2:?Error: need password}"
    ENC="${3:-WPA}"
    WIFI_TEXT="WIFI:T:${ENC};S:${SSID};P:${PASS};;"
    OUTPUT="wifi_${SSID}.svg"
    echo "WiFi QR: $WIFI_TEXT"
    generate_qr_svg "$WIFI_TEXT" "$OUTPUT"
    ;;
  vcard)
    NAME="${1:?Error: need name. Usage: qr.sh vcard <name> <phone> [email] [org]}"
    PHONE="${2:?Error: need phone}"
    EMAIL="${3:-}"
    ORG="${4:-}"
    VCARD="BEGIN:VCARD
VERSION:3.0
FN:${NAME}
TEL:${PHONE}"
    if [ -n "$EMAIL" ]; then
      VCARD="${VCARD}
EMAIL:${EMAIL}"
    fi
    if [ -n "$ORG" ]; then
      VCARD="${VCARD}
ORG:${ORG}"
    fi
    VCARD="${VCARD}
END:VCARD"
    OUTPUT="vcard_$(echo "$NAME" | tr ' ' '_').svg"
    echo "vCard QR for: $NAME"
    generate_qr_svg "$VCARD" "$OUTPUT"
    ;;
  url)
    URL="${1:?Error: need URL. Usage: qr.sh url <url> [output.svg]}"
    OUTPUT="${2:-url_qr.svg}"
    echo "URL QR: $URL"
    generate_qr_svg "$URL" "$OUTPUT"
    ;;
  batch)
    INPUT="${1:?Error: need input file. Usage: qr.sh batch <input_file> [output_dir]}"
    OUTDIR="${2:-.}"
    if [ ! -f "$INPUT" ]; then
      echo "Error: file not found: $INPUT"
      exit 1
    fi
    mkdir -p "$OUTDIR"
    COUNT=0
    while IFS= read -r line || [ -n "$line" ]; do
      if [ -z "$line" ]; then continue; fi
      COUNT=$((COUNT + 1))
      OUTFILE="${OUTDIR}/qr_$(printf '%03d' $COUNT).svg"
      echo "[$COUNT] $line -> $OUTFILE"
      generate_qr_svg "$line" "$OUTFILE"
    done < "$INPUT"
    echo ""
    echo "Batch complete: $COUNT QR codes generated in $OUTDIR/"
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;
  design)
    show_design
    ;;
  help|--help|-h)
    show_help
    ;;
  *)
    echo "Unknown command: $CMD"
    echo "Run 'bash scripts/qr.sh help' for usage."
    exit 1
    ;;
esac

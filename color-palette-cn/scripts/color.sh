#!/usr/bin/env bash
# color-palette — 配色方案生成与色彩工具
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
  cat << 'EOF'
🎨 Color Palette — 配色方案生成工具

用法: bash scripts/color.sh <command> [options]

命令:
  generate <theme>                    生成配色方案 (tech/nature/warm/cool/pastel/dark/vibrant)
  harmony <hex_color> <type>          色彩和谐方案 (complementary/analogous/triadic/split/tetradic)
  brand <industry>                    品牌配色推荐 (tech/food/fashion/health/finance/education)
  contrast <fg_hex> <bg_hex>          WCAG对比度检查
  convert <color>                     颜色格式转换 (HEX/RGB/HSL)
  trending [year]                     流行色推荐

示例:
  bash scripts/color.sh generate tech
  bash scripts/color.sh harmony "#3498db" complementary
  bash scripts/color.sh contrast "#333333" "#ffffff"
  bash scripts/color.sh convert "#ff6600"

EOF
  echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

# Pass command and args to Python via environment variables
run_color_py() {
  local py_cmd="${1:-help}"
  shift 2>/dev/null || true
  local py_arg1="${1:-}"
  local py_arg2="${2:-}"

  export PY_CMD="$py_cmd"
  export PY_ARG1="$py_arg1"
  export PY_ARG2="$py_arg2"

  python3 << 'PYEOF'
import os
import math

def hex_to_rgb(h):
    h = h.lstrip('#')
    if len(h) == 3:
        h = h[0]*2 + h[1]*2 + h[2]*2
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

def rgb_to_hex(r, g, b):
    return "#{:02x}{:02x}{:02x}".format(int(r) % 256, int(g) % 256, int(b) % 256)

def rgb_to_hsl(r, g, b):
    r2, g2, b2 = r/255.0, g/255.0, b/255.0
    mx = max(r2, g2, b2)
    mn = min(r2, g2, b2)
    l = (mx + mn) / 2.0
    if mx == mn:
        h = s = 0.0
    else:
        d = mx - mn
        s = d / (2.0 - mx - mn) if l > 0.5 else d / (mx + mn)
        if mx == r2:
            h = (g2 - b2) / d + (6.0 if g2 < b2 else 0.0)
        elif mx == g2:
            h = (b2 - r2) / d + 2.0
        else:
            h = (r2 - g2) / d + 4.0
        h /= 6.0
    return (int(h * 360), int(s * 100), int(l * 100))

def hsl_to_rgb(h, s, l):
    h2 = h / 360.0
    s2 = s / 100.0
    l2 = l / 100.0
    if s2 == 0:
        r = g = b = l2
    else:
        def hue2rgb(p, q, t):
            if t < 0: t += 1
            if t > 1: t -= 1
            if t < 1.0/6: return p + (q - p) * 6.0 * t
            if t < 1.0/2: return q
            if t < 2.0/3: return p + (q - p) * (2.0/3 - t) * 6.0
            return p
        q = l2 * (1 + s2) if l2 < 0.5 else l2 + s2 - l2 * s2
        p = 2 * l2 - q
        r = hue2rgb(p, q, h2 + 1.0/3)
        g = hue2rgb(p, q, h2)
        b = hue2rgb(p, q, h2 - 1.0/3)
    return (int(r * 255), int(g * 255), int(b * 255))

def format_color(hex_c):
    r, g, b = hex_to_rgb(hex_c)
    h, s, l = rgb_to_hsl(r, g, b)
    return "  HEX: {}  |  RGB: rgb({}, {}, {})  |  HSL: hsl({}, {}%, {}%)".format(hex_c, r, g, b, h, s, l)

def color_block(hex_c, name=""):
    label = "  {} {}".format(hex_c, name) if name else "  {}".format(hex_c)
    return "{}\n{}".format(label, format_color(hex_c))

def rotate_hue(hex_c, degrees):
    r, g, b = hex_to_rgb(hex_c)
    h, s, l = rgb_to_hsl(r, g, b)
    h2 = (h + degrees) % 360
    r2, g2, b2 = hsl_to_rgb(h2, s, l)
    return rgb_to_hex(r2, g2, b2)

def luminance(r, g, b):
    rs = r / 255.0
    gs = g / 255.0
    bs = b / 255.0
    rs = rs / 12.92 if rs <= 0.03928 else ((rs + 0.055) / 1.055) ** 2.4
    gs = gs / 12.92 if gs <= 0.03928 else ((gs + 0.055) / 1.055) ** 2.4
    bs = bs / 12.92 if bs <= 0.03928 else ((bs + 0.055) / 1.055) ** 2.4
    return 0.2126 * rs + 0.7152 * gs + 0.0722 * bs

def contrast_ratio(hex1, hex2):
    r1, g1, b1 = hex_to_rgb(hex1)
    r2, g2, b2 = hex_to_rgb(hex2)
    l1 = luminance(r1, g1, b1)
    l2 = luminance(r2, g2, b2)
    lighter = max(l1, l2)
    darker = min(l1, l2)
    return (lighter + 0.05) / (darker + 0.05)

# Read command and args from environment
cmd = os.environ.get("PY_CMD", "help")
arg1 = os.environ.get("PY_ARG1", "")
arg2 = os.environ.get("PY_ARG2", "")

if cmd == "generate":
    theme = arg1 if arg1 else "tech"
    palettes = {
        "tech": [
            ("#0a192f", "Deep Navy"),
            ("#172a45", "Dark Blue"),
            ("#303c55", "Slate"),
            ("#64ffda", "Cyan Accent"),
            ("#8892b0", "Light Slate"),
        ],
        "nature": [
            ("#2d5016", "Forest"),
            ("#4a7c28", "Leaf"),
            ("#8fbc5a", "Spring"),
            ("#c9e89d", "Mint"),
            ("#f5f0e1", "Sand"),
        ],
        "warm": [
            ("#d63031", "Red"),
            ("#e17055", "Coral"),
            ("#fab1a0", "Salmon"),
            ("#fdcb6e", "Yellow"),
            ("#ffeaa7", "Light Yellow"),
        ],
        "cool": [
            ("#0984e3", "Blue"),
            ("#74b9ff", "Light Blue"),
            ("#a29bfe", "Lavender"),
            ("#6c5ce7", "Purple"),
            ("#dfe6e9", "Ice"),
        ],
        "pastel": [
            ("#fab1a0", "Peach"),
            ("#81ecec", "Aqua"),
            ("#a29bfe", "Periwinkle"),
            ("#ffeaa7", "Cream"),
            ("#55efc4", "Mint"),
        ],
        "dark": [
            ("#0d1117", "Void"),
            ("#161b22", "Dark"),
            ("#21262d", "Charcoal"),
            ("#30363d", "Gray"),
            ("#f0f6fc", "White"),
        ],
        "vibrant": [
            ("#e74c3c", "Red"),
            ("#f39c12", "Orange"),
            ("#2ecc71", "Green"),
            ("#3498db", "Blue"),
            ("#9b59b6", "Purple"),
        ],
    }
    p = palettes.get(theme, palettes["tech"])
    print("\n=== {} Theme Palette ===\n".format(theme.upper()))
    for hex_c, name in p:
        print(color_block(hex_c, name))
        print("")
    print("--- 使用建议 ---")
    print("  主色: {}".format(p[0][0]))
    print("  辅色: {}".format(p[1][0]))
    print("  点缀: {}".format(p[3][0]))
    print("  背景: {}".format(p[4][0]))

elif cmd == "harmony":
    base = arg1 if arg1 else "#3498db"
    htype = arg2 if arg2 else "complementary"
    print("\n=== Color Harmony: {} ===".format(htype.upper()))
    print("\nBase Color:")
    print(color_block(base, "Base"))
    print("")
    if htype == "complementary":
        c = rotate_hue(base, 180)
        print("Complementary:")
        print(color_block(c, "Complement"))
    elif htype == "analogous":
        c1 = rotate_hue(base, -30)
        c2 = rotate_hue(base, 30)
        print("Analogous:")
        print(color_block(c1, "Left"))
        print("")
        print(color_block(c2, "Right"))
    elif htype == "triadic":
        c1 = rotate_hue(base, 120)
        c2 = rotate_hue(base, 240)
        print("Triadic:")
        print(color_block(c1, "120deg"))
        print("")
        print(color_block(c2, "240deg"))
    elif htype == "split":
        c1 = rotate_hue(base, 150)
        c2 = rotate_hue(base, 210)
        print("Split Complementary:")
        print(color_block(c1, "150deg"))
        print("")
        print(color_block(c2, "210deg"))
    elif htype == "tetradic":
        c1 = rotate_hue(base, 90)
        c2 = rotate_hue(base, 180)
        c3 = rotate_hue(base, 270)
        print("Tetradic (Rectangle):")
        print(color_block(c1, "90deg"))
        print("")
        print(color_block(c2, "180deg"))
        print("")
        print(color_block(c3, "270deg"))
    else:
        print("Unknown type: {}. Options: complementary/analogous/triadic/split/tetradic".format(htype))

elif cmd == "brand":
    industry = arg1 if arg1 else "tech"
    brands = {
        "tech": {
            "primary": ("#0066ff", "Trust Blue"),
            "secondary": ("#00c2ff", "Tech Cyan"),
            "accent": ("#7c3aed", "Innovation Purple"),
            "dark": ("#0f172a", "Deep Dark"),
            "light": ("#f1f5f9", "Clean Gray"),
            "tips": "科技行业偏爱蓝色系，传达信任和专业感。紫色可用作创新元素。",
        },
        "food": {
            "primary": ("#e63946", "Appetite Red"),
            "secondary": ("#f4a261", "Warm Orange"),
            "accent": ("#2a9d8f", "Fresh Teal"),
            "dark": ("#264653", "Rich Dark"),
            "light": ("#fef9ef", "Cream"),
            "tips": "餐饮行业用暖色(红/橙/黄)刺激食欲。避免蓝紫冷色系。",
        },
        "fashion": {
            "primary": ("#1a1a2e", "Luxury Dark"),
            "secondary": ("#c9a96e", "Gold"),
            "accent": ("#e8d5c4", "Nude"),
            "dark": ("#0f0f0f", "Black"),
            "light": ("#fafafa", "White"),
            "tips": "时尚行业喜欢黑白金经典组合，传达高端感。",
        },
        "health": {
            "primary": ("#059669", "Health Green"),
            "secondary": ("#0ea5e9", "Medical Blue"),
            "accent": ("#f0fdf4", "Fresh Mint"),
            "dark": ("#1e3a2f", "Deep Green"),
            "light": ("#f0fdf4", "Light Green"),
            "tips": "医疗健康用绿色和蓝色，传达安全和信任。避免红色(关联危险)。",
        },
        "finance": {
            "primary": ("#1e40af", "Navy Blue"),
            "secondary": ("#047857", "Money Green"),
            "accent": ("#b45309", "Gold"),
            "dark": ("#0f172a", "Dark Navy"),
            "light": ("#f8fafc", "Clean White"),
            "tips": "金融行业用深蓝传达稳重，绿色关联收益，金色象征财富。",
        },
        "education": {
            "primary": ("#4f46e5", "Scholar Purple"),
            "secondary": ("#0891b2", "Knowledge Teal"),
            "accent": ("#f59e0b", "Energy Yellow"),
            "dark": ("#1e1b4b", "Deep Indigo"),
            "light": ("#fefce8", "Warm White"),
            "tips": "教育行业用紫蓝色传达智慧，黄色增加活力和亲和力。",
        },
    }
    b = brands.get(industry, brands["tech"])
    print("\n=== {} Industry Brand Colors ===\n".format(industry.upper()))
    for role in ["primary", "secondary", "accent", "dark", "light"]:
        hex_c, name = b[role]
        print("{} — {}:".format(role.capitalize(), name))
        print(color_block(hex_c))
        print("")
    print("--- 行业建议 ---")
    print("  {}".format(b["tips"]))

elif cmd == "contrast":
    fg = arg1 if arg1 else "#333333"
    bg = arg2 if arg2 else "#ffffff"
    ratio = contrast_ratio(fg, bg)
    print("\n=== WCAG Contrast Check ===\n")
    print("Foreground: {}".format(fg))
    print(format_color(fg))
    print("\nBackground: {}".format(bg))
    print(format_color(bg))
    print("\n--- Results ---")
    print("  Contrast Ratio: {:.2f}:1".format(ratio))
    print("")
    if ratio >= 7:
        print("  AAA Normal Text:  PASS (>= 7:1)")
        print("  AAA Large Text:   PASS (>= 4.5:1)")
        print("  AA Normal Text:   PASS (>= 4.5:1)")
        print("  AA Large Text:    PASS (>= 3:1)")
    elif ratio >= 4.5:
        print("  AAA Normal Text:  FAIL (need 7:1, got {:.2f})".format(ratio))
        print("  AAA Large Text:   PASS (>= 4.5:1)")
        print("  AA Normal Text:   PASS (>= 4.5:1)")
        print("  AA Large Text:    PASS (>= 3:1)")
    elif ratio >= 3:
        print("  AAA Normal Text:  FAIL")
        print("  AAA Large Text:   FAIL")
        print("  AA Normal Text:   FAIL (need 4.5:1, got {:.2f})".format(ratio))
        print("  AA Large Text:    PASS (>= 3:1)")
    else:
        print("  ALL CHECKS FAILED")
        print("  Ratio {:.2f}:1 is too low for accessible text.".format(ratio))
        print("  Minimum recommended: 4.5:1 for normal text")

elif cmd == "convert":
    color_input = arg1 if arg1 else "#ff6600"
    if color_input.startswith("#"):
        r, g, b = hex_to_rgb(color_input)
        h, s, l = rgb_to_hsl(r, g, b)
        hex_c = color_input
    elif color_input.startswith("rgb"):
        nums = color_input.replace("rgb(","").replace(")","").split(",")
        r, g, b = int(nums[0].strip()), int(nums[1].strip()), int(nums[2].strip())
        hex_c = rgb_to_hex(r, g, b)
        h, s, l = rgb_to_hsl(r, g, b)
    elif color_input.startswith("hsl"):
        nums = color_input.replace("hsl(","").replace(")","").replace("%","").split(",")
        h, s, l = int(nums[0].strip()), int(nums[1].strip()), int(nums[2].strip())
        r, g, b = hsl_to_rgb(h, s, l)
        hex_c = rgb_to_hex(r, g, b)
    else:
        r, g, b = hex_to_rgb(color_input)
        h, s, l = rgb_to_hsl(r, g, b)
        hex_c = color_input
    print("\n=== Color Conversion ===\n")
    print("  HEX: {}".format(hex_c))
    print("  RGB: rgb({}, {}, {})".format(r, g, b))
    print("  HSL: hsl({}, {}%, {}%)".format(h, s, l))
    print("")
    print("  CSS Custom Property: --color-custom: {};".format(hex_c))
    print("  CSS RGB:  color: rgb({}, {}, {});".format(r, g, b))
    print("  CSS HSL:  color: hsl({}, {}%, {}%);".format(h, s, l))
    print("  CSS RGBA: color: rgba({}, {}, {}, 1.0);".format(r, g, b))

elif cmd == "trending":
    year = arg1 if arg1 else "2025"
    print("\n=== {} Trending Colors ===\n".format(year))
    trends = [
        ("#5b5ea6", "Future Dusk", "数字紫，代表科技与未来"),
        ("#9b2335", "Chili Pepper", "辣椒红，热情与力量"),
        ("#55b4b0", "Biscay Bay", "湾蓝，平静与信任"),
        ("#e6af2e", "Aspen Gold", "白杨金，乐观与温暖"),
        ("#dd4132", "Flame Scarlet", "火焰红，自信与活力"),
        ("#2bae66", "Verdant", "翠绿，自然与可持续"),
        ("#f5df4d", "Illuminating", "明亮黄，希望与乐观"),
        ("#939597", "Ultimate Gray", "极致灰，稳重与韧性"),
    ]
    for hex_c, name, desc in trends:
        print("{} — {}".format(name, desc))
        print(format_color(hex_c))
        print("")
    print("--- 趋势说明 ---")
    print("  自然色和数字色融合是主流趋势")
    print("  可持续、平静、乐观是关键色彩情绪")

else:
    import sys
    print("Unknown command: {}".format(cmd))
    sys.exit(1)
PYEOF
}

case "$CMD" in
  generate)
    run_color_py generate "$@"
    ;;
  harmony)
    run_color_py harmony "$@"
    ;;
  brand)
    run_color_py brand "$@"
    ;;
  contrast)
    run_color_py contrast "$@"
    ;;
  convert)
    run_color_py convert "$@"
    ;;
  trending)
    run_color_py trending "$@"
    ;;
  help|--help|-h)
    show_help
    ;;
  *)
    echo "Unknown command: $CMD"
    echo "Run 'bash scripts/color.sh help' for usage."
    exit 1
    ;;
esac

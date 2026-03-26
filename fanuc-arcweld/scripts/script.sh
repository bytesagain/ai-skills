#!/usr/bin/env bash
set -euo pipefail

# FANUC Arc Welding Reference
# Data from: FANUC R-J3iB ArcTool OPERATOR'S MANUAL, FANUC外部轴添加手册(弧焊篇)

cmd_schedule() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC Arc Weld Schedule Parameters
═══════════════════════════════════════════════════

【焊接条件结构】
  Menu > DATA > Weld Schedule
  
  每个Schedule包含三部分:
    Start Condition   起弧条件
    Weld Condition    焊接条件
    End Condition     收弧条件

【起弧条件 Arc Start】
  Pre-flow Time      预送气时间 (0.1-5.0 sec)
  Start Current      起弧电流 (A)
  Start Voltage      起弧电压 (V)
  Start Speed        起弧送丝速度
  Start Time         起弧维持时间 (sec)
  Scratch Start      擦弧起弧 (ON/OFF)
  Retry Count        起弧重试次数 (0-10)
  Retry Distance     重试回退距离 (mm)

【焊接条件 Weld】
  Weld Current       焊接电流 (A)
  Weld Voltage       焊接电压 (V)
  Travel Speed       焊接速度 (cm/min)
  Wire Feed Speed    送丝速度 (m/min 或 cm/min)
  
  调整方式:
    电压修正: Voltage Trim (±10V)
    电流修正: Current Trim (±50A)

【收弧条件 Arc End】
  Crater Fill        填弧坑 (ON/OFF)
  End Current        收弧电流 (A, 通常比焊接电流低20-30%)
  End Voltage        收弧电压 (V)
  End Time           收弧时间 (0.1-2.0 sec)
  Post-flow Time     后送气时间 (1-10 sec)
  Burnback Time      回烧时间 (0.01-0.5 sec)

【TP程序调用】
   1: Arc Start[1]              起弧, 使用条件1
   2: L P[2] 30cm/min FINE      焊接移动
   3: L P[3] 30cm/min FINE      焊接移动
   4: Arc End[1]                收弧, 使用条件1

  多条件切换:
   1: Arc Start[1]
   2: L P[2] 30cm/min FINE Weld Schedule[2]   焊接中切换条件
   3: Arc End[1]

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_wirefeed() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC Arc Weld Wire Feed Reference
═══════════════════════════════════════════════════

【常用焊丝规格】
  Φ0.8mm   薄板 (0.6-1.2mm)
  Φ0.9mm   薄板-中板
  Φ1.0mm   中板 (1.0-3.0mm) ← 最常用
  Φ1.2mm   中厚板 (2.0-6.0mm)
  Φ1.6mm   厚板 (>4.0mm)

【送丝速度 vs 电流 (CO2, Φ1.0mm)】
  电流(A)    送丝速度(m/min)
  80-100     3-5
  120-150    5-8
  160-200    8-12
  220-260    12-16
  280-320    16-20

【送丝速度 vs 电流 (Ar+CO2混合气, Φ1.0mm)】
  电流(A)    送丝速度(m/min)
  80-100     3-4
  120-150    5-7
  160-200    7-10
  220-260    10-14
  280-320    14-18

【焊丝伸出长度 (Stick-out)】
  CO2:        10-20mm (通常15mm)
  Ar+CO2:     12-20mm (通常15mm)
  伸出太长 → 电弧不稳, 飞溅大
  伸出太短 → 导电嘴烧损, 飞溅粘喷嘴

【焊丝材质】
  ER70S-6    低碳钢, 最通用
  ER80S-G    高强钢
  ER308L     不锈钢304
  ER316L     不锈钢316
  ER4043     铝合金(铝硅)
  ER5356     铝合金(铝镁)

【送丝故障排查】
  1. 送丝不顺畅:
     → 检查导丝管(liner)是否弯折
     → 检查送丝轮压力
     → 检查焊丝是否缠绕
  2. 送丝速度不稳:
     → 检查送丝电机
     → 检查导电嘴孔径是否合适
  3. 鸟巢(wire bird-nest):
     → 送丝轮压力过大
     → 导丝管堵塞
     → 导电嘴堵塞

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_gas() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC Arc Weld Shielding Gas
═══════════════════════════════════════════════════

【常用保护气体】
  100% CO2          低碳钢, 成本低, 飞溅较大
  80% Ar + 20% CO2  低碳钢, 飞溅小, 成形好 ← 最常用
  90% Ar + 10% CO2  低碳钢, 更少飞溅
  95% Ar + 5% CO2   薄板, 最少飞溅
  98% Ar + 2% O2    不锈钢
  100% Ar            铝合金, 不锈钢TIG

【流量设置】
  MIG/MAG:  15-25 L/min (通常20 L/min)
  TIG:      8-15 L/min
  
  薄板(≤1mm):   12-15 L/min
  中板(1-3mm):   15-20 L/min
  厚板(>3mm):    20-25 L/min

【预送气/后送气】
  Pre-flow:   0.3-1.0 sec (电弧点燃前保护)
  Post-flow:  2-8 sec (电弧熄灭后保护熔池)
  
  不锈钢/铝合金: Post-flow加长到5-10 sec (防氧化)

【气体问题排查】
  气孔(Porosity):
    1. 气流量不足 → 增加到20-25 L/min
    2. 风大 → 加挡风板, 或增加气流量
    3. 喷嘴堵塞 → 清理飞溅
    4. 气管漏气 → 检查所有接头
    5. 工件表面油污/水分 → 清理工件

  气流不稳:
    1. 气瓶压力低 → 更换气瓶
    2. 减压阀故障 → 更换
    3. 电磁阀故障 → 检查焊机气阀

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_weave() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC Arc Weld Weaving Patterns
═══════════════════════════════════════════════════

【摆弧类型】
  Menu > DATA > Weld Schedule > WEAVE

  1. Zigzag (锯齿形)
     ╱╲╱╲╱╲
     最常用, 适合角焊缝和对接焊

  2. Sine (正弦形)
     ∿∿∿∿∿
     平滑过渡, 适合薄板

  3. Figure-8 (8字形)
     ∞∞∞∞
     热输入均匀, 适合厚板多层焊

  4. Circle (圆形)
     ○○○○
     填充大间隙

  5. L-Shape (L形)
     ┐┐┐┐
     单侧停留, 适合立焊/横焊

【摆弧参数】
  Frequency     摆弧频率 (Hz, 通常1-5Hz)
  Amplitude     摆弧幅度 (mm, 通常焊缝宽度的60-80%)
  Dwell Left    左侧停留时间 (sec, 0.1-0.5)
  Dwell Right   右侧停留时间 (sec, 0.1-0.5)
  Dwell Center  中心停留时间 (sec, 通常0)

【典型设置】
  角焊缝 (Fillet):
    Pattern: Zigzag
    Amplitude: 3-8mm
    Frequency: 2-3Hz
    Dwell L/R: 0.1-0.3sec

  对接焊 (Butt, V型坡口):
    Pattern: Zigzag
    Amplitude: 坡口宽度的60-80%
    Frequency: 1.5-2.5Hz
    Dwell L/R: 0.2-0.4sec (防咬边)

  立焊 (Vertical Up):
    Pattern: Zigzag or L-Shape
    Amplitude: 较小, 2-5mm
    Frequency: 1-2Hz
    Dwell L/R: 0.3-0.5sec (让熔池凝固)

【TP程序调用】
  Arc Start[1] 后自动使用该条件绑定的摆弧
  或在焊接语句中指定:
  L P[2] 30cm/min FINE Weave[2]   使用摆弧条件2

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_seam() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC Seam Tracking (TAST / ArcSensor)
═══════════════════════════════════════════════════

【TAST (Through-Arc Seam Tracking)】
  原理: 焊接过程中检测电弧电流/电压变化
        枪摆弧时, 离工件近→电流大, 离工件远→电流小
        利用左右电流差修正焊缝跟踪

  条件:
    - 必须开启摆弧(Weave)
    - 角焊缝效果最好
    - 板厚 ≥ 1.5mm
    - 焊接电流 ≥ 150A

【TAST设置】
  Menu > DATA > Weld Schedule > TAST
  
  参数:
    TAST Enable       使能 (ON/OFF)
    Track Direction   跟踪方向 (LEFT/RIGHT/BOTH)
    Sensitivity       灵敏度 (1-10, 通常5)
    Correction Gain   修正增益
    Max Correction    最大修正量 (mm, 通常±3mm)
    Sample Start      采样起始延迟 (焊缝初段不跟踪)

【ArcSensor (电弧传感器)】
  高级版TAST, 增加了:
    - Z方向修正(焊枪高度)
    - 左右+上下同时跟踪
    - 自适应控制

  设置路径:
    Menu > DATA > ArcSensor Config

【Touch Sensing (触碰寻位)】
  焊接前用焊丝轻触工件找焊缝位置
  
  步骤:
    1. 机器人移到接近位置
    2. 执行Touch Sense: TOUCH SENSE[条件号]
    3. 焊丝缓慢前进接触工件
    4. 接触瞬间记录位置
    5. 计算偏移修正后续焊接点

  TP调用:
    Touch Sense Start[1, PR[10]]   结果存入PR[10]

【多层多道焊接】
  第一道: 正常焊接 + Touch Sense定位
  第二道起: 在上一道基础上偏移
  
  偏移方式:
    PR[offset].y = PR[offset].y + 层间偏移
    PR[offset].z = PR[offset].z + 堆高偏移
  
  用Offset PR[]在运动指令中叠加:
    L P[2] 30cm/min FINE Offset PR[10]

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_params() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC Arc Weld Quick Parameter Reference
═══════════════════════════════════════════════════

【低碳钢 MIG/MAG (Ar80%+CO2 20%, Φ1.0mm焊丝)】

  角焊缝 Fillet (T接/搭接):
  板厚    焊脚    电流(A)  电压(V)  速度(cm/min)  送丝(m/min)
  1.0mm   3mm     80-100   17-19    40-50         3-5
  1.5mm   4mm     120-150  19-21    35-45         5-7
  2.0mm   5mm     160-190  20-23    30-40         7-10
  2.5mm   6mm     190-220  22-25    25-35         10-12
  3.0mm   6mm     220-250  24-27    20-30         12-14

  对接焊 Butt (V型坡口):
  板厚    电流(A)  电压(V)  速度(cm/min)  备注
  1.0mm   70-90    16-18    50-60         无坡口, 间隙≤1mm
  2.0mm   100-130  18-21    35-45         无坡口或V30°
  3.0mm   140-180  20-24    25-35         V60°坡口
  5.0mm   200-250  23-27    20-30         V60°, 2-3道
  8.0mm   250-300  25-30    15-25         V60°, 多层多道

【不锈钢 MIG (Ar98%+O2 2%, ER308L/316L Φ1.0mm)】
  板厚    电流(A)  电压(V)  速度(cm/min)  备注
  1.0mm   60-80    17-19    40-55         低热输入防变形
  1.5mm   80-110   18-21    35-45
  2.0mm   110-140  20-23    30-40
  3.0mm   140-180  22-25    25-35         背面充氩保护

【铝合金 MIG (100% Ar, ER4043/5356 Φ1.2mm)】
  板厚    电流(A)  电压(V)  速度(cm/min)  备注
  2.0mm   90-120   18-21    40-55         脉冲焊接效果更好
  3.0mm   130-170  20-24    30-45
  5.0mm   180-230  23-27    20-35         多道焊
  8.0mm   220-280  25-30    15-25         V型坡口, 多层

【焊接速度 vs 焊缝质量】
  太快 → 焊缝窄/高, 咬边, 未熔合
  太慢 → 焊缝宽/平, 热影响区大, 变形大
  最佳 → 焊缝宽高比 ≈ 1.5-2.5:1

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_troubleshoot() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC Arc Weld Troubleshooting
═══════════════════════════════════════════════════

【起弧失败 Arc Start Failure (ARC-005)】
  1. 焊丝伸出太长 → 剪到10-15mm
  2. 导电嘴堵塞 → 更换导电嘴
  3. 接地不良 → 检查地线夹, 清理接触面
  4. 气流过大 → 降到15-20 L/min (冷焊丝)
  5. 焊丝末端氧化 → 剪掉末端5mm
  6. 起弧电流太低 → 增加Start Current

【飞溅过大 Excessive Spatter】
  1. 电压偏低 → 增加1-2V
  2. 伸出长度不当 → 调整到15mm
  3. CO2比例高 → 切换到Ar+CO2混合气
  4. 导电嘴磨损 → 更换
  5. 送丝不稳 → 检查送丝系统

【气孔 Porosity】
  1. 保护气不足 → 增加气流量到20-25 L/min
  2. 工件有油/锈/水 → 清理焊接区域
  3. 喷嘴飞溅堵塞 → 清理或更换喷嘴
  4. 风吹散保护气 → 挡风/增大气流
  5. 气管漏气 → 检查接头/更换气管
  6. 后送气太短 → 增加Post-flow到3-5秒

【咬边 Undercut】
  1. 焊接速度过快 → 降低速度
  2. 电流过大 → 降低电流
  3. 焊枪角度不对 → 调整枪角(与工件保持10-15°)
  4. 摆弧两侧停留太短 → 增加Dwell时间

【未熔合 Lack of Fusion】
  1. 焊接电流不足 → 增加电流
  2. 焊接速度过快 → 降低速度
  3. 坡口角度太小 → 加大坡口
  4. 层间清理不够 → 清除焊渣
  5. 枪角度不对 → 对准接头根部

【送丝故障 (ARC-007)】
  1. 焊丝缠绕 → 检查丝盘
  2. 导丝管弯折 → 更换liner
  3. 送丝轮磨损 → 更换送丝轮
  4. 导电嘴孔径不匹配 → 使用正确尺寸
  5. 送丝轮压力不当 → 调整

【焊缝成形不良】
  焊缝太高太窄:
    → 降低焊接速度, 或增加电压
  焊缝太平太宽:
    → 增加焊接速度, 或降低电流
  焊缝不对称:
    → 检查枪角度, 调整摆弧参数

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_help() {
  cat << 'EOF'
fanuc-arcweld — FANUC Arc Welding Reference

Commands:
  schedule        Weld schedule (start/weld/end conditions)
  wirefeed        Wire feed speed and material reference
  gas             Shielding gas types and flow rates
  weave           Weaving patterns and parameters
  seam            Seam tracking (TAST/ArcSensor/Touch Sense)
  params          Quick parameters by material/thickness
  troubleshoot    Common problems and solutions
  help            Show this help

Examples:
  bash scripts/script.sh params
  bash scripts/script.sh troubleshoot
  bash scripts/script.sh weave
  bash scripts/script.sh gas

Powered by BytesAgain | bytesagain.com

Related:
  clawhub install fanuc-alarm     Alarm codes (2607, incl. ARC)
  clawhub install fanuc-tp        TP programming
  clawhub install fanuc-spotweld  Spot welding
  Browse all: bytesagain.com
EOF
}

case "${1:-help}" in
  schedule)     cmd_schedule ;;
  wirefeed)     cmd_wirefeed ;;
  gas)          cmd_gas ;;
  weave)        cmd_weave ;;
  seam)         cmd_seam ;;
  params)       cmd_params ;;
  troubleshoot) cmd_troubleshoot ;;
  help|*)       cmd_help ;;
esac

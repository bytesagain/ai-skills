#!/usr/bin/env bash
set -euo pipefail

# FANUC Spot Welding Reference
# Data from: SpotTool Operator Manual B-81464EN, 伺服枪功能说明书, TipDress Manual

cmd_schedule() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC Spot Weld Schedule Parameters
═══════════════════════════════════════════════════

【焊接条件表 Weld Schedule】
  Menu > SETUP > Spot Config > WELD SCHEDULE
  
  每个Schedule包含:
    Schedule No.     条件号 (1-255)
    Weld Enable      焊接使能 (ON/OFF)
    Squeeze Time     加压时间 (cycles, 1 cycle=20ms@50Hz)
    Weld 1 Time      第一段焊接时间 (cycles)
    Weld 1 Current   第一段焊接电流 (%)
    Cool Time        冷却时间 (cycles)
    Weld 2 Time      第二段焊接时间 (cycles, 脉冲焊用)
    Weld 2 Current   第二段焊接电流 (%)
    Hold Time        保持时间 (cycles)
    Off Time         断开时间 (cycles)

【标准焊接时序】
  ┌─加压─┬─焊接1─┬─冷却─┬─焊接2─┬─保持─┬─开枪─┐
  │Squeeze│Weld 1 │Cool  │Weld 2 │Hold  │Open  │
  │ 力→  │电流ON │电流OFF│电流ON │电流OFF│释放   │
  └──────┴──────┴─────┴──────┴─────┴─────┘

【单脉冲焊接】(最常用)
  Squeeze: 15-30 cycles (加压稳定)
  Weld 1:  8-15 cycles  (通电时间)
  Cool:    0 cycles
  Weld 2:  0 cycles
  Hold:    5-10 cycles  (维持压力让熔核凝固)

【双脉冲焊接】(镀锌板/厚板)
  Squeeze: 20-30 cycles
  Weld 1:  5-8 cycles   (预热脉冲, 较低电流)
  Cool:    2-5 cycles   (冷却)
  Weld 2:  10-15 cycles (主焊接脉冲, 高电流)
  Hold:    8-15 cycles

【TP程序调用】
  SPOT[1]              调用焊接条件1
  SPOT[R[1]]           间接调用(寄存器指定条件号)
  SPOT[1,BU=C]         焊接+备用关闭
  SPOT[1,BU=O]         焊接+备用打开

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_servogun() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC Servo Gun Setup
═══════════════════════════════════════════════════

【伺服焊枪 vs 气动焊枪】
  气动枪: 气缸驱动, 力不精确, 速度慢
  伺服枪: 伺服电机驱动, 力精确可控, 速度快
  
  伺服枪优势:
    - 加压力可编程(每个焊点不同力)
    - 均压功能(equalization)
    - 更快的开合速度(节拍短)
    - 电极磨损补偿自动

【伺服枪初始设置】
  1. Menu > Setup > SpotConfig > SERVO GUN
  2. 设置枪号(Gun 1-4)
  3. 设置运动组(通常Group 2)
  4. 设置轴号(通常是附加轴J7或J8)

【伺服枪原点校正 Mastering】
  1. 手动将枪完全闭合(电极尖对尖)
  2. Menu > Setup > Spot Config > SERVO GUN > MASTERING
  3. 记录闭合位置
  4. 设置行程范围(Stroke Limit)
  
  注意: 更换电极后必须重新校正!

【力标定 Force Calibration】
  1. 在枪臂间放测力计
  2. Menu > Setup > Spot Config > SERVO GUN > FORCE CAL
  3. 输入多个力-电流对应点(至少3点)
  4. 系统自动计算力曲线
  
  标定点示例:
    Point 1: 1000N → 电机电流 20%
    Point 2: 2500N → 电机电流 50%
    Point 3: 4000N → 电机电流 80%

【均压 Equalization】
  功能: 枪闭合时先轻触工件, 然后机器人微调使两臂受力均匀
  设置: Menu > Setup > Spot Config > EQUALIZATION
  
  参数:
    EQ Distance   均压距离 (1-5mm)
    EQ Timeout    均压超时 (ms)
    EQ Force      均压力   (N, 通常100-500N)

【Backup (备用) 功能】
  半开位置: 枪不完全打开, 只开到够移动的距离
  全开位置: 枪完全打开
  
  BU=C  半开 (Close backup, 快速移动)
  BU=O  全开 (Open backup)
  BU=*  保持上一个状态

  减少开合行程 = 减少节拍时间

【系统变量】
  $SPOTCONFIG[gun].$GUN_TYPE     枪类型(SERVO/AIR)
  $SPOTCONFIG[gun].$FORCE_AXIS   力轴号
  $SPOTCONFIG[gun].$STROKE_LIM   行程限制
  $SPOTCONFIG[gun].$SQUEEZE_TM   加压时间
  $SPOTCONFIG[gun].$EQ_DIST      均压距离

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_tipdress() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC Electrode Tip Dress
═══════════════════════════════════════════════════

【电极修磨 Tip Dress】
  目的: 恢复电极帽形状, 延长寿命, 保证焊接质量
  
  修磨频率: 通常每50-200个焊点修磨一次
  修磨位置: 机器人移动到固定修磨器位置

【修磨设置】
  Menu > Setup > Spot Config > TIP DRESS
  
  参数:
    Dress Count      修磨计数阈值 (焊点数)
    Dress Time       修磨旋转时间 (sec, 通常1-3秒)
    Dress Force      修磨加压力 (N, 通常500-1500N)
    Dress Speed      修磨器转速 (RPM)
    Dress Position   修磨位置 (PR[n])

【修磨计数器】
  R[tip_cnt] 记录焊接次数
  每焊一点: R[tip_cnt] = R[tip_cnt] + 1
  达到阈值: 跳转修磨程序
  修磨后:   R[tip_cnt] = 0

【TP程序示例 — 自动修磨】
  IF R[10:Tip Count] >= 150, CALL TIP_DRESS
  
  /PROG TIP_DRESS
   1: J PR[5:Dress Pos] 30% FINE ;
   2: !--- Close gun on dresser --- ;
   3: SPOT[99:Dress Schedule] ;
   4: DO[10:Dresser Motor]=ON ;
   5: WAIT 2.00(sec) ;
   6: DO[10:Dresser Motor]=OFF ;
   7: !--- Open gun --- ;
   8: R[10:Tip Count]=0 ;
   9: J PR[1:Home] 30% FINE ;
  /END

【电极帽寿命管理】
  新帽直径:    通常 Φ16mm
  修磨后最小:  Φ12mm (低于此更换)
  帽寿命:      约2000-5000焊点 (取决于材料/电流)
  
  换帽后必须:
    1. 重新校正伺服枪原点(Mastering)
    2. 重新标定力曲线(Force Cal)
    3. 清零修磨计数器

【电极磨损补偿】
  伺服枪自动补偿: 每次闭合检测电极位置变化
  系统变量: $SPOTCONFIG[gun].$WEAR_COMP = ENABLE
  
  补偿原理:
    新帽闭合位置 = 0mm
    磨损1mm后 → 闭合位置偏移1mm
    系统自动修正TCP偏移

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_timing() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC Spot Weld Timing
═══════════════════════════════════════════════════

【时间单位】
  1 cycle = 1/频率
  50Hz电源: 1 cycle = 20ms
  60Hz电源: 1 cycle = 16.67ms

【标准时序图】
  
  Force  ───┐         ┌──保持──┐
            │  加压    │        │
            └────────┘        └──→ 开枪
  
  Current     ┌─焊接1─┐  ┌─焊接2─┐
              │       │  │       │
  ────────────┘       └──┘       └──→
  
  Time →  |Squeeze|Weld1|Cool|Weld2|Hold|Off|

【常用参数范围】
  Squeeze (加压):  10-40 cycles (200-800ms @50Hz)
    - 太短: 加压不稳, 飞溅
    - 太长: 浪费节拍
    
  Weld (焊接):    5-20 cycles (100-400ms @50Hz)
    - 太短: 熔核小, 焊接强度不够
    - 太长: 过烧, 压痕深, 飞溅
    
  Hold (保持):    3-15 cycles (60-300ms @50Hz)
    - 太短: 熔核未凝固就开枪 → 缩孔/裂纹
    - 太长: 浪费节拍
    
  Cool (冷却):    0-5 cycles (双脉冲用)
    - 用于镀锌板: 让锌层蒸发的气体排出

【快速设置指南 — 低碳钢】
  板厚0.8mm: Sq=15, W1=8,  C=0, W2=0, Hd=5
  板厚1.0mm: Sq=20, W1=10, C=0, W2=0, Hd=8
  板厚1.2mm: Sq=20, W1=12, C=0, W2=0, Hd=8
  板厚1.5mm: Sq=25, W1=14, C=0, W2=0, Hd=10
  板厚2.0mm: Sq=30, W1=16, C=0, W2=0, Hd=12
  板厚2.5mm: Sq=30, W1=18, C=0, W2=0, Hd=15

【快速设置指南 — 镀锌板(双脉冲)】
  板厚0.8mm: Sq=20, W1=5, C=3, W2=10, Hd=8
  板厚1.0mm: Sq=25, W1=6, C=3, W2=12, Hd=10
  板厚1.2mm: Sq=25, W1=7, C=4, W2=14, Hd=10
  板厚1.5mm: Sq=30, W1=8, C=4, W2=16, Hd=12

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_force() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC Spot Weld Force Settings
═══════════════════════════════════════════════════

【加压力范围】
  小型枪 (C型):   1000-4000N
  中型枪 (X型):   2000-6000N
  大型枪:         3000-8000N

【按材料/板厚推荐加压力】
  低碳钢:
    0.8mm: 1500-2000N
    1.0mm: 2000-2500N
    1.2mm: 2500-3000N
    1.5mm: 3000-3500N
    2.0mm: 3500-4500N
    2.5mm: 4000-5000N
  
  镀锌钢板 (加压力比低碳钢高10-20%):
    0.8mm: 1800-2200N
    1.0mm: 2200-2800N
    1.2mm: 2800-3500N
    1.5mm: 3500-4200N
    2.0mm: 4000-5000N
  
  高强钢 (加压力比低碳钢高20-50%):
    0.8mm: 2000-3000N
    1.0mm: 2500-3500N
    1.2mm: 3000-4000N
    1.5mm: 4000-5000N

  铝合金 (加压力比低碳钢高30-50%):
    1.0mm: 3000-4000N
    1.5mm: 4000-5500N
    2.0mm: 5000-7000N

【力标定步骤】
  1. 准备测力计(量程需覆盖最大使用力)
  2. Menu > Setup > Spot Config > SERVO GUN > FORCE CAL
  3. 选择枪号
  4. 输入标定点数量(建议5-8点)
  5. 对每个标定点:
     a. 输入目标力值
     b. 机器人闭合枪, 调整电机电流直到测力计显示目标力
     c. 记录
  6. 系统自动拟合力-电流曲线

【注意事项】
  - 标定后要验证: 用测力计实测几个中间值
  - 温度影响: 冷态和热态力可能差5-10%
  - 定期重新标定(每月或换电极后)
  - 三层板焊接: 力要比两层高20-30%

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_troubleshoot() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC Spot Weld Troubleshooting
═══════════════════════════════════════════════════

【飞溅 Splash/Expulsion】
  原因:
    1. 电流过大
    2. 加压力不足
    3. 加压时间太短(未稳定就通电)
    4. 电极帽磨损(接触面积大→电流密度不均)
    5. 板材间隙过大
  对策:
    1. 降低焊接电流5-10%
    2. 增加加压力10-20%
    3. 增加Squeeze time 5-10 cycles
    4. 修磨或更换电极帽
    5. 检查工件夹具

【焊点强度不足 Weak Weld】
  原因:
    1. 电流不足
    2. 焊接时间太短
    3. 加压力过大(熔核被压扁)
    4. 电极帽面积过大(电流密度低)
    5. 分流(旁边焊点导电)
  对策:
    1. 增加焊接电流5-10%
    2. 增加Weld time 2-5 cycles
    3. 适当降低加压力
    4. 修磨电极恢复小接触面
    5. 增大焊点间距或增加电流补偿

【电极粘连 Electrode Sticking】
  原因:
    1. 电流过大
    2. Hold time太短(熔核未凝固就开枪)
    3. 电极帽材质不匹配
    4. 焊接镀锌板时锌合金化
  对策:
    1. 降低电流
    2. 增加Hold time 5-10 cycles
    3. 使用合适材质电极帽(CuCrZr或分散强化铜)
    4. 用双脉冲焊接(预热脉冲蒸发锌)

【压痕过深 Deep Indentation】
  原因:
    1. 加压力过大
    2. 焊接电流/时间过长导致过热
    3. 电极帽面积太小
  对策:
    1. 降低加压力
    2. 缩短焊接时间
    3. 使用较大端面电极帽

【伺服枪报警】
  SPOT-004 (电极力异常):
    → 检查力标定, 重新Force Cal
    → 检查枪臂有无变形
  SPOT-006 (焊接模式不匹配):
    → 检查Soft Panel的Weld Enable状态
  SPOT-010 (枪行程超限):
    → 检查工件是否到位
    → 重新伺服枪Mastering
  SPOT-030 (接触器异常):
    → 检查焊接控制器接触器状态

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_params() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC Spot Weld Quick Parameter Reference
═══════════════════════════════════════════════════

【低碳钢 (SPCC/SPHC) — 两层同厚】
  厚度    电流(kA)  力(kN)  时间(cy)  电极(mm)
  0.6mm   7-8       1.5     6-8       Φ13
  0.8mm   8-9       2.0     8-10      Φ13
  1.0mm   9-10      2.5     10-12     Φ16
  1.2mm   10-11     3.0     12-14     Φ16
  1.5mm   11-12     3.5     14-16     Φ16
  2.0mm   12-14     4.0     16-18     Φ16
  2.5mm   13-15     5.0     18-20     Φ20
  3.0mm   14-16     5.5     20-22     Φ20

【镀锌钢板 (GA/GI) — 两层同厚, 双脉冲】
  厚度    电流(kA)  力(kN)  W1(cy)  Cool  W2(cy)
  0.8mm   9-10      2.2     5       3     10
  1.0mm   10-11     2.8     6       3     12
  1.2mm   11-12     3.2     7       4     14
  1.5mm   12-13     3.8     8       4     16
  2.0mm   13-14     4.5     9       5     18

【高强钢 (DP590/DP780) — 两层同厚】
  厚度    电流(kA)  力(kN)  时间(cy)  备注
  0.8mm   8-9       2.5     10-12     力增20%
  1.0mm   9-11      3.0     12-14
  1.2mm   10-12     3.5     14-16
  1.5mm   11-13     4.5     16-20     可能需回火脉冲
  2.0mm   13-15     5.5     18-22

【铝合金 (5xxx/6xxx) — 两层同厚】
  厚度    电流(kA)  力(kN)  时间(cy)  备注
  1.0mm   20-25     3.5     3-5       大电流短时间
  1.5mm   25-30     4.5     4-6       电极磨损快
  2.0mm   28-35     5.5     5-8       需频繁修磨

【三层板焊接 — 经验公式】
  电流: 比两层最厚板增加10-15%
  力:   比两层增加20-30%
  时间: 比两层增加15-25%

【最小焊点间距】
  板厚 × 10-12 = 最小间距(mm)
  例: 1.5mm板 → 最小间距15-18mm

【熔核直径要求 (一般标准)】
  最小: 4√t mm (t=最薄板厚度, mm)
  推荐: 5√t mm
  例: 1.0mm板 → 最小4mm, 推荐5mm

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_help() {
  cat << 'EOF'
fanuc-spotweld — FANUC Spot Welding Reference

Commands:
  schedule        Weld schedule parameters and timing
  servogun        Servo gun setup, mastering, calibration
  tipdress        Electrode tip dress and wear compensation
  timing          Squeeze/weld/hold timing parameters
  force           Force calibration and pressure settings
  troubleshoot    Common problems and solutions
  params          Quick parameter reference by material/thickness
  help            Show this help

Examples:
  bash scripts/script.sh schedule
  bash scripts/script.sh params
  bash scripts/script.sh troubleshoot

Powered by BytesAgain | bytesagain.com

Related:
  clawhub install fanuc-alarm     Alarm codes (2607, incl. SPOT)
  clawhub install fanuc-tp        TP programming
  clawhub install fanuc-arcweld   Arc welding
  Browse all: bytesagain.com
EOF
}

case "${1:-help}" in
  schedule)     cmd_schedule ;;
  servogun)     cmd_servogun ;;
  tipdress)     cmd_tipdress ;;
  timing)       cmd_timing ;;
  force)        cmd_force ;;
  troubleshoot) cmd_troubleshoot ;;
  params)       cmd_params ;;
  help|*)       cmd_help ;;
esac

#!/usr/bin/env bash
set -euo pipefail

# FANUC PLC Communication & Integration Reference
# Data from: EtherNet/IP操作说明书, DeviceNet操作说明书, Profinet通讯手册

cmd_io() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC I/O Configuration
═══════════════════════════════════════════════════

【I/O类型概览】
  类型     范围          用途
  DI/DO    1-4096       数字输入/输出 (最常用)
  GI/GO    1-128        组输入/输出 (多位整数)
  AI/AO    1-64         模拟输入/输出
  RI/RO    1-64         机器人面板I/O
  UI/UO    1-18         用户操作面板 (UOP)
  SI/SO    1-32         安全I/O
  WI/WO    1-64         焊接I/O

【I/O配置路径】
  Menu > I/O > Config
  
  选择I/O类型后配置:
    Port Type   端口类型 (Digital, Group, Analog)
    Rack        机架号
    Slot        插槽号
    Start       起始信号号
    Number      信号数量

【I/O分配示例 (典型焊接工位)】
  DI[1-8]     PLC→Robot 控制信号
    DI[1] = 工件到位
    DI[2] = 夹具夹紧确认
    DI[3] = 程序选择 Bit0
    DI[4] = 程序选择 Bit1
    DI[5] = 启动信号
    DI[6] = 复位信号
    DI[7] = 安全区确认
    DI[8] = 备用

  DO[1-8]     Robot→PLC 状态信号
    DO[1] = 机器人就绪
    DO[2] = 程序运行中
    DO[3] = 焊接完成
    DO[4] = 异常报警
    DO[5] = 在原位
    DO[6] = 程序号确认 Bit0
    DO[7] = 程序号确认 Bit1
    DO[8] = 备用

  GI[1]       PLC→Robot 程序选择 (8位=256个程序)
  GO[1]       Robot→PLC 当前程序号

【I/O强制 (调试用)】
  Menu > I/O > Digital
  选择信号 > F5[FORCE] > ON/OFF
  
  注意: 强制输出仅用于调试, 不要在生产中使用!
  解除: F5[UNFORCE]

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_ethernet() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC EtherNet/IP Configuration
═══════════════════════════════════════════════════

【概述】
  EtherNet/IP是最常用的工业以太网协议
  支持: Allen-Bradley, Omron, Keyence等PLC
  FANUC可做Scanner(主站)或Adapter(从站)

【机器人做Adapter(从站) — 最常用】
  PLC是Scanner(主站), 机器人被动响应
  
  设置步骤:
  1. Menu > I/O > EtherNet/IP
  2. 设置机器人IP: Menu > Setup > Host Comm > TCP/IP
  3. 配置Adapter:
     - Input Size:  输入字节数 (PLC→Robot)
     - Output Size: 输出字节数 (Robot→PLC)
  4. 映射I/O:
     - 将EtherNet/IP数据映射到DI/DO, GI/GO等
  5. PLC端: 添加FANUC机器人为远程设备
     - Vendor ID: 356 (FANUC)
     - Product Type: 7

【IP配置】
  Menu > Setup > Host Comm > TCP/IP
  
  Robot IP:     192.168.1.10  (示例)
  Subnet Mask:  255.255.255.0
  Gateway:      192.168.1.1
  
  PLC和机器人必须在同一子网!

【I/O映射 — Adapter模式】
  Menu > I/O > EtherNet/IP > Adapter Config
  
  Assembly Instance:
    Input:  101 (PLC读取机器人状态)
    Output: 100 (PLC写入机器人控制)
  
  映射示例:
    Byte 0 Bit 0-7 → DI[1-8]    PLC控制信号
    Byte 1 Bit 0-7 → DI[9-16]   程序选择
    Output Byte 0 → DO[1-8]     机器人状态
    Output Byte 1 → DO[9-16]    故障信息

【机器人做Scanner(主站)】
  Menu > I/O > EtherNet/IP > Scanner Config
  
  添加远程设备:
    Device IP: 远程设备IP
    Input Size / Output Size
    Connection Type: Exclusive Owner

【常用系统变量】
  $EIP_ADAPCFG    Adapter配置
  $EIP_SCNCFG     Scanner配置
  $HOSTCFG[n]     网络配置

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_devicenet() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC DeviceNet Configuration
═══════════════════════════════════════════════════

【概述】
  DeviceNet基于CAN总线, 速率125/250/500Kbps
  常用于连接传感器、阀岛、焊接控制器
  正在被EtherNet/IP替代, 但老产线仍大量使用

【硬件】
  DeviceNet板卡: 安装在控制柜内
  总线电缆: 5芯 (CAN_H, CAN_L, V+, V-, Shield)
  终端电阻: 总线两端各一个121Ω

【设置步骤】
  1. 连接DeviceNet电缆
  2. Menu > I/O > DeviceNet
  3. 设置机器人节点地址 (MAC ID): 0-63
  4. 设置波特率: 匹配网络 (125/250/500K)
  5. 扫描网络: Auto Config
  6. 配置I/O映射

【节点配置】
  Menu > I/O > DeviceNet > Device List
  
  每个设备:
    MAC ID:      节点地址 (0-63)
    Vendor:      厂商
    Device Type: 设备类型
    I/O Size:    数据大小

【I/O映射】
  Menu > I/O > DeviceNet > I/O Allocation
  
  将DeviceNet数据映射到:
    DI/DO (单点)
    GI/GO (组, 多位)

【调试命令】
  Menu > I/O > DeviceNet > Status
  查看:
    网络状态 (Online/Offline)
    各节点通讯状态
    错误计数

【常见问题】
  节点掉线:
    1. 检查接线 (CAN_H和CAN_L不能接反)
    2. 检查终端电阻
    3. 检查波特率一致性
    4. 电缆长度: 125K=500m, 250K=250m, 500K=100m

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_profinet() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC Profinet Configuration
═══════════════════════════════════════════════════

【概述】
  Profinet是西门子主推的工业以太网
  常用于: Siemens S7-1200/1500 + FANUC机器人
  FANUC通过选件或Molex板卡支持

【Molex Profinet板卡】
  安装在控制柜以太网端口
  支持Profinet IO Device (从站)模式

【设置步骤 — 机器人做Device(从站)】
  1. 安装Molex Profinet板卡
  2. 配置IP地址:
     Menu > Setup > Host Comm > TCP/IP
     设置Profinet端口IP (与PLC同网段)
  3. 设置Device Name:
     必须与PLC项目中配置的名字一致!
  4. 导入GSD文件:
     在TIA Portal中导入FANUC的GSD文件
  5. PLC端配置:
     添加FANUC设备, 配置I/O模块
  6. 映射I/O:
     Menu > I/O > Profinet > I/O Allocation

【与Siemens PLC集成要点】
  TIA Portal步骤:
  1. 项目 > 添加新设备 > GSD设备
  2. 导入FANUC GSD文件 (从FANUC获取)
  3. 拖拽FANUC设备到网络视图
  4. 配置设备名 (必须与机器人端一致)
  5. 配置I/O模块和地址
  6. 下载到PLC

  机器人端:
  1. 设备名与PLC端一致
  2. I/O模块大小与PLC端一致
  3. 映射到DI/DO

【注意事项】
  - 设备名区分大小写!
  - 更改配置后需要重启控制器
  - Profinet要求实时性, 避免与普通网络流量混合
  - 建议Profinet使用独立网段

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_handshake() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  PLC-Robot Handshake Programming
═══════════════════════════════════════════════════

【基本握手模式】

  PLC→Robot:
    DI[1] = 工件到位 (Part Ready)
    DI[5] = 启动命令 (Start)
    DI[6] = 复位命令 (Reset)
    GI[1] = 程序号选择 (Program Select)

  Robot→PLC:
    DO[1] = 机器人就绪 (Robot Ready)
    DO[2] = 运行中 (Running)
    DO[3] = 完成 (Complete)
    DO[4] = 异常 (Fault)
    DO[5] = 在原位 (At Home)

【标准生产循环 TP程序】
  /PROG MAIN_CYCLE
   1: !--- 初始化 --- ;
   2: DO[2:Running]=OFF ;
   3: DO[3:Complete]=OFF ;
   4: DO[4:Fault]=OFF ;
   5: DO[1:Ready]=ON ;
   6: DO[5:AtHome]=ON ;
   7: !--- 等待启动 --- ;
   8: WAIT DI[1:PartReady]=ON ;
   9: WAIT DI[5:Start]=ON ;
  10: DO[1:Ready]=OFF ;
  11: DO[5:AtHome]=OFF ;
  12: DO[2:Running]=ON ;
  13: !--- 读取程序号 --- ;
  14: R[1:ProgNo]=GI[1:ProgSelect] ;
  15: !--- 执行对应程序 --- ;
  16: SELECT R[1]=1, CALL PROG_1
  17:        =2, CALL PROG_2
  18:        =3, CALL PROG_3
  19:        ELSE, JMP LBL[99] ;
  20: !--- 完成 --- ;
  21: DO[2:Running]=OFF ;
  22: DO[3:Complete]=ON ;
  23: J PR[1:Home] 30% FINE ;
  24: DO[5:AtHome]=ON ;
  25: !--- 等PLC确认完成 --- ;
  26: WAIT DI[5:Start]=OFF ;
  27: DO[3:Complete]=OFF ;
  28: DO[1:Ready]=ON ;
  29: JMP LBL[1] ;
  30: !--- 异常处理 --- ;
  31: LBL[99] ;
  32: DO[4:Fault]=ON ;
  33: DO[2:Running]=OFF ;
  34: WAIT DI[6:Reset]=ON ;
  35: DO[4:Fault]=OFF ;
  36: J PR[1:Home] 30% FINE ;
  37: JMP LBL[1] ;
  /END

【时序图】
  PLC:  PartReady ─┐     ┌─ Start OFF(确认完成)
                   │     │
  PLC:  Start     ─┘─ON──┘
  
  Robot: Ready ──┐         ┌── Ready ON
                 │ Running │
  Robot: Running ┘─ON──────┘
  
  Robot: Complete          ┌─ Complete ON ─┐
                           │               │
  ─────────────────────────┘               └──

【安全注意】
  1. UOP信号(*IMSTP, *HOLD)必须连接到PLC安全继电器
  2. 急停链路不能只靠软件信号
  3. 安全栅栏(Fence)必须硬接线到安全板
  4. 使用DCS(Dual Check Safety)做安全区域监控

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_uop() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC UOP (User Operator Panel) Signals
═══════════════════════════════════════════════════

【UOP输入 UI[] — PLC→Robot】
  UI[1]  *IMSTP      立即停止 (常闭, OFF=停止)
  UI[2]  *HOLD       暂停 (常闭, OFF=暂停)
  UI[3]  *SFSPD      安全速度 (ON=限制250mm/s)
  UI[4]  *CSTOPI     循环停止输入
  UI[5]  *FAULT RST  故障复位 (上升沿触发)
  UI[6]  *START      程序启动 (上升沿触发)
  UI[7]  *HOME       回原位
  UI[8]  *ENBL       使能 (ON=允许运行)
  UI[9]  RSR1        远程程序选择 Bit1
  UI[10] RSR2        远程程序选择 Bit2
  UI[11] RSR3        远程程序选择 Bit3
  UI[12] RSR4        远程程序选择 Bit4
  UI[13] RSR5        远程程序选择 Bit5
  UI[14] RSR6        远程程序选择 Bit6
  UI[15] RSR7        远程程序选择 Bit7
  UI[16] RSR8        远程程序选择 Bit8
  UI[17] *IMSTP2     第二急停
  UI[18] PROD_START  生产启动

  * = Active Low (常闭, 断开=激活)
  
  注意: UI[1]和UI[2]必须为ON机器人才能运行!
  常见错误: PLC未给UI[1]/UI[2]信号 → 机器人不动

【UOP输出 UO[] — Robot→PLC】
  UO[1]  CMDENBL     命令使能 (机器人可接受命令)
  UO[2]  SYSRDY      系统就绪
  UO[3]  PROGRUN     程序运行中
  UO[4]  PAUSED      暂停中
  UO[5]  HELD        保持中
  UO[6]  FAULT       有故障
  UO[7]  ATPERCH     在原位(HOME)
  UO[8]  TPENBL      示教器有效
  UO[9]  BTALM       电池报警
  UO[10] BUSY        忙

【RSR (Remote Start/Register) 远程启动】
  通过UI[9]-UI[16]选择程序号:
    UI[9]=ON  → RSR 1 → 运行MAIN程序
    UI[10]=ON → RSR 2 → 运行PROG_2
    ...
  
  配合UI[6] START使用:
    1. PLC设置RSR选择位
    2. PLC发START脉冲
    3. 机器人运行对应程序

【PNS (Program Number Select) 程序号选择】
  另一种远程程序选择方式:
  通过GI组输入直接传程序号
  
  设置: Menu > Setup > Prog Select > PNS
  GI[1] = 程序号 (1-255)
  UI[18] PROD_START = 启动

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_troubleshoot() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC PLC Communication Troubleshooting
═══════════════════════════════════════════════════

【机器人不响应PLC启动命令】
  1. 检查UI[1](*IMSTP)和UI[2](*HOLD)是否为ON
     → 这两个常闭信号必须ON, 否则机器人不动!
  2. 检查UI[8](ENBL)是否为ON
  3. 确认机器人在AUTO模式(不是TEACH模式)
  4. 检查示教器开关(TP ON/OFF)
  5. 检查是否有未清除的报警

【EtherNet/IP通讯中断】
  1. Ping测试: Menu > Setup > Host Comm > PING
  2. 检查IP地址和子网掩码
  3. 检查网线和交换机
  4. 检查PLC端Scanner配置
  5. 重启通讯: Menu > I/O > EtherNet/IP > Restart

【DeviceNet节点丢失】
  1. 检查接线(CAN_H/CAN_L不能反)
  2. 检查终端电阻(两端各121Ω)
  3. 检查波特率一致
  4. 检查节点地址不冲突
  5. 检查电缆长度不超限

【Profinet设备不在线】
  1. 设备名必须与PLC配置完全一致(大小写!)
  2. IP在同一子网
  3. GSD文件版本匹配
  4. 重启FANUC控制器
  5. 检查是否有IP冲突

【I/O信号不变化】
  1. 检查I/O映射配置
  2. 检查物理接线
  3. 强制测试: Menu > I/O > Force
  4. 检查信号是否被其他程序占用
  5. 检查PLC梯形图逻辑

【HOST报警】
  HOST-004 (Tag not found):
    → 检查Host Comm配置中的tag名
  HOST-011 (Connection failed):
    → Ping目标, 检查IP和端口
  HOST-017 (FTP timeout):
    → 检查FTP服务器, 增加超时时间

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_help() {
  cat << 'EOF'
fanuc-plc — FANUC PLC Communication & Integration

Commands:
  io              I/O types and configuration
  ethernet        EtherNet/IP setup
  devicenet       DeviceNet setup
  profinet        Profinet setup
  handshake       PLC-Robot handshake programming
  uop             UOP signal reference
  troubleshoot    Communication troubleshooting
  help            Show this help

Examples:
  bash scripts/script.sh handshake
  bash scripts/script.sh uop
  bash scripts/script.sh ethernet
  bash scripts/script.sh troubleshoot

Powered by BytesAgain | bytesagain.com

Related:
  clawhub install fanuc-alarm     Alarm codes (2607, incl. HOST)
  clawhub install fanuc-tp        TP programming
  clawhub install fanuc-karel     KAREL (socket comm)
  Browse all: bytesagain.com
EOF
}

case "${1:-help}" in
  io)           cmd_io ;;
  ethernet)     cmd_ethernet ;;
  devicenet)    cmd_devicenet ;;
  profinet)     cmd_profinet ;;
  handshake)    cmd_handshake ;;
  uop)          cmd_uop ;;
  troubleshoot) cmd_troubleshoot ;;
  help|*)       cmd_help ;;
esac

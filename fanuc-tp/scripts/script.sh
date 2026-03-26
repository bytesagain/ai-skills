#!/usr/bin/env bash
set -euo pipefail

# FANUC TP Programming Reference
# Data extracted from FANUC R-30iA official manuals

cmd_motion() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC TP Motion Instructions
═══════════════════════════════════════════════════

【关节运动 Joint Move】
  J P[1] 100% FINE
  J P[1] 50% CNT100
  J PR[1] 100% FINE

  - 速度: 1-100% (关节速度百分比)
  - 终止: FINE(精确到位) / CNT0-100(连续运动)

【直线运动 Linear Move】
  L P[1] 1000mm/sec FINE
  L P[1] 100cm/min FINE
  L P[1] 50% FINE
  L PR[1] 500mm/sec CNT50

  - 速度: mm/sec, cm/min, inch/min, 或 %
  - TCP沿直线路径移动

【圆弧运动 Circular Move】
  C P[1]
    P[2] 100mm/sec FINE

  - P[1]=经过点, P[2]=终点
  - 三点定圆弧(起点+经过点+终点)

【附加运动选项】
  J P[1] 100% FINE ACC80        加减速倍率
  L P[1] 100mm/sec FINE COORD   协调运动
  L P[1] 100mm/sec CNT50 Offset PR[1]  偏移
  L P[1] 100mm/sec FINE Tool_Offset PR[2]  工具偏移
  J P[1] 100% FINE WJNT         关节插补(避奇异点)
  L P[1] 100mm/sec FINE INC      增量运动

【终止类型说明】
  FINE    精确到位, 完全停止后执行下一条
  CNT0    连续, 最小圆弧过渡
  CNT50   连续, 中等圆弧过渡
  CNT100  连续, 最大圆弧过渡(最快但偏差最大)

【速度单位换算】
  1 mm/sec = 0.1 cm/min × 600
  100% ≈ 各轴最大速度

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_io() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC TP I/O Instructions
═══════════════════════════════════════════════════

【数字I/O】
  DI[1]         数字输入 (只读)
  DO[1]=ON      数字输出 置ON
  DO[1]=OFF     数字输出 置OFF
  DO[1]=PULSE,0.5sec   脉冲输出0.5秒

【机器人I/O】
  RI[1]         机器人输入 (控制柜面板)
  RO[1]=ON      机器人输出

【组I/O (多位)】
  GI[1]         组输入 (多个DI组合成整数)
  GO[1]=5       组输出 (输出整数值到多个DO)

【模拟I/O】
  AI[1]         模拟输入 (0-10V或4-20mA)
  AO[1]=50      模拟输出 (百分比或工程值)

【UOP (外部用户操作面板)】
  UI[1]         用户操作面板输入
  UO[1]=ON      用户操作面板输出
  
  常用UOP信号:
    UI[1]  *IMSTP    立即停止(常闭)
    UI[2]  *HOLD     暂停
    UI[3]  *SFSPD    安全速度
    UI[4]  *CSTOPI   循环停止输入
    UI[5]  *FAULT    故障复位
    UI[6]  *START    程序启动
    UI[7]  *HOME     回原点
    UI[8]  *ENBL     使能
    UI[17] *IMSTP2   第二急停
    UO[1]  CMDENBL   命令使能
    UO[2]  SYSRDY    系统就绪
    UO[3]  PROGRUN   程序运行中
    UO[4]  PAUSED    暂停中
    UO[5]  HELD      保持中
    UO[6]  FAULT     故障
    UO[7]  ATPERCH   在原位
    UO[8]  TPENBL    示教器有效
    UO[9]  BTALM     电池报警
    UO[10] BUSY      忙

【条件等待】
  WAIT DI[1]=ON
  WAIT DI[1]=ON TIMEOUT,LBL[5]  超时跳转
  WAIT 1.00(sec)                延时等待

【I/O配置路径】
  Menu > I/O > Config > 选择类型配置

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_register() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC TP Register Reference
═══════════════════════════════════════════════════

【数值寄存器 R[]】
  R[1]=0          赋值
  R[1]=R[2]+R[3]  算术运算
  R[1]=R[2]*3     乘法
  R[1]=DI[1]      读取I/O值
  R[1]=AR[1]      读取模拟值
  
  运算符: +, -, *, /, DIV(整除), MOD(取余)
  范围: R[1]-R[200] (可扩展)

【位置寄存器 PR[]】
  PR[1]=P[1]            复制位置
  PR[1]=LPOS            当前直角坐标位置
  PR[1]=JPOS            当前关节坐标位置
  PR[1,1]=100.0         修改X分量
  PR[1,2]=200.0         修改Y分量
  PR[1,3]=300.0         修改Z分量
  PR[1,4]=0.0           修改W(Rx)分量
  PR[1,5]=0.0           修改P(Ry)分量
  PR[1,6]=0.0           修改R(Rz)分量
  
  分量: 1=X, 2=Y, 3=Z, 4=W, 5=P, 6=R
  范围: PR[1]-PR[100] (可扩展)

【字符串寄存器 SR[]】
  SR[1]='Hello'         字符串赋值
  用于消息显示、文件名等

【参数寄存器 AR[] (模拟)】
  AR[1]                 模拟输入寄存器

【Flag 标志】
  F[1]=ON              设置标志
  F[1]=OFF             清除标志
  IF F[1]=ON, JMP LBL[1]  条件判断

【Timer 定时器】
  TIMER[1]=START       开始计时
  TIMER[1]=STOP        停止计时
  TIMER[1]=RESET       清零
  R[1]=TIMER[1]        读取时间(毫秒)

【OVERRIDE 速度倍率】
  OVERRIDE=50%         设置全局速度倍率

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_flow() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC TP Flow Control Instructions
═══════════════════════════════════════════════════

【条件判断 IF】
  IF R[1]=1, JMP LBL[10]
  IF R[1]>10, CALL SUBPROG
  IF DI[1]=ON, DO[1]=ON
  IF R[1]<>0, JMP LBL[5]       不等于
  IF F[1]=ON, JMP LBL[1]

  运算符: =, <>, <, >, <=, >=
  动作: JMP LBL[], CALL, 赋值

【多分支 SELECT】
  SELECT R[1]=1, JMP LBL[1]
         =2, JMP LBL[2]
         =3, JMP LBL[3]
         ELSE, JMP LBL[99]

【跳转/标签 JMP/LBL】
  LBL[1]                标签定义
  JMP LBL[1]            无条件跳转
  JMP LBL[R[1]]         间接跳转(寄存器值做标签号)

【子程序调用 CALL】
  CALL SUBPROG           调用子程序
  CALL SUBPROG(1,2,3)    带参数调用
  CALL SUBPROG(R[1])     寄存器做参数
  
  注意: 最大嵌套深度约15-20层

【循环 FOR/ENDFOR】
  FOR R[1]=1 TO 10
    ...
  ENDFOR

【等待 WAIT】
  WAIT 1.00(sec)                    延时
  WAIT DI[1]=ON                     条件等待(无限)
  WAIT DI[1]=ON TIMEOUT,LBL[5]     带超时
  WAIT R[1]>=10 TIMEOUT,LBL[5]     数值条件

【程序结束】
  END                   程序正常结束
  ABORT                 程序异常终止
  PAUSE                 程序暂停

【消息显示】
  MESSAGE[comment text]  在TP上显示消息

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_frame() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC TP Coordinate Frames
═══════════════════════════════════════════════════

【坐标系类型】
  JOINT   关节坐标系 — 各轴独立控制(J1-J6)
  JGFRM   笛卡尔坐标系 — XYZ+WPR, 相对于世界坐标
  WORLD   世界坐标系 — 固定参考坐标系
  TOOL    工具坐标系 — 相对于TCP
  USER    用户坐标系 — 自定义参考系

【工具坐标 UTOOL】
  设置: Menu > Setup > Frames > Tool Frame
  
  三点法TCP标定:
    1. 选择三个不同姿态指向同一点
    2. 机器人计算TCP位置
    3. UTOOL_NUM=1 选择工具号
  
  六点法(含方向):
    1. 三个点定TCP位置
    2. 三个点定工具方向(X/Z轴)
  
  直接输入:
    Menu > Setup > Frames > Tool Frame
    手动输入X,Y,Z,W,P,R偏移值

  TP程序中切换:
    UTOOL_NUM=1          选择工具1
    UTOOL_NUM=R[1]       间接选择

【用户坐标 UFRAME】
  设置: Menu > Setup > Frames > User Frame
  
  三点法:
    1. 原点(Origin Point)
    2. X方向点(X Direction Point)
    3. Y方向点(Y Direction Point, 不要求精确在Y轴上)
  
  四点法:
    1. 原点
    2. X方向
    3. Y方向
    4. Z方向(更精确)

  TP程序中切换:
    UFRAME_NUM=1         选择用户坐标1
    UFRAME_NUM=R[1]      间接选择

【系统变量】
  $MNUTOOL[1,i]          工具坐标数据(i=1-10)
  $MNUTOOLNUM[group]     当前工具号
  $MNUFRAME[1,i]         用户坐标数据(i=1-9)
  $MNUFRAMENUM[1]        当前用户坐标号
  $USE_UFRAME            是否使用用户坐标

【手动进给坐标切换】
  按COORD键循环切换: JOINT→JGFRM→WORLD→TOOL→USER

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_sysvar() {
  local keyword="${1:-}"
  if [ -z "$keyword" ]; then
    cat << 'EOF'
Usage: bash scripts/script.sh sysvar <keyword>
Example: bash scripts/script.sh sysvar MNUTOOL
Example: bash scripts/script.sh sysvar OVERRIDE
Example: bash scripts/script.sh sysvar PAYLOAD

Common system variables:
  $MNUTOOLNUM    当前工具坐标号
  $MNUFRAMENUM   当前用户坐标号
  $MCR.$GENOVERRIDE  全局速度倍率
  $SCR.$MAXRPI   最大转速
  $PAYLOAD       有效载荷设置
  $GROUP[g].$UFRAME  用户坐标
  $GROUP[g].$UTOOL   工具坐标
  $CURPOS        当前位置(直角坐标)
  $CURJPOS       当前位置(关节坐标)
  $DP_SPEED      当前速度
  $TIMER[i]      定时器值
  $FAST_CLOCK    系统时钟(毫秒)
  $MOR_GRP[g].$CURRENT_ANG  当前关节角度
EOF
    return 0
  fi

  KEYWORD="$keyword" python3 << 'PYEOF'
import os
kw = os.environ["KEYWORD"].lower()

# Common system variables database
sysvars = [
    ("$MNUTOOLNUM[group]", "当前工具坐标系号 (1-10)", "INTEGER"),
    ("$MNUFRAMENUM[1]", "当前用户坐标系号 (1-9)", "INTEGER"),
    ("$MNUTOOL[1,i]", "工具坐标系数据", "POSITION"),
    ("$MNUFRAME[1,i]", "用户坐标系数据", "POSITION"),
    ("$MCR.$GENOVERRIDE", "全局速度倍率 (%)", "INTEGER"),
    ("$MCR.$T_CYC", "循环时间", "REAL"),
    ("$PAYLOAD[group]", "有效载荷设置", "STRUCTURE"),
    ("$GROUP[g].$UFRAME", "组的用户坐标", "POSITION"),
    ("$GROUP[g].$UTOOL", "组的工具坐标", "POSITION"),
    ("$GROUP[g].$UFRAME_NUM", "组的用户坐标号", "INTEGER"),
    ("$GROUP[g].$UTOOL_NUM", "组的工具坐标号", "INTEGER"),
    ("$CURPOS", "当前位置(直角坐标)", "POSITION"),
    ("$CURJPOS", "当前位置(关节坐标)", "JOINTPOS"),
    ("$DP_SPEED", "当前速度", "REAL"),
    ("$TIMER[i].$TIMER_VAL", "定时器值(毫秒)", "INTEGER"),
    ("$FAST_CLOCK", "系统时钟(毫秒,32位)", "INTEGER"),
    ("$SHELL_CLOCK", "系统时钟(秒)", "INTEGER"),
    ("$SCR.$MAXRPI[g]", "最大转速限制", "INTEGER"),
    ("$SCR.$NUM_GROUP", "运动组数", "INTEGER"),
    ("$AUTOINIT", "自动初始化", "BOOLEAN"),
    ("$USE_UFRAME", "使用用户坐标系", "BOOLEAN"),
    ("$RO_DIS_ALM", "机器人过行程禁止报警", "BOOLEAN"),
    ("$PARAM_GROUP[g].$SV_DMY_LNK", "虚拟轴设置", "INTEGER"),
    ("$PARAM_GROUP[g].$SV_OFF_ALL", "伺服关闭所有轴", "BOOLEAN"),
    ("$PARAM_GROUP[g].$ACC_DEF", "默认加速度", "INTEGER"),
    ("$PARAM_GROUP[g].$ACC_MAX", "最大加速度", "INTEGER"),
    ("$SOFTPART[g].$AXIS_LIMIT", "软限位设置", "STRUCTURE"),
    ("$SOFTPART[g].$UPPERL[i]", "软限位上限(轴i)", "REAL"),
    ("$SOFTPART[g].$LOWERL[i]", "软限位下限(轴i)", "REAL"),
    ("$DMR_GRP[g].$MASTER_DONE", "原点校正完成标志", "BOOLEAN"),
    ("$DMR_GRP[g].$MASTER_COUN", "原点校正脉冲数", "INTEGER"),
    ("$COLL_GUARD.$THRESH[g]", "碰撞检测阈值", "INTEGER"),
    ("$COLL_GUARD.$ENABLE", "碰撞检测使能", "BOOLEAN"),
    ("$KAREL_ENB", "KAREL程序使能", "BOOLEAN"),
    ("$PROG_NAME", "当前运行程序名", "STRING"),
    ("$LINE_NUM", "当前行号", "INTEGER"),
    ("$CYCLE_COUNT", "循环计数器", "INTEGER"),
    ("$TPP.$MAX_LINE", "TP程序最大行数", "INTEGER"),
    ("$ERR_NUM", "最近错误号", "INTEGER"),
    ("$SPEED", "当前速度设置", "REAL"),
    ("$TERMTYPE", "当前终止类型", "INTEGER"),
    ("$USEMAXSPD[g]", "使用最大速度", "BOOLEAN"),
    ("$USERFRAME", "用户坐标系数据", "POSITION"),
    ("$USERTOOL", "工具坐标系数据", "POSITION"),
]

found = [s for s in sysvars if kw in s[0].lower() or kw in s[1].lower()]
if not found:
    print(f"No system variables matching '{kw}'")
    print("Try broader keywords like: tool, frame, speed, payload, collision, timer")
else:
    print(f"Found {len(found)} variable(s) matching '{kw}':\n")
    for name, desc, typ in found:
        print(f"  {name}")
        print(f"    {desc}")
        print(f"    Type: {typ}")
        print()

print("📖 More FANUC skills: bytesagain.com")
PYEOF
}

cmd_template() {
  local tmpl="${1:-}"
  case "$tmpl" in
    pick-place|pick|place)
      cat << 'EOF'
/PROG PICK_PLACE
/ATTR
/MN
   1: !Pick and Place Template ;
   2: UTOOL_NUM=1 ;
   3: UFRAME_NUM=1 ;
   4: OVERRIDE=100% ;
   5: !--- Move to Home --- ;
   6: J PR[1:Home] 50% FINE ;
   7: !--- Approach Pick --- ;
   8: L P[1:Pick Approach] 500mm/sec FINE ;
   9: L P[2:Pick Point] 200mm/sec FINE ;
  10: !--- Grip --- ;
  11: WAIT 0.10(sec) ;
  12: DO[1:Gripper Close]=ON ;
  13: WAIT 0.30(sec) ;
  14: WAIT DI[1:Grip Confirm]=ON TIMEOUT,LBL[99] ;
  15: !--- Retract from Pick --- ;
  16: L P[1:Pick Approach] 500mm/sec FINE ;
  17: !--- Approach Place --- ;
  18: L P[3:Place Approach] 500mm/sec FINE ;
  19: L P[4:Place Point] 200mm/sec FINE ;
  20: !--- Release --- ;
  21: WAIT 0.10(sec) ;
  22: DO[1:Gripper Close]=OFF ;
  23: WAIT 0.30(sec) ;
  24: !--- Retract from Place --- ;
  25: L P[3:Place Approach] 500mm/sec FINE ;
  26: !--- Back to Home --- ;
  27: J PR[1:Home] 50% FINE ;
  28: END ;
  29: !--- Error Handler --- ;
  30: LBL[99] ;
  31: MESSAGE[Grip timeout!] ;
  32: PAUSE ;
/POS
/END
EOF
      ;;
    spotweld|spot)
      cat << 'EOF'
/PROG SPOT_WELD
/ATTR
/MN
   1: !Spot Welding Template ;
   2: UTOOL_NUM=1 ;
   3: UFRAME_NUM=1 ;
   4: OVERRIDE=100% ;
   5: R[1:Weld Count]=0 ;
   6: !--- Home --- ;
   7: J PR[1:Home] 30% FINE ;
   8: !--- Weld Point 1 --- ;
   9: L P[1:Approach1] 1000mm/sec CNT100 ;
  10: L P[2:Weld1] 250mm/sec FINE ;
  11: SPOT[1:Schedule1] ;
  12: R[1:Weld Count]=R[1]+1 ;
  13: L P[1:Approach1] 500mm/sec CNT100 ;
  14: !--- Weld Point 2 --- ;
  15: L P[3:Approach2] 1000mm/sec CNT100 ;
  16: L P[4:Weld2] 250mm/sec FINE ;
  17: SPOT[1:Schedule1] ;
  18: R[1:Weld Count]=R[1]+1 ;
  19: L P[3:Approach2] 500mm/sec CNT100 ;
  20: !--- Home --- ;
  21: J PR[1:Home] 30% FINE ;
  22: MESSAGE[Welds done] ;
  23: END ;
/POS
/END
EOF
      ;;
    arcweld|arc)
      cat << 'EOF'
/PROG ARC_WELD
/ATTR
/MN
   1: !Arc Welding Template ;
   2: UTOOL_NUM=1 ;
   3: UFRAME_NUM=1 ;
   4: OVERRIDE=100% ;
   5: !--- Home --- ;
   6: J PR[1:Home] 30% FINE ;
   7: !--- Approach --- ;
   8: L P[1:Approach] 1000mm/sec FINE ;
   9: !--- Weld Start --- ;
  10: L P[2:Weld Start] 500mm/sec FINE ;
  11: Arc Start[1] ;
  12: !--- Weld Path --- ;
  13: L P[3:Weld Mid] 30cm/min FINE ;
  14: L P[4:Weld End] 30cm/min FINE ;
  15: Arc End[1] ;
  16: !--- Retract --- ;
  17: L P[5:Retract] 500mm/sec FINE ;
  18: !--- Home --- ;
  19: J PR[1:Home] 30% FINE ;
  20: END ;
/POS
/END

Notes:
  Arc Start[1] = 焊接条件1号 (电流/电压/速度)
  焊接速度用 cm/min 常见: 20-60 cm/min
  FINE终止确保焊缝精度
EOF
      ;;
    *)
      echo "Available templates:"
      echo "  pick-place  — Pick and place with gripper"
      echo "  spotweld    — Spot welding cycle"
      echo "  arcweld     — Arc welding seam"
      echo ""
      echo "Usage: bash scripts/script.sh template <name>"
      ;;
  esac
  echo ""
  echo "📖 More FANUC skills: bytesagain.com"
}

cmd_search() {
  local keyword="${1:-}"
  if [ -z "$keyword" ]; then
    echo "Usage: bash scripts/script.sh search <keyword>"
    return 1
  fi
  echo "Searching all reference data for '$keyword'..."
  echo ""
  # Search through all command outputs
  for cmd in motion io register flow frame; do
    result=$(cmd_$cmd 2>/dev/null | grep -i "$keyword" || true)
    if [ -n "$result" ]; then
      echo "=== Found in: $cmd ==="
      echo "$result"
      echo ""
    fi
  done
  # Also search system variables
  result=$(cmd_sysvar "$keyword" 2>/dev/null | grep -v "^$" || true)
  if [ -n "$result" ]; then
    echo "=== Found in: sysvar ==="
    echo "$result"
  fi
}

cmd_help() {
  cat << 'EOF'
fanuc-tp — FANUC TP Programming Reference

Commands:
  motion             Motion instructions (J, L, C, A moves)
  io                 I/O instructions (DI, DO, RI, RO, GI, GO, AI, AO, UOP)
  register           Register types (R[], PR[], SR[], Flag, Timer)
  flow               Flow control (IF, SELECT, FOR, JMP/LBL, CALL)
  frame              Coordinate frames (UTOOL, UFRAME, calibration)
  sysvar <keyword>   System variable lookup
  template <type>    TP program templates (pick-place, spotweld, arcweld)
  search <keyword>   Search all reference data
  help               Show this help

Examples:
  bash scripts/script.sh motion
  bash scripts/script.sh sysvar payload
  bash scripts/script.sh template pick-place
  bash scripts/script.sh search "CNT"

Powered by BytesAgain | bytesagain.com

Related:
  clawhub install fanuc-alarm     Alarm codes (2607)
  clawhub install fanuc-karel     KAREL reference
  clawhub install fanuc-spotweld  Spot welding
  clawhub install fanuc-arcweld   Arc welding
  Browse all: bytesagain.com
EOF
}

case "${1:-help}" in
  motion)    cmd_motion ;;
  io)        cmd_io ;;
  register)  cmd_register ;;
  flow)      cmd_flow ;;
  frame)     cmd_frame ;;
  sysvar)    shift; cmd_sysvar "$@" ;;
  template)  shift; cmd_template "$@" ;;
  search)    shift; cmd_search "$@" ;;
  help|*)    cmd_help ;;
esac

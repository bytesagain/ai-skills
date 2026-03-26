#!/usr/bin/env bash
set -euo pipefail

# FANUC KAREL Programming Reference
# Data extracted from FANUC KAREL Reference Manual

cmd_syntax() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC KAREL Language Syntax
═══════════════════════════════════════════════════

【程序结构】
  PROGRAM prog_name
  %COMMENT = 'Program description'
  %NOLOCKGROUP
  %ENVIRONMENT UIF
  
  VAR
    i : INTEGER
    x : REAL
    s : STRING[32]
    pos1 : POSITION
  
  BEGIN
    -- 主程序代码
    WRITE('Hello World', CR)
  END prog_name

【变量声明】
  VAR
    count    : INTEGER      -- 整数
    speed    : REAL          -- 浮点数
    name     : STRING[64]   -- 字符串(最大长度)
    flag     : BOOLEAN      -- 布尔
    p1       : POSITION     -- 位置(直角坐标)
    jp1      : JOINTPOS     -- 关节位置
    v1       : VECTOR       -- 三维向量(X,Y,Z)
    arr      : ARRAY[10] OF INTEGER  -- 数组

【控制结构】
  -- IF/THEN/ELSE
  IF count > 10 THEN
    WRITE('big', CR)
  ELSE
    WRITE('small', CR)
  ENDIF

  -- FOR循环
  FOR i = 1 TO 10 DO
    R[i] = 0
  ENDFOR

  -- WHILE循环
  WHILE DIN[1] = OFF DO
    DELAY 100    -- 延时100毫秒
  ENDWHILE

  -- SELECT (多分支)
  SELECT mode OF
    CASE(1): WRITE('Auto', CR)
    CASE(2): WRITE('Manual', CR)
    ELSE:    WRITE('Unknown', CR)
  ENDSELECT

【子程序/函数】
  ROUTINE my_sub
  VAR
    local_var : INTEGER
  BEGIN
    -- 子程序代码
  END my_sub

  ROUTINE calc_dist(p1: POSITION; p2: POSITION): REAL
  VAR
    dist : REAL
  BEGIN
    dist = SQRT((p1.x-p2.x)**2 + (p1.y-p2.y)**2 + (p1.z-p2.z)**2)
    RETURN(dist)
  END calc_dist

【编译指令 (Directives)】
  %COMMENT = 'description'     -- 程序描述
  %NOLOCKGROUP                 -- 不锁定运动组
  %LOCKGROUP = 1               -- 锁定运动组1
  %ENVIRONMENT UIF             -- 使用UIF环境
  %ENVIRONMENT FLBT            -- 文件操作环境
  %ENVIRONMENT KCLOP           -- KCL命令环境
  %INCLUDE kliotyps            -- 包含类型定义
  %CMOSVARS                    -- 变量存CMOS(断电保持)
  %NOPAUSE = ERROR + COMMAND   -- 错误不暂停
  %NOBUSYLAMP                  -- 不亮忙灯

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_types() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC KAREL Data Types
═══════════════════════════════════════════════════

【基本类型】
  INTEGER     整数 (-2147483648 to 2147483647)
  REAL        浮点数 (±3.4E38, 精度6-7位)
  BOOLEAN     布尔 (TRUE/FALSE)
  STRING[n]   字符串 (最大254字符)

【位置类型】
  POSITION    直角坐标位置
    .x, .y, .z        位置分量 (mm)
    .w, .p, .r         姿态分量 (度)
    .config_data       构型数据 (FLIP/NOFLIP等)
  
  JOINTPOS    关节坐标位置
    各轴角度值 (度)
  
  XYZWPR      直角坐标(含构型)
    同POSITION, 常用于赋值

  VECTOR      三维向量
    .x, .y, .z        分量

【位置操作】
  pos1 = CURPOS(0,0)          -- 获取当前直角坐标
  jpos1 = CURJPOS(0,0)        -- 获取当前关节坐标
  pos1.x = 100.0              -- 修改X分量
  pos1 = POS(100,200,300,0,0,0,cfg)  -- 构造位置
  CNV_JPOS_REL(jpos, real_arr, STATUS)  -- 关节位置转数组
  CNV_REL_JPOS(real_arr, jpos, STATUS)  -- 数组转关节位置

【I/O访问】
  DIN[n]      数字输入 (BOOLEAN)
  DOUT[n]     数字输出 (BOOLEAN)
  GIN[n]      组输入 (INTEGER)
  GOUT[n]     组输出 (INTEGER)
  AIN[n]      模拟输入 (INTEGER, 0-10000)
  AOUT[n]     模拟输出 (INTEGER, 0-10000)
  FLG[n]      标志 (BOOLEAN)
  R[n]        数值寄存器 (REAL)
  PR[n]       位置寄存器 (POSITION)
  SR[n]       字符串寄存器 (STRING)

【数组】
  arr : ARRAY[100] OF INTEGER
  arr[1] = 10
  -- 索引从1开始, 不是0
  
  pos_arr : ARRAY[50] OF POSITION
  pos_arr[1] = CURPOS(0,0)

【自定义类型】
  TYPE
    weld_data = STRUCTURE
      current : REAL
      voltage : REAL
      speed   : REAL
    ENDSTRUCTURE
  
  VAR
    wd : weld_data

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_builtin() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC KAREL Built-in Routines
═══════════════════════════════════════════════════

【数学】
  ABS(x)              绝对值
  SQRT(x)             平方根
  SIN(x), COS(x)      三角函数(角度)
  ATAN2(y, x)          反正切
  EXP(x), LN(x)       指数/对数
  ROUND(x)            四舍五入
  TRUNC(x)            截断取整

【字符串】
  SUB_STR(str, start, len)  子串
  STR_LEN(str)              长度
  CNV_INT_STR(int, width, str)     整数转字符串
  CNV_REAL_STR(real, width, dec, str)  实数转字符串
  CNV_STR_INT(str, int)     字符串转整数
  CNV_STR_REAL(str, real)   字符串转实数
  INDEX(str, sub)            查找子串位置

【位置操作】
  CURPOS(group, uframe)      当前直角坐标
  CURJPOS(group, uframe)     当前关节坐标
  POS(x,y,z,w,p,r,cfg)      构造位置
  FRAME(p1,p2,p3,frame,STATUS)  三点定坐标系
  INV(position)              位置求逆
  pos1:pos2                  位置复合(乘)
  
  GET_POS_REG(reg_no, pos, STATUS)   读PR[]
  SET_POS_REG(reg_no, pos, STATUS)   写PR[]
  GET_REG(reg_no, is_real, int_val, real_val, STATUS)  读R[]
  SET_REG(reg_no, value, STATUS)     写R[]

【运动控制】
  MOVE TO pos1                直线运动
  MOVE JOINT TO pos1          关节运动
  MOVE ALONG path             路径运动
  MOVE NEAR pos1 BY 50        接近点(偏移50mm)
  CANCEL                      取消运动
  
  SET_SPEED(group, speed, STATUS)     设置速度
  SET_OVERRIDE(group, ovrd, STATUS)   设置倍率

【I/O操作】
  SET_PORT_SIG(port_type, port_no, value, STATUS)  设置端口
  GET_PORT_SIG(port_type, port_no, value, STATUS)  读取端口
  CONNECT SIGNAL di_var TO DIN[n]     连接信号
  DISCONNECT SIGNAL di_var            断开信号

【系统】
  DELAY msec                 延时(毫秒)
  GET_TIME(time_int)         获取系统时间
  SET_VAR(entry, var_name, value, STATUS)  设置系统变量
  GET_VAR(entry, var_name, value, STATUS)  读取系统变量
  PROG_LIST(prog_name, attr, STATUS)  程序列表
  KCL(command_str, STATUS)    执行KCL命令
  FORCE_SPMENU(screen, form)  切换TP画面

【文件操作】
  OPEN FILE f1('RW', 'filename.dt')   打开文件
  READ f1(data)                        读取
  WRITE f1(data)                       写入
  CLOSE FILE f1                        关闭
  FILE_LIST('path', attr, STATUS)      文件列表
  COPY_FILE('src', 'dst', STATUS)      复制文件
  RENAME_FILE('old', 'new', STATUS)    重命名
  DELETE_FILE('path', STATUS)          删除文件

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_fileio() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC KAREL File I/O
═══════════════════════════════════════════════════

【打开文件】
  VAR f1 : FILE
  
  OPEN FILE f1('RW', 'UD1:mydata.dt')    -- USB设备
  OPEN FILE f1('RO', 'FR:mydata.dt')     -- FROM存储
  OPEN FILE f1('RW', 'MC:log.csv')       -- 内存卡
  OPEN FILE f1('AP', 'UD1:log.txt')      -- 追加模式
  
  模式: 'RO'=只读, 'RW'=读写, 'AP'=追加

【设备代号】
  UD1:    USB设备(U盘)
  FR:     FROM存储(控制器闪存)
  MC:     内存卡
  RD:     RAM盘
  
【写入】
  WRITE f1('Count: ', count, CR)
  WRITE f1(real_val::8::2, CR)     -- 格式化: 宽度8, 小数2位
  WRITE f1(str_val, ',', int_val, CR)  -- CSV格式

【读取】
  READ f1(str_val)                 -- 读字符串
  READ f1(int_val)                 -- 读整数
  READ f1(real_val)                -- 读实数
  READ f1(str_val, int_val, CR)    -- 读一行多值

【关闭】
  CLOSE FILE f1

【错误检查】
  STATUS = IO_STATUS(f1)
  IF STATUS <> 0 THEN
    WRITE('File error: ', STATUS, CR)
  ENDIF

【完整示例 — CSV数据记录】
  PROGRAM log_data
  %NOLOCKGROUP
  VAR
    f1     : FILE
    i      : INTEGER
    STATUS : INTEGER
  BEGIN
    OPEN FILE f1('AP','UD1:weld_log.csv')
    STATUS = IO_STATUS(f1)
    IF STATUS = 0 THEN
      FOR i = 1 TO 10 DO
        WRITE f1(i, ',', R[i]::8::2, ',', CURPOS(0,0).x::8::2, CR)
      ENDFOR
      CLOSE FILE f1
    ELSE
      WRITE('Cannot open file', CR)
    ENDIF
  END log_data

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_socket() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC KAREL Socket Communication
═══════════════════════════════════════════════════

【配置】
  Menu > Setup > Host Comm > SHOW > Servers
  Tag: S1
  Protocol: SM (Socket Messaging)
  Port: 49152 (或自定义)
  
  Menu > Setup > Host Comm > SHOW > Clients
  Tag: C1
  Protocol: SM
  Remote IP: 192.168.1.100
  Remote Port: 49152

【TCP Server 模板】
  PROGRAM tcp_server
  %COMMENT = 'TCP Server'
  %NOLOCKGROUP
  %ENVIRONMENT FLBT
  
  VAR
    f1       : FILE
    STATUS   : INTEGER
    recv_str : STRING[128]
    send_str : STRING[128]
  
  BEGIN
    -- 打开服务端tag
    SET_VAR(entry, '*SYSTEM*', '$HOSTS_CFG[1].$SERVER_PORT', 49152, STATUS)
    
    MSG_CONNECT('S1:', STATUS)
    IF STATUS <> 0 THEN
      WRITE('Connect failed:', STATUS, CR)
      RETURN
    ENDIF
    
    OPEN FILE f1('RW', 'S1:')
    STATUS = IO_STATUS(f1)
    IF STATUS <> 0 THEN
      WRITE('Open failed:', STATUS, CR)
      RETURN
    ENDIF
    
    WRITE('Server started, waiting...', CR)
    
    -- 接收循环
    WHILE TRUE DO
      READ f1(recv_str)
      STATUS = IO_STATUS(f1)
      IF STATUS <> 0 THEN
        WRITE('Connection closed', CR)
        GOTO cleanup
      ENDIF
      
      WRITE('Received: ', recv_str, CR)
      
      -- 处理命令
      IF recv_str = 'GETPOS' THEN
        send_str = ''
        CNV_REAL_STR(CURPOS(0,0).x, 8, 2, send_str)
        WRITE f1(send_str, CR)
      ENDIF
      IF recv_str = 'QUIT' THEN
        WRITE f1('BYE', CR)
        GOTO cleanup
      ENDIF
    ENDWHILE
    
    cleanup::
    CLOSE FILE f1
    MSG_DISCO('S1:', STATUS)
  END tcp_server

【TCP Client 模板】
  PROGRAM tcp_client
  %COMMENT = 'TCP Client'
  %NOLOCKGROUP
  %ENVIRONMENT FLBT
  
  VAR
    f1       : FILE
    STATUS   : INTEGER
    recv_str : STRING[128]
  
  BEGIN
    MSG_CONNECT('C1:', STATUS)
    IF STATUS <> 0 THEN
      WRITE('Connect failed:', STATUS, CR)
      RETURN
    ENDIF
    
    OPEN FILE f1('RW', 'C1:')
    
    -- 发送数据
    WRITE f1('Hello from robot', CR)
    
    -- 接收回复
    READ f1(recv_str)
    WRITE('Reply: ', recv_str, CR)
    
    CLOSE FILE f1
    MSG_DISCO('C1:', STATUS)
  END tcp_client

【常用Socket函数】
  MSG_CONNECT(tag, STATUS)     建立连接
  MSG_DISCO(tag, STATUS)       断开连接
  MSG_PING(ip_str, STATUS)     Ping测试

【调试技巧】
  1. 先用PC端netcat测试: nc -l 49152
  2. 检查IP: Menu > Setup > Host Comm > SHOW > TCP/IP
  3. Ping测试: MSG_PING('192.168.1.100', STATUS)
  4. 端口范围: 49152-65535 (避免冲突)

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_template() {
  local tmpl="${1:-}"
  case "$tmpl" in
    basic)
      cat << 'EOF'
PROGRAM basic_template
%COMMENT = 'Basic KAREL Template'
%NOLOCKGROUP
%ENVIRONMENT UIF

VAR
  i      : INTEGER
  STATUS : INTEGER

BEGIN
  -- 初始化
  WRITE('Program started', CR)
  
  -- 读取寄存器
  GET_REG(1, FALSE, i, 0.0, STATUS)
  WRITE('R[1] = ', i, CR)
  
  -- 设置输出
  DOUT[1] = ON
  DELAY 500
  DOUT[1] = OFF
  
  -- 完成
  WRITE('Program ended', CR)
END basic_template
EOF
      ;;
    socket-server)
      cmd_socket | sed -n '/TCP Server 模板/,/TCP Client 模板/p' | head -n -1
      ;;
    file-logger)
      cmd_fileio | sed -n '/完整示例/,/bytesagain/p' | head -n -1
      ;;
    *)
      echo "Available templates:"
      echo "  basic          — Basic KAREL program structure"
      echo "  socket-server  — TCP server for PC communication"
      echo "  file-logger    — CSV data logging to USB"
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
  echo "Searching KAREL reference for '$keyword'..."
  echo ""
  for cmd in syntax types builtin fileio socket; do
    result=$(cmd_$cmd 2>/dev/null | grep -i "$keyword" || true)
    if [ -n "$result" ]; then
      echo "=== Found in: $cmd ==="
      echo "$result"
      echo ""
    fi
  done
}

cmd_help() {
  cat << 'EOF'
fanuc-karel — FANUC KAREL Programming Reference

Commands:
  syntax              Language syntax (variables, control flow, directives)
  types               Data types (INTEGER, REAL, POSITION, VECTOR, etc.)
  builtin             Built-in routines (math, string, position, I/O, system)
  fileio              File I/O (read, write, USB, FROM, memory card)
  socket              TCP/UDP socket communication
  template <type>     Program templates (basic, socket-server, file-logger)
  search <keyword>    Search all reference data
  help                Show this help

Examples:
  bash scripts/script.sh syntax
  bash scripts/script.sh builtin
  bash scripts/script.sh socket
  bash scripts/script.sh template basic
  bash scripts/script.sh search "CURPOS"

Powered by BytesAgain | bytesagain.com

Related:
  clawhub install fanuc-alarm     Alarm codes (2607)
  clawhub install fanuc-tp        TP programming
  clawhub install fanuc-spotweld  Spot welding
  Browse all: bytesagain.com
EOF
}

case "${1:-help}" in
  syntax)    cmd_syntax ;;
  types)     cmd_types ;;
  builtin)   cmd_builtin ;;
  fileio)    cmd_fileio ;;
  socket)    cmd_socket ;;
  template)  shift; cmd_template "$@" ;;
  search)    shift; cmd_search "$@" ;;
  help|*)    cmd_help ;;
esac

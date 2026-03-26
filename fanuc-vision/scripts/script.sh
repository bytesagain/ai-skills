#!/usr/bin/env bash
set -euo pipefail

# FANUC iRVision Reference

cmd_setup() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC iRVision Camera Setup
═══════════════════════════════════════════════════

【硬件要求】
  - iRVision选项 (R632/R641/R661等)
  - 相机 (FANUC专用或GigE工业相机)
  - 相机电缆 (以太网, 通常PoE供电)
  - 标定板 (网格板, 随iRVision附带)
  - 照明 (环形灯/条形灯/背光)

【相机类型】
  Fixed Camera    固定相机 (安装在固定支架上)
  Robot Camera    机器人相机 (安装在机器人法兰上)
  
  固定相机: 工件在相机视野内, 相机不动
  机器人相机: 相机随机器人移动, 拍摄后计算偏移

【连接步骤】
  1. 连接相机到控制柜以太网端口
  2. 设置相机IP: Menu > Setup > Host Comm > TCP/IP
     相机和控制器在同一子网
  3. Menu > Setup > iRVision > Camera Setup
  4. 检测相机: Auto Detect 或手动输入IP
  5. 验证: 能看到实时图像

【相机参数】
  Exposure Time    曝光时间 (ms, 通常1-50ms)
  Gain             增益 (通常1-10)
  White Balance     白平衡
  
  调整原则:
    - 图像太暗 → 增加曝光或增益
    - 图像模糊 → 缩短曝光时间, 加强照明
    - 反光过多 → 调整照明角度或用偏振滤光片

【照明原则】
  正面照明:   看表面特征(文字、标记)
  侧面照明:   突出边缘和凹凸
  背光照明:   获取轮廓(最稳定, 推荐)
  漫射照明:   减少反光(金属件)
  
  铁律: 照明 > 相机 > 算法
  好的照明解决80%的视觉问题

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_calibrate() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC iRVision Camera Calibration
═══════════════════════════════════════════════════

【为什么要标定】
  相机看到的是像素(pixel), 机器人用的是毫米(mm)
  标定 = 建立像素与实际尺寸的对应关系
  
  不标定 → 位置偏差可能达到10-50mm
  标定后 → 精度 ±0.5mm (取决于相机和安装)

【标定方法 — 固定相机】
  
  Grid Calibration (网格标定, 推荐):
  1. Menu > Setup > iRVision > Calibration
  2. 选择Camera和Calibration Type: Grid
  3. 将标定板放在工作平面上
  4. 输入网格间距 (标定板上标注的, 如10mm)
  5. Snap Image → 系统自动识别网格点
  6. 至少拍1张, 推荐3-5张不同位置
  7. Calculate → 完成

  Single Point (单点标定):
  1. 将机器人移到已知位置
  2. 记录相机图像中该点的像素坐标
  3. 输入该点的实际坐标
  4. 需要至少4个点

【标定方法 — 机器人相机】
  1. Menu > Setup > iRVision > Calibration
  2. 选择Robot Camera
  3. 将标定板固定在工作台上
  4. 机器人移到5-9个不同位置拍照
  5. 每个位置: 移动机器人 → Snap → Record
  6. 系统自动计算相机与机器人的关系
  
  注意: 每个位置之间平移+旋转, 覆盖工作范围

【标定质量检查】
  标定后显示 RMS Error:
    < 0.3 pixel: 优秀
    0.3-0.5 pixel: 良好
    0.5-1.0 pixel: 可接受
    > 1.0 pixel: 需要重新标定
  
  验证方法:
    1. 在已知位置放工件
    2. 运行视觉程序获取坐标
    3. 与已知坐标比较
    4. 误差应 < 1mm

【重新标定时机】
  - 相机位置移动后
  - 更换镜头后
  - 工作平面高度改变后
  - 精度下降时

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_pattern() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC iRVision Pattern Matching
═══════════════════════════════════════════════════

【GPM (Geometric Pattern Matching)】
  最常用的视觉工具
  原理: 学习工件几何特征(边缘), 搜索图像中匹配位置
  
  优点: 对光照变化不敏感, 适合工业环境
  
  设置步骤:
  1. Menu > Setup > iRVision > Vision Process
  2. Create New > GPM
  3. 放置标准工件, Snap Image
  4. 用矩形/圆形框选目标特征区域
  5. Train → 系统学习特征
  6. Test Run → 验证匹配结果

【GPM参数】
  Score Threshold    匹配阈值 (0-100%, 通常60-80%)
  Max Results        最大匹配数 (1-20)
  Search Area        搜索区域 (越小越快)
  Angle Range        角度搜索范围 (±度)
  Scale Range        尺度范围 (通常100%±5%)

【Vision Register (VR)】
  视觉结果输出到VR[]:
    VR[1].x         X位置 (mm)
    VR[1].y         Y位置 (mm)
    VR[1].angle     角度 (度)
    VR[1].score     匹配得分 (0-100)
    VR[1].found     是否找到 (1/0)

【TP程序调用】
   1: VISION RUN_FIND 'MY_PROCESS'     运行视觉
   2: VISION GET_OFFSET VR[1]          获取偏移
   3: IF VR[1].found = 0, JMP LBL[99]  未找到则跳转
   4: L P[1] 500mm/sec FINE Offset VR[1]  用偏移修正位置

【多模型匹配】
  一个视觉过程可以训练多个模型:
    Model 1: 零件A
    Model 2: 零件B
    Model 3: 零件C
  
  VR[1].model_id 返回匹配到的模型号
  用于: 混线生产, 自动识别工件型号

【条码/二维码】
  支持: QR Code, DataMatrix, Code128等
  设置: Vision Process > Barcode
  结果: SR[1] 返回条码内容字符串

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_tracking() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC iRVision Visual Tracking
═══════════════════════════════════════════════════

【Visual Line Tracking】
  用途: 传送带上移动工件的视觉引导抓取
  
  组件:
    - 固定相机 (拍传送带)
    - 编码器 (测传送带速度)
    - 触发传感器 (触发拍照)

  工作流程:
    1. 工件经过触发传感器 → 触发拍照
    2. 相机拍照 → 视觉识别工件位置
    3. 位置数据 + 编码器数据 → 计算工件实时位置
    4. 机器人追踪工件 → 在移动中抓取

【设置步骤】
  1. 安装编码器到传送带电机
  2. Menu > Setup > iRVision > Line Tracking
  3. 标定编码器: 测量已知距离对应的编码器脉冲数
  4. 标定相机: 传送带平面标定
  5. 设置触发传感器: DI[n]
  6. 设置追踪窗口: 
     Tracking Window Start: 编码器值(工件进入抓取范围)
     Tracking Window End: 编码器值(工件离开抓取范围)
  7. 测试: 手动放工件, 验证跟踪

【TP程序】
   1: VISION RUN_FIND 'LINE_TRACK'
   2: WAIT DI[5:Track Ready]=ON
   3: LINETRACK START
   4: L P[1] 500mm/sec FINE LINETRACK
   5: !--- Grip while moving ---
   6: DO[1:Gripper]=ON
   7: WAIT 0.20(sec)
   8: LINETRACK END
   9: J PR[1:Place] 50% FINE

【编码器标定】
  1. 标记传送带起点
  2. 记录编码器值 E1
  3. 手动移动传送带已知距离 (如500mm)
  4. 记录编码器值 E2
  5. 分辨率 = 距离 / (E2-E1) mm/pulse

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_troubleshoot() {
  cat << 'EOF'
═══════════════════════════════════════════════════
  FANUC iRVision Troubleshooting
═══════════════════════════════════════════════════

【CVIS-001 Camera not found】
  1. 检查网线连接
  2. Ping相机IP
  3. 确认同一子网
  4. 重启相机电源
  5. Menu > iRVision > Camera Setup > Re-detect

【CVIS-011 Pattern not found】
  1. 检查照明是否变化 → 重新调整照明
  2. 工件不在视野内 → 检查工件位置
  3. 工件外观变化 → 重新训练模型
  4. 匹配阈值太高 → 降低Score Threshold到60%
  5. 搜索区域太小 → 扩大Search Area
  6. 镜头脏 → 清洁镜头

【CVIS-020 Calibration error】
  1. 重新标定相机
  2. 标定板必须平放在工作平面上
  3. 标定板不能有遮挡或反光
  4. 检查相机是否物理移动过

【匹配精度差(偏差>1mm)】
  1. 重新标定相机(标定板覆盖整个工作区域)
  2. 确保工作平面高度与标定平面一致
  3. 增加标定图片数量(5-9张)
  4. 检查镜头畸变是否严重(更换镜头)
  5. 相机安装是否稳固(振动导致偏差)

【图像质量差】
  图像太暗:
    → 增加曝光时间
    → 增加照明亮度
    → 增加增益(但会增加噪声)
  
  图像模糊:
    → 缩短曝光时间(运动模糊)
    → 调整焦距
    → 检查镜头是否松动
  
  反光严重:
    → 改变照明角度(避免镜面反射)
    → 使用漫射照明
    → 使用偏振滤光片

【速度优化】
  视觉处理太慢(>500ms):
    1. 缩小搜索区域
    2. 降低图像分辨率
    3. 减少最大匹配数
    4. 使用ROI(感兴趣区域)

📖 More FANUC skills: bytesagain.com
EOF
}

cmd_help() {
  cat << 'EOF'
fanuc-vision — FANUC iRVision Reference

Commands:
  setup           Camera hardware setup and connection
  calibrate       Camera calibration procedures
  pattern         Pattern matching (GPM, barcode, multi-model)
  tracking        Visual line tracking
  troubleshoot    Common problems and solutions
  help            Show this help

Examples:
  bash scripts/script.sh setup
  bash scripts/script.sh calibrate
  bash scripts/script.sh pattern
  bash scripts/script.sh troubleshoot

Powered by BytesAgain | bytesagain.com

Related:
  clawhub install fanuc-alarm     Alarm codes (2607, incl. CVIS)
  clawhub install fanuc-tp        TP programming
  clawhub install fanuc-spotweld  Spot welding
  Browse all: bytesagain.com
EOF
}

case "${1:-help}" in
  setup)        cmd_setup ;;
  calibrate)    cmd_calibrate ;;
  pattern)      cmd_pattern ;;
  tracking)     cmd_tracking ;;
  troubleshoot) cmd_troubleshoot ;;
  help|*)       cmd_help ;;
esac

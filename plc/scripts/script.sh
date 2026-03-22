#!/usr/bin/env bash
# plc — Programmable Logic Controller Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== PLC — Programmable Logic Controller ===

A PLC is a ruggedized digital computer used to automate industrial
processes — assembly lines, machines, robotic devices, and more.

Architecture:
  CPU Module       Executes the user program in a cyclic scan
  Input Modules    Read field sensors (switches, encoders, 4-20mA)
  Output Modules   Drive actuators (relays, solenoids, VFDs)
  Power Supply     Typically 24VDC for I/O, 120/240VAC for CPU
  Communication    Ethernet, serial, fieldbus ports

Scan Cycle:
  1. Read Inputs    → copy physical inputs to input image table
  2. Execute Logic  → run ladder/ST/FBD program top-to-bottom
  3. Write Outputs  → copy output image table to physical outputs
  4. Housekeeping   → comms, diagnostics, watchdog refresh

Typical scan time: 1–20 ms depending on program size.

Memory Areas:
  %I   Input bits          %IW  Input words
  %Q   Output bits         %QW  Output words
  %M   Internal markers    %MW  Internal words
  %DB  Data blocks         %T   Timers
  %C   Counters

Major PLC Brands:
  Siemens (S7-1200/1500), Allen-Bradley (CompactLogix/ControlLogix),
  Mitsubishi (FX/Q series), Schneider (M340/M580), Omron (NX/NJ),
  Beckhoff (TwinCAT/CX), ABB (AC500), Keyence (KV series)
EOF
}

cmd_languages() {
    cat << 'EOF'
=== IEC 61131-3 Programming Languages ===

1. Ladder Diagram (LD)
   - Graphical, resembles relay logic wiring diagrams
   - Left rail = power, right rail = return
   - Contacts (inputs): -| |- normally open, -|/|- normally closed
   - Coils (outputs):   -( )- standard, -(/)- negated
   - Best for: discrete logic, motor control, interlocks

2. Structured Text (ST)
   - High-level text language, similar to Pascal
   - Supports IF/THEN/ELSE, CASE, FOR, WHILE, REPEAT
   - Example:
       IF Sensor1 AND NOT Fault THEN
           Motor := TRUE;
           Timer1(IN := TRUE, PT := T#5s);
       END_IF;
   - Best for: math-heavy, PID, data processing

3. Function Block Diagram (FBD)
   - Graphical, data-flow oriented
   - Blocks connected by signal lines
   - Standard blocks: AND, OR, TON, CTU, ADD, MUL
   - Best for: continuous process control, analog processing

4. Instruction List (IL) — deprecated in IEC 61131-3 ed.3
   - Assembly-like text: LD, ST, AND, OR, JMP
   - Still found in legacy Siemens S5/S7 (STL)

5. Sequential Function Chart (SFC)
   - Steps + transitions for sequential processes
   - Each step has entry/exit actions
   - Best for: batch processes, startup sequences
EOF
}

cmd_instructions() {
    cat << 'EOF'
=== Common PLC Instructions ===

Bit Logic:
  LD / XIC      Load / Examine If Closed (NO contact)
  LDN / XIO     Load Not / Examine If Open (NC contact)
  OUT / OTE     Output coil
  SET / OTL     Latch (set and hold)
  RST / OTU     Unlatch (reset)
  AND           Series contact
  OR            Parallel contact

Timers:
  TON           Timer On-Delay    (output ON after PT elapsed)
  TOF           Timer Off-Delay   (output OFF after PT elapsed)
  TP            Pulse Timer       (fixed pulse width)
  Usage:  TON(IN := Start, PT := T#5s, Q => Done, ET => Elapsed)

Counters:
  CTU           Count Up          (increment on rising edge)
  CTD           Count Down        (decrement on rising edge)
  CTUD          Count Up/Down     (bidirectional)
  Usage:  CTU(CU := Sensor, R := Reset, PV := 100, Q => Full)

Math:
  ADD  SUB  MUL  DIV  MOD
  ABS  SQRT  SIN  COS  LN  EXP

Comparison:
  EQ (=)  NE (<>)  GT (>)  GE (>=)  LT (<)  LE (<=)

Move / Transfer:
  MOVE          Copy value A to B
  BLKMOV        Block move (copy array/range)

Conversion:
  INT_TO_REAL   REAL_TO_INT   BCD_TO_INT   INT_TO_BCD
EOF
}

cmd_datatypes() {
    cat << 'EOF'
=== IEC 61131-3 Data Types ===

Elementary Types:
  BOOL          1 bit         TRUE / FALSE
  BYTE          8 bits        16#00..16#FF
  WORD          16 bits       16#0000..16#FFFF
  DWORD         32 bits       Double word
  LWORD         64 bits       Long word

  SINT          8-bit signed      -128..127
  INT           16-bit signed     -32768..32767
  DINT          32-bit signed     -2^31..2^31-1
  LINT          64-bit signed     Long integer

  USINT         8-bit unsigned    0..255
  UINT          16-bit unsigned   0..65535
  UDINT         32-bit unsigned   0..4294967295

  REAL          32-bit float      IEEE 754 single
  LREAL         64-bit float      IEEE 754 double

  TIME          Duration          T#1h30m, T#500ms
  DATE          Calendar date     D#2026-03-21
  TIME_OF_DAY   Clock time        TOD#14:30:00
  DATE_AND_TIME Combined          DT#2026-03-21-14:30:00

  STRING        Character string  'Hello World'
  WSTRING       Wide string       Unicode

Structured Types:
  ARRAY    ARRAY[1..10] OF INT
  STRUCT   TYPE myStruct: STRUCT x: REAL; y: REAL; END_STRUCT; END_TYPE
  ENUM     TYPE Color: (RED, GREEN, BLUE); END_TYPE
EOF
}

cmd_faults() {
    cat << 'EOF'
=== PLC Fault Troubleshooting ===

CPU Faults:
  Watchdog timeout     Scan time exceeded limit
    → Optimize program, split into periodic tasks
  Memory overflow      Program or data too large
    → Reduce arrays, archive old data blocks
  Division by zero     Math error in program
    → Add zero-check before DIV instructions

I/O Faults:
  Module not responding    Communication lost to I/O rack
    → Check cable, backplane seating, module LEDs
  Input signal out of range    Analog 4-20mA reading < 3.8mA
    → Check sensor wiring, transmitter power
  Short circuit on output     Output module overcurrent
    → Check field wiring for shorts, reduce load

Communication Faults:
  Modbus timeout       Slave not responding
    → Verify baud rate, parity, slave address, wiring
  EtherNet/IP connection lost
    → Check IP config, subnet, switch port, cable
  Profinet IO device missing
    → Verify device name, IP, GSD file version

Safety Faults:
  E-stop triggered     Safety relay opened
    → Reset E-stop, check safety circuit continuity
  Light curtain blocked
    → Clear obstruction, verify alignment
  Safety PLC watchdog  Redundant CPU mismatch
    → Restart safety PLC, check program versions

General Steps:
  1. Read fault buffer (diagnostic log)
  2. Note fault code + timestamp
  3. Check physical indicators (LEDs, wiring)
  4. Clear fault, test in manual/jog mode first
  5. Document root cause for maintenance log
EOF
}

cmd_protocols() {
    cat << 'EOF'
=== Industrial Communication Protocols ===

Modbus RTU (Serial):
  - Master/slave, RS-485 half-duplex
  - Function codes: 01 Read Coils, 03 Read Holding Registers,
    05 Write Single Coil, 06 Write Single Register, 16 Write Multiple
  - Frame: [Addr][FC][Data][CRC-16]
  - Typical: 9600-19200 baud, 8N1

Modbus TCP (Ethernet):
  - Same function codes, TCP port 502
  - MBAP header replaces CRC
  - Up to ~250 simultaneous connections

EtherNet/IP:
  - Allen-Bradley standard, TCP port 44818
  - Uses CIP (Common Industrial Protocol)
  - Implicit (cyclic I/O) + Explicit (request/reply)
  - RPI (Requested Packet Interval) typically 10-100ms

Profinet:
  - Siemens standard, real-time Ethernet
  - RT (software, ~1ms) and IRT (hardware, <1ms)
  - Uses GSD/GSDML device description files
  - Device naming required (not just IP)

OPC UA:
  - Platform-independent, TCP port 4840
  - Information model with nodes, browse, subscribe
  - Built-in security (certificates, encryption)
  - Replacing OPC Classic (COM/DCOM)

DeviceNet:
  - CAN-based, Allen-Bradley ecosystem
  - 125/250/500 kbps, max 64 nodes
  - EDS files for device configuration

MQTT (IIoT):
  - Publish/subscribe, lightweight
  - Increasingly used PLC→cloud
  - Sparkplug B specification for industrial use
EOF
}

cmd_examples() {
    cat << 'EOF'
=== PLC Example Programs ===

--- Motor Start/Stop (Ladder Logic) ---
Rung 1: Start/Stop circuit with seal-in
  |--[Start]--+--[NOT Stop]--[NOT Fault]--(Motor)--|
  |           |                                     |
  |--[Motor]--+                                     |

Rung 2: Motor running indicator
  |--[Motor]--(RunLight)--|

--- Structured Text: Motor Start/Stop ---
IF (Start OR Motor) AND NOT Stop AND NOT Fault THEN
    Motor := TRUE;
ELSE
    Motor := FALSE;
END_IF;
RunLight := Motor;

--- Traffic Light Sequence (SFC) ---
Step 1: Green (30s)  → Transition: Timer1.Q
Step 2: Yellow (5s)  → Transition: Timer2.Q
Step 3: Red (30s)    → Transition: Timer3.Q
Step 4: Red+Yellow (3s) → Transition: Timer4.Q → Go to Step 1

--- Tank Level Control (ST) ---
LevelError := Setpoint - ActualLevel;
ValveOutput := Kp * LevelError + Ki * Integral;
IF ValveOutput > 100.0 THEN ValveOutput := 100.0; END_IF;
IF ValveOutput < 0.0 THEN ValveOutput := 0.0; END_IF;
IF HighLevelSwitch THEN ValveOutput := 0.0; AlarmHigh := TRUE; END_IF;

--- Conveyor Interlock (Ladder) ---
Rung 1: Downstream must run before upstream
  |--[Conv3_Running]--[NOT E_Stop]--(Conv2_Enable)--|
  |--[Conv2_Running]--[NOT E_Stop]--(Conv1_Enable)--|
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== PLC Pre-Commissioning Checklist ===

Power & Wiring:
  [ ] Verify supply voltage matches CPU/PS rating
  [ ] Check grounding — single-point ground, low impedance
  [ ] Confirm 24VDC sensor supply is within ±10%
  [ ] Inspect all terminal screws for tightness
  [ ] Verify wire gauge matches load current

I/O Mapping:
  [ ] Compare I/O address table with electrical drawings
  [ ] Force each input — verify correct bit toggles in PLC
  [ ] Force each output from PLC — verify correct device activates
  [ ] Check analog scaling (4-20mA → engineering units)
  [ ] Verify sensor types match input card spec (PNP vs NPN)

Program:
  [ ] Download correct program version to CPU
  [ ] Verify all timers/counters have correct presets
  [ ] Check all safety interlocks function correctly
  [ ] Test E-stop circuit — CPU should fault or safe-state
  [ ] Run in manual/jog mode before full auto

Communication:
  [ ] Verify IP addresses — no conflicts on network
  [ ] Test HMI communication — all tags reading correctly
  [ ] Confirm remote I/O modules are online (no red LEDs)
  [ ] Test SCADA connection if applicable

Documentation:
  [ ] Backup program to USB/PC
  [ ] Record firmware versions (CPU, I/O modules)
  [ ] Label all cables and terminals
  [ ] Update as-built drawings with any field changes
EOF
}

show_help() {
    cat << EOF
plc v$VERSION — Programmable Logic Controller Reference

Usage: script.sh <command>

Commands:
  intro          PLC architecture and scan cycle overview
  languages      IEC 61131-3 programming languages guide
  instructions   Common PLC instructions reference
  datatypes      IEC 61131-3 data types
  faults         Fault codes and troubleshooting guide
  protocols      Industrial communication protocols
  examples       Example PLC programs
  checklist      Pre-commissioning checklist
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    languages)    cmd_languages ;;
    instructions) cmd_instructions ;;
    datatypes)    cmd_datatypes ;;
    faults)       cmd_faults ;;
    protocols)    cmd_protocols ;;
    examples)     cmd_examples ;;
    checklist)    cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "plc v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac

#!/usr/bin/env bash
# bms — Battery Management System Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Battery Management System (BMS) ===

A BMS monitors, protects, and optimizes a rechargeable battery pack.
Every lithium-ion pack REQUIRES a BMS — without one, cells can
catch fire, explode, or degrade rapidly.

Core Functions:
  1. Cell Monitoring     Measure voltage, current, temperature per cell
  2. Protection          Prevent overvoltage, undervoltage, overcurrent
  3. Cell Balancing      Equalize charge across cells in series
  4. SOC Estimation      Report remaining capacity (fuel gauge)
  5. SOH Tracking        Track degradation and remaining life
  6. Thermal Management  Control cooling/heating systems
  7. Communication       Report data to host system (CAN, SMBus)
  8. Logging             Record history for diagnostics/warranty

Why Cells Need Balancing:
  No two cells are identical — manufacturing variance:
    Capacity:     ±2–5% between cells in same batch
    Self-discharge: 2–5%/month variation
    Impedance:    ±5–10% variation
  
  Without balancing:
    Weakest cell hits undervoltage first → limits pack capacity
    Strongest cell hits overvoltage first → limits pack charging
    Over time, imbalance grows → usable capacity shrinks

Typical BMS Architecture:
  ┌─────────────────────────────────┐
  │           Host / MCU            │
  │  SOC algo, thermal control,     │
  │  communication, fault logic     │
  └──────────┬──────────────────────┘
             │ SPI/I²C
  ┌──────────┴──────────────────────┐
  │      Analog Front End (AFE)     │
  │  Cell voltage ADC, current ADC  │
  │  Temperature ADC, balancing FET │
  └──────────┬──────────────────────┘
             │ sense wires
  ┌──────────┴──────────────────────┐
  │      Battery Pack (nS × mP)    │
  │  Cell 1 ─ Cell 2 ─ ... ─ Cell n│
  │  NTC thermistors on cells       │
  └─────────────────────────────────┘

Common Li-ion Cell Limits:
  NMC (3.6V nom): 2.5V min, 4.2V max, charge 0–45°C, discharge -20–60°C
  LFP (3.2V nom): 2.0V min, 3.65V max, charge 0–45°C, discharge -20–55°C
  NCA (3.6V nom): 2.5V min, 4.2V max, charge 0–45°C, discharge -20–60°C
EOF
}

cmd_cellbalance() {
    cat << 'EOF'
=== Cell Balancing Methods ===

Passive Balancing (Dissipative):
  Bleed energy from high cells through a resistor → heat
  Simple, cheap, proven — used in 90%+ of BMS designs
  
  How it works:
    Cell voltage > threshold (e.g., 4.15V) → turn on bleed FET
    Current flows through bleed resistor → cell discharges
    Continue until all cells within target (e.g., ±10mV)
  
  Typical parameters:
    Bleed current: 50–200 mA (determines balancing speed)
    Resistor: 47–100Ω per cell
    Power dissipation: 50mA × 4.2V = 210 mW per cell
    Time to balance 100mAh: 100mAh / 50mA = 2 hours
  
  Limitations:
    Wastes energy as heat
    Slow for large imbalances
    Only works during/near end of charge
    Limited by thermal dissipation of resistors

Active Balancing (Redistributive):
  Transfer energy from high cells to low cells — no waste!
  
  Capacitor Shuttle:
    Capacitor switches between adjacent cells
    Simple, moderate efficiency (80–90%)
    Slow if cells far apart in series string
  
  Inductor-Based:
    Flyback or buck-boost converter between cells
    Efficiency: 85–95%
    Fast balancing: 1–5A possible
    Complex, requires transformer + FETs per cell
  
  Cell-to-Pack / Pack-to-Cell:
    Isolated DC-DC converter
    Any cell ↔ pack bus
    Highest flexibility, fastest
    Most complex and expensive

When to Use Active:
  Pack capacity > 10 kWh (EVs, grid storage)
  High cycle count applications
  Second-life battery applications (large initial imbalance)
  Cost justified by recovered energy

Balancing Effectiveness:
  Passive: recovers 1–3% of pack capacity
  Active: recovers 3–8% of pack capacity
  Both: extend pack life by 10–30%
EOF
}

cmd_soc() {
    cat << 'EOF'
=== State of Charge (SOC) Estimation ===

SOC = remaining charge / total usable capacity × 100%

Method 1: Coulomb Counting (Current Integration)
  SOC(t) = SOC(t₀) - ∫ I·dt / Q_total
  
  Pros: real-time, works during charge/discharge
  Cons: drift over time, needs accurate initial SOC, sensor error
  
  Error sources:
    Current sensor accuracy: ±0.5–2% (shunt or Hall effect)
    ADC resolution and sampling rate
    Self-discharge not accounted
    Drift: ~1% SOC error per hour without correction
  
  Must be periodically recalibrated (at full/empty)

Method 2: OCV-SOC Lookup Table
  Each chemistry has a voltage-SOC curve (measured offline)
  Measure open-circuit voltage → look up SOC
  
  Pros: simple, no drift, self-correcting
  Cons: needs long rest (1–4 hours for equilibrium)
  
  LFP challenge: very flat OCV curve (3.2–3.3V for 20–80% SOC)
  → OCV method has poor resolution for LFP
  NMC: more sloped OCV → better OCV-SOC mapping

Method 3: Extended Kalman Filter (EKF)
  Combines coulomb counting + OCV + battery model
  Equivalent circuit model: R₀ + R₁//C₁ (+ R₂//C₂)
  
  State: SOC, voltage across RC networks
  Measurement: terminal voltage
  Correction: model prediction vs actual measurement
  
  Pros: accurate (±2% SOC), handles noise, self-correcting
  Cons: needs battery model parameters, computationally heavier
  Industry standard for EVs and premium products

Method 4: Impedance / EIS
  AC impedance varies with SOC (especially at low frequency)
  Requires impedance spectroscopy hardware
  Used for SOH more than SOC in practice

Practical SOC System:
  1. EKF for continuous tracking during operation
  2. OCV correction during long rest periods
  3. Full charge recalibration (reset to 100%)
  4. Low-voltage detection for 0% anchor
  5. Capacity fade compensation (update Q_total from SOH)
EOF
}

cmd_protection() {
    cat << 'EOF'
=== BMS Protection Circuits ===

Overvoltage Protection (OVP):
  Threshold: 4.20–4.25V per cell (NMC), 3.65V (LFP)
  Action: disconnect charger via high-side FET
  Hysteresis: 50–100mV (re-enable at 4.10V)
  Response time: <100ms
  Risk if missing: lithium plating → dendrites → internal short → fire

Undervoltage Protection (UVP):
  Threshold: 2.5–2.8V per cell (NMC), 2.0–2.5V (LFP)
  Action: disconnect load via low-side FET
  Hysteresis: 200–500mV (re-enable at 3.0V)
  Risk if missing: copper dissolution → capacity loss → internal short

Overcurrent Protection (OCP):
  Charge overcurrent: typically 1C limit (set by cell spec)
  Discharge overcurrent: 2–5C continuous, 10C pulse
  Measurement: shunt resistor (1–10mΩ) + high-side amp
  Response: 10–100ms for continuous, 100–500μs for short circuit
  Action: open discharge FETs, set fault flag

Short Circuit Protection (SCP):
  Threshold: 2–5× overcurrent limit
  Response: <100μs (hardware comparator, not software!)
  Implementation: dedicated SCP circuit in AFE IC
  Must be hardware-based — software too slow for shorts

Temperature Protection:
  Charge disable:    <0°C or >45°C (lithium plating risk below 0°C!)
  Discharge disable: <-20°C or >60°C
  Thermal shutdown:  >70°C (emergency disconnect)
  Sensors: NTC thermistors (10kΩ at 25°C typical)
  Placement: on cell surface, between cells, on FET heatsink
  Minimum: 1 per parallel group, 1 on power FETs

Protection FET Sizing:
  RDS(on) total: <10mΩ for low losses
  Voltage rating: 1.5× pack voltage minimum
  Current rating: 2× continuous current
  Typical: 2 back-to-back N-channel MOSFETs
    One blocks charge direction
    One blocks discharge direction
    Both must be rated for full pack voltage
EOF
}

cmd_thermal() {
    cat << 'EOF'
=== BMS Thermal Management ===

Why Temperature Matters:
  <0°C:    Lithium plating during charge (permanent damage!)
  0–10°C:  Reduced capacity, high impedance, derate charging
  15–35°C: Optimal range for performance and longevity
  35–45°C: Accelerated aging (Arrhenius: 2× life loss per 10°C)
  >45°C:   Risk of thermal runaway if combined with abuse
  >80°C:   Separator shrinkage begins
  >130°C:  Thermal runaway cascade in NMC

Heat Sources in a Pack:
  Ohmic (I²R):       Dominant at high C-rates
  Entropic:          Reversible heat from entropy changes
  Contact resistance: Cell tabs, bus bars, connectors
  BMS electronics:   FETs, shunt resistors

Cooling Methods:

  Natural Air Cooling:
    Consumer electronics, small packs (<500Wh)
    Relies on pack surface area and ambient
    Simple, zero energy cost, limited capacity
    ΔT limit: ~10-15°C above ambient

  Forced Air Cooling:
    Fans push air through channels between cells
    Power electronics, e-bikes, small EVs
    Effective to ~1-2 kW of heat removal
    ΔT: 5-10°C above ambient with good airflow
    Dust/moisture ingress concern

  Liquid Cooling:
    Cold plates or cooling channels with glycol-water mix
    EVs, grid storage, fast-charging systems
    Heat removal: 5-20 kW+ depending on flow rate
    ΔT: 2-5°C above coolant temperature
    Components: pump, radiator, reservoir, cold plates, hoses
    Complexity: leak risk, weight, cost

  Phase Change Material (PCM):
    Paraffin-based: melting point 30-45°C
    Absorbs heat during melting (latent heat: 200 kJ/kg)
    Passive, no moving parts, buffers thermal spikes
    Con: finite capacity, needs regeneration time

Cold Weather Heating:
  Resistive heaters on cell surface or coolant loop
  Pre-condition before charging in cold weather
  Typical: heat to >5°C before enabling charge
  Self-heating: pulse discharge (I²R) to warm cells
  Power: 50-200W for EV packs during pre-heating
EOF
}

cmd_communication() {
    cat << 'EOF'
=== BMS Communication Protocols ===

CAN Bus (Controller Area Network):
  Industry standard for automotive and industrial BMS
  Differential pair, up to 1 Mbit/s (CAN 2.0), 5 Mbit/s (CAN FD)
  
  Typical BMS CAN Messages:
    0x100: Pack voltage, current, SOC
    0x101: Cell voltages 1-4
    0x102: Cell voltages 5-8
    0x103: Temperature readings
    0x104: Fault status flags
    0x105: Charge/discharge limits
  
  Frame: 11-bit ID + 0-8 bytes data + CRC
  SAE J1939 for heavy vehicles, CANopen for industrial

SMBus / I²C (Smart Battery):
  Used in: laptops, power tools, medical devices
  Standard: SBS (Smart Battery Specification) v1.1
  
  Key SBS Registers:
    0x0D: RelativeStateOfCharge (%)
    0x0F: RemainingCapacity (mAh)
    0x10: FullChargeCapacity (mAh)
    0x09: Voltage (mV)
    0x0A: Current (mA)
    0x08: Temperature (0.1K units)
    0x16: BatteryStatus (flags)
    0x03: BatteryMode

  Clock: 100 kHz (standard), 400 kHz (fast mode)
  Addressed: 7-bit address, typically 0x0B for battery

UART / RS-485:
  Simple serial communication for BMS modules
  Common in solar/energy storage BMS
  Baud: 9600–115200 typical
  RS-485 for long distance (up to 1200m) and multi-drop
  Protocol: often Modbus RTU over RS-485

Daisy-Chain (Cell Monitor ICs):
  isoSPI (Linear/Analog Devices LTC6811/ADBMS1818)
  Isolated SPI between stacked ICs
  Each IC monitors 6–18 cells
  Chain: up to 100+ ICs in series
  1 MHz, transformer-coupled isolation

Wireless BMS (wBMS):
  Emerging: TI, Analog Devices wireless solutions
  Eliminates cell sense wires (weight, assembly cost)
  2.4 GHz proprietary protocols
  Latency: <2ms for critical measurements
  Challenge: reliability, EMI, certification

Data Logging:
  Minimum logging: voltage, current, temp, SOC every 1–10 sec
  Fault events: timestamped with full state snapshot
  Cycle counting: charge/discharge cycles, DOD histogram
  Storage: EEPROM, flash, or SD card (10+ years retention)
EOF
}

cmd_topologies() {
    cat << 'EOF'
=== BMS Architectures ===

Centralized BMS:
  Single PCB with all monitoring and control
  Wires run from every cell to the central board
  
  Pros: simple design, low cost, single point of programming
  Cons: long wire harness, limited scalability, EMI risk
  Use: e-bikes, power tools, small ESS (4S–16S)
  
  Example ICs:
    BQ76920 (TI): 3-5S, I²C, integrated FET drivers
    BQ76940 (TI): 9-15S, I²C
    ISL94202 (Renesas): 3-8S, integrated balancing

Distributed BMS:
  Slave module on each cell or module → master controller
  Communication via daisy-chain (isoSPI) or bus
  
  Pros: short sense wires, scalable, modular
  Cons: more components, complex communication
  Use: EVs (Tesla, BMW), large ESS
  
  Example ICs:
    LTC6811 (ADI): 12 cells/IC, isoSPI daisy-chain
    ADBMS1818 (ADI): 18 cells/IC, next-gen LTC6811
    MAX17853 (Maxim): 14 cells, UART daisy-chain
    MC33771C (NXP): 14 cells, TPL (transformer)

Modular BMS:
  Each battery module has its own complete BMS
  Modules connect to system controller via CAN/Ethernet
  
  Pros: hot-swappable, fault isolation, mix-and-match
  Cons: highest cost, redundant components
  Use: grid storage, UPS, telecom, containerized ESS

Choosing an Architecture:
  Cells     Architecture    Typical IC
  ────      ────────────    ──────────
  3-8S      Centralized     BQ76920, ISL94202
  8-16S     Centralized     BQ76940, ISL94203
  16-100S   Distributed     LTC6811, ADBMS1818
  100S+     Distributed     LTC6811 chain (up to 100+)
  Modular   Modular         Any + CAN master

Key IC Selection Criteria:
  Cell count per IC:       3–18 cells
  Measurement accuracy:    <±2mV cell voltage
  Current measurement:     <±0.5% (coulomb counting accuracy)
  Balancing current:       50–200mA internal, external FET for more
  Communication:           I²C, SPI, isoSPI, UART
  Functional safety:       ASIL-rated for automotive
  Cost per channel:        $0.50–$3.00 per cell
EOF
}

cmd_safety() {
    cat << 'EOF'
=== BMS Safety Standards ===

Failure Modes:
  Cell-level:
    Internal short circuit → thermal runaway
    Lithium plating → dendrite growth → short
    Electrolyte decomposition → gas generation → venting
    Tab weld failure → high resistance → hot spot
  
  Pack-level:
    Propagation: one cell fails → heats neighbors → cascade
    Connector failure → arcing
    Coolant leak → electrical short
    BMS failure → loss of protection
  
  BMS failure modes:
    Voltage measurement error → over/undercharge
    Current sensor failure → wrong SOC
    FET stuck closed → no protection
    FET stuck open → no output
    Communication loss → blind operation
    Software bug → incorrect fault thresholds

Thermal Runaway Prevention:
  Layer 1: BMS protection (voltage, current, temperature limits)
  Layer 2: Cell-level safety (CID, PTC, shutdown separator)
  Layer 3: Pack design (propagation barriers, venting)
  Layer 4: System design (enclosure, fire suppression)

Standards:

  IEC 62619 (Stationary Storage):
    Cell and battery safety for industrial
    Tests: short circuit, overcharge, crush, thermal abuse
    Mandatory for grid storage in many markets

  UN 38.3 (Transport):
    MANDATORY for shipping lithium batteries
    8 tests: altitude, thermal, vibration, shock, short, impact, overcharge, forced discharge
    Must pass before any battery can be transported

  UL 2580 (EV Batteries):
    Safety standard for EV battery packs
    Fire exposure, short circuit, overcharge, over-discharge
    Crush, impact, immersion

  ISO 26262 (Automotive Functional Safety):
    ASIL levels: A (lowest) to D (highest)
    BMS typically ASIL-C or ASIL-D
    Requires: FMEA, safety architecture, diagnostic coverage
    Dual-path protection: hardware + software redundancy
    
    Example: overvoltage protection
      Path 1: BMS software monitors voltage → opens FET
      Path 2: Hardware comparator → opens FET independently
      Both paths must work independently

  IEC 62133 (Portable):
    Consumer electronics batteries
    Cell and battery tests for portable applications
EOF
}

show_help() {
    cat << EOF
bms v$VERSION — Battery Management System Reference

Usage: script.sh <command>

Commands:
  intro          BMS overview, functions, architecture
  cellbalance    Passive vs active cell balancing methods
  soc            State of Charge estimation algorithms
  protection     OVP, UVP, OCP, SCP, temperature protection
  thermal        Cooling and heating methods for battery packs
  communication  CAN, SMBus, UART, daisy-chain protocols
  topologies     Centralized, distributed, modular architectures
  safety         Standards: IEC 62619, UN 38.3, ISO 26262
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)          cmd_intro ;;
    cellbalance)    cmd_cellbalance ;;
    soc)            cmd_soc ;;
    protection)     cmd_protection ;;
    thermal)        cmd_thermal ;;
    communication)  cmd_communication ;;
    topologies)     cmd_topologies ;;
    safety)         cmd_safety ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "bms v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac

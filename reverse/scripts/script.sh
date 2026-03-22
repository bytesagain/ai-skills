#!/usr/bin/env bash
# reverse — Reverse Engineering Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Reverse Engineering ===

Reverse engineering (RE) is the process of analyzing a system to
understand its design, architecture, and behavior without access
to source code or documentation.

Goals:
  Understand: how does this binary/protocol/hardware work?
  Interop:    build compatible software (drivers, clients)
  Security:   find vulnerabilities, analyze malware
  Recover:    recreate lost source code or documentation
  Verify:     confirm software does what it claims

Methodology:
  1. Reconnaissance   Gather information, identify platform/language
  2. Static Analysis  Examine without running (disassembly, strings)
  3. Dynamic Analysis Run and observe (debugging, tracing)
  4. Hypothesis       Form theory about behavior
  5. Verification     Test hypothesis, iterate

Legal Considerations:
  Generally legal:  Security research, interoperability, education
  DMCA exception:   Security research exemption (US)
  EU Directive:     Reverse engineering for interoperability allowed
  License terms:    Some EULAs prohibit RE (enforceability varies)
  Always check:     Local laws, contract terms, responsible disclosure

Skill Progression:
  Beginner:   CTF challenges, crackmes, simple binaries
  Intermediate: Real malware analysis, protocol reversing
  Advanced:   Kernel drivers, firmware, hardware RE
  Expert:     0-day discovery, custom tooling development
EOF
}

cmd_static() {
    cat << 'EOF'
=== Static Analysis ===

Examining a binary WITHOUT executing it.

--- First Steps ---
  file binary              # identify file type, architecture
  strings binary           # extract readable text (URLs, messages, keys)
  strings -n 8 binary      # strings of 8+ characters
  hexdump -C binary | head # raw hex view
  objdump -d binary        # disassemble (linear sweep)
  readelf -h binary        # ELF header info
  nm binary                # list symbols (if not stripped)

--- Disassembly Approaches ---
  Linear Sweep: decode instructions sequentially from start
    Fast but confused by data in code sections
    Used by: objdump

  Recursive Descent: follow control flow (branches, calls)
    More accurate, handles data-in-code better
    Used by: IDA Pro, Ghidra, Binary Ninja

--- Decompilation ---
  Disassembly → assembly (machine-readable)
  Decompilation → pseudo-C/high-level (human-readable)

  Tools:
    Ghidra decompiler     Free, NSA-developed, very good
    Hex-Rays (IDA)        Gold standard, commercial ($$$)
    RetDec                Open-source, LLVM-based
    Binary Ninja          Modern, scriptable, commercial

  Decompiler output is APPROXIMATE:
    Variable names are lost (var_10, param_1)
    Types are guessed (int vs uint vs pointer)
    Optimized code may look very different from source
    Loops/conditions may be restructured

--- Pattern Recognition ---
  Known functions:  FLIRT signatures (IDA), function ID (Ghidra)
  Crypto constants: S-boxes, round constants identify algorithms
    AES S-box: 63 7C 77 7B F2 6B 6F C5...
    SHA-256 K: 428A2F98 71374491 B5C0FBCF...
  String references: error messages lead to interesting functions
  Import table:      API calls reveal functionality
    CreateFile, WriteFile → file operations
    WSAStartup, connect  → network operations
    CryptEncrypt         → encryption
EOF
}

cmd_dynamic() {
    cat << 'EOF'
=== Dynamic Analysis ===

Examining a binary BY executing it in a controlled environment.

--- Debuggers ---
  GDB (GNU Debugger):
    gdb ./binary
    break main          # set breakpoint
    run                 # start execution
    next / step         # step over / step into
    print variable      # examine values
    x/10x $rsp          # examine memory (10 hex words at stack pointer)
    info registers      # show all registers
    bt                  # backtrace (call stack)

  GDB-enhanced:
    GEF (GDB Enhanced Features): github.com/hugsy/gef
    pwndbg: github.com/pwndbg/pwndbg
    Both add: heap visualization, enhanced disassembly, exploit dev tools

  WinDbg:  Windows kernel and user-mode debugging
  x64dbg:  Windows user-mode debugger (open source, GUI)
  LLDB:    LLVM debugger (macOS default)

--- System Tracing ---
  strace ./binary       Linux: trace system calls
    strace -e open,read,write ./binary   # filter specific calls
    strace -f ./binary                   # follow child processes
    strace -c ./binary                   # summary/statistics

  ltrace ./binary       Linux: trace library calls
  dtrace / bpftrace     Advanced kernel/user tracing
  procmon               Windows: file/registry/network monitoring
  API Monitor           Windows: API call interception

--- Network Analysis ---
  tcpdump -i any -w capture.pcap    # capture network traffic
  wireshark capture.pcap             # analyze in GUI
  mitmproxy                          # intercept HTTPS traffic

  Look for:
    C2 (Command & Control) communication patterns
    Data exfiltration (unusual outbound data)
    Protocol structure (request/response patterns)

--- Sandbox Execution ---
  Run malware in isolated environment:
    Cuckoo Sandbox:    Automated malware analysis
    ANY.RUN:           Interactive online sandbox
    Joe Sandbox:       Commercial automated analysis
    FLARE VM:          Windows RE virtual machine
    REMnux:            Linux RE distribution

  Record: file system changes, registry modifications,
          network connections, process creation, API calls
EOF
}

cmd_binary() {
    cat << 'EOF'
=== Binary Formats ===

--- ELF (Executable and Linkable Format) — Linux ---
  Header (first 64 bytes):
    Magic: 7F 45 4C 46 (".ELF")
    Class: 32-bit or 64-bit
    Endianness: little or big
    Type: executable, shared object, relocatable, core dump
    Machine: x86_64, ARM, MIPS, RISC-V

  Sections:
    .text        Executable code
    .data        Initialized global variables
    .bss         Uninitialized global variables (zero-filled)
    .rodata      Read-only data (strings, constants)
    .plt/.got    Dynamic linking (Procedure Linkage / Global Offset Table)
    .symtab      Symbol table (if not stripped)
    .strtab      String table (symbol names)
    .debug_*     Debug information (DWARF format)

  Tools: readelf, objdump, nm, ldd, strip

--- PE (Portable Executable) — Windows ---
  Header:
    DOS stub: "MZ" magic (4D 5A)
    PE signature: "PE\0\0"
    COFF header: machine, sections, timestamp
    Optional header: entry point, image base, subsystem

  Sections:
    .text        Code
    .data        Initialized data
    .rdata       Read-only data, imports
    .rsrc        Resources (icons, dialogs, version info)
    .reloc       Relocation information

  Import Address Table (IAT): lists DLL functions used
  Export Address Table (EAT): functions this DLL provides
  Tools: PE-bear, CFF Explorer, dumpbin, pestudio

--- Mach-O — macOS/iOS ---
  Header:
    Magic: FEEDFACE (32-bit) or FEEDFACF (64-bit)
    CPU type and subtype
    File type: executable, dylib, bundle

  Load commands: describe memory layout, shared libraries
  Universal (fat) binary: multiple architectures in one file
  Tools: otool, nm, class-dump (Objective-C)
EOF
}

cmd_protocols() {
    cat << 'EOF'
=== Protocol Reverse Engineering ===

--- Approach ---
  1. Capture traffic (Wireshark, tcpdump, mitmproxy)
  2. Identify protocol layers (TCP/UDP port, TLS, custom framing)
  3. Identify message boundaries (length prefix, delimiter, fixed size)
  4. Map request-response pairs
  5. Identify fields (compare multiple samples)
  6. Build parser/emitter for the protocol
  7. Fuzz to find edge cases

--- Message Structure Analysis ---
  Compare multiple captured messages:
    Msg 1: 01 00 0A 48 65 6C 6C 6F
    Msg 2: 01 00 0C 48 65 6C 6C 6F 20 57 6F
    Msg 3: 02 00 05 42 79 65 21 00

  Observations:
    Byte 0:    type/command (01 vs 02)
    Bytes 1-2: length field (0x000A=10, 0x000C=12, 0x0005=5)
    Bytes 3+:  payload (ASCII text)
    → TLV format (Type-Length-Value)

--- Common Protocol Patterns ---
  Length-prefixed:  [len][payload]
  Delimiter-based:  payload\r\n or payload\0
  Fixed-size:       always N bytes per message
  TLV:              [type][length][value]
  JSON/XML:         text-based, self-describing
  Protobuf:         binary, needs .proto schema to decode

--- HTTPS Interception ---
  mitmproxy / Burp Suite / Charles Proxy
  Install CA certificate on target device
  Inspect decrypted traffic
  Certificate pinning: bypass with Frida / Objection

--- Binary Protocol Tools ---
  Wireshark:       Protocol dissectors (custom Lua scripts)
  Kaitai Struct:   Define binary format → generate parser
  Imhex:           Hex editor with pattern language
  010 Editor:      Hex editor with binary templates
  binwalk:         Find embedded files/firmware sections

--- Replay and Fuzzing ---
  Replay: send captured request to see if response matches
  Modify: change fields and observe server behavior
  Fuzz: send malformed data to find crashes/bugs
  Tools: Boofuzz (network fuzzer), AFL (binary fuzzer)
EOF
}

cmd_tools() {
    cat << 'EOF'
=== RE Toolchain ===

--- Disassemblers / Decompilers ---
  Ghidra (Free, NSA):
    Disassembler + decompiler, Java-based
    Supports: x86, ARM, MIPS, PowerPC, many more
    Scripting: Java, Python (via Jython/Ghidrathon)
    Best free option for most RE tasks

  IDA Pro ($$$):
    Industry standard, most mature
    Hex-Rays decompiler (best in class)
    Huge plugin ecosystem
    IDA Free: limited free version

  Binary Ninja ($$):
    Modern, clean UI, fast
    Excellent API for automation
    BNIL (Binary Ninja IL) for cross-architecture analysis
    Good middle ground between Ghidra and IDA

  radare2 / rizin (Free):
    Command-line focused, very powerful
    Cutter: GUI frontend for rizin
    Steep learning curve, Unix philosophy

--- Debuggers ---
  GDB + GEF/pwndbg    Linux, all architectures
  LLDB                  macOS/iOS, LLVM integration
  x64dbg                Windows, user-mode, open source
  WinDbg                Windows, kernel + user mode
  OllyDbg               Windows, legacy but still used

--- Dynamic Instrumentation ---
  Frida:   Inject JavaScript into running processes
           Hook functions, modify behavior, bypass security
           Cross-platform: Windows, macOS, Linux, iOS, Android
  DynamoRIO: Runtime code manipulation framework
  Intel PIN: Dynamic binary instrumentation (x86)

--- Malware Analysis ---
  YARA:      Pattern matching for malware signatures
  ssdeep:    Fuzzy hashing (identify similar files)
  VirusTotal: Online multi-scanner
  Detect It Easy (DIE): Identify packers, compilers, protections
  PE-sieve:  Detect in-memory code modifications (Windows)

--- Utility ---
  binwalk:     Firmware analysis, embedded file extraction
  strings:     Extract readable text from binary
  file:        Identify file type
  hexdump/xxd: Raw hex display
  objdump:     Quick disassembly and header display
EOF
}

cmd_anti() {
    cat << 'EOF'
=== Anti-Reverse Engineering ===

Techniques used to make reverse engineering harder.

--- Obfuscation ---
  Control flow flattening: replace if/else with state machine
  Dead code insertion: add non-functional code
  String encryption: decrypt strings at runtime only
  Opaque predicates: conditions that always evaluate same way
  Instruction substitution: replace simple ops with equivalent complex ones
  Tools: LLVM Obfuscator, Tigress, VMProtect

--- Packing ---
  Compress/encrypt the binary, decompress at runtime
  Original code not visible in static analysis
  Must run or emulate to unpack

  Common packers:
    UPX:       Open source, easy to unpack (upx -d)
    Themida:   Commercial, aggressive protection
    VMProtect: Converts code to virtual machine bytecode
    ASPack:    Legacy Windows packer

  Detecting packers: Detect It Easy (DIE), PEiD, Exeinfo PE

--- Anti-Debug ---
  Check if debugger attached:
    IsDebuggerPresent() (Windows)
    ptrace(PTRACE_TRACEME) (Linux) — fails if already traced
    Timing checks: debugger makes execution slower
    Hardware breakpoint detection: check debug registers
    Exception-based: debugger handles exceptions differently

  Bypass: patch checks, modify return values with Frida

--- Anti-VM / Anti-Sandbox ---
  Detect virtual machine (malware avoidance):
    Check MAC address prefixes (VMware, VirtualBox)
    Check registry keys (VMware tools, VBox additions)
    CPUID instruction (hypervisor bit)
    Check for low resources (RAM < 4GB = probably sandbox)
    Check mouse movement (no movement = automated)
    Check recent files (empty = sandbox)

--- Code Virtualization ---
  Convert native code to custom bytecode
  Custom VM interpreter executes bytecode
  Each protected binary has different instruction set
  Most difficult protection to reverse
  Tools that do this: VMProtect, Themida, Code Virtualizer
EOF
}

cmd_practice() {
    cat << 'EOF'
=== Practice Resources ===

--- Beginner ---
  Crackmes.one:       crackmes.one
    User-submitted challenges, sorted by difficulty
    Start with difficulty 1-2, x86 architecture

  OverTheWire Narnia: overthewire.org/wargames/narnia
    Buffer overflow challenges, progressive difficulty

  PicoCTF:            picoctf.org
    Beginner-friendly CTF with RE category

  Reverse Engineering for Beginners (book):
    beginners.re — free PDF by Dennis Yurichev
    x86, ARM assembly, common patterns

--- Intermediate ---
  Flare-On Challenge:  fireeye.com/flare-on
    Annual RE challenge by Mandiant, very well-designed

  Microcorruption:     microcorruption.com
    Embedded security CTF (MSP430 architecture)
    Browser-based debugger, no setup needed

  TryHackMe RE rooms:  tryhackme.com
    Guided RE challenges in browser

  Malware Traffic Analysis: malware-traffic-analysis.net
    Real PCAP files with malware traffic for analysis

--- Advanced ---
  0CTF, DEF CON CTF:    Competition-level RE challenges
  Real malware samples:  MalwareBazaar, VirusTotal
    ⚠ Handle in isolated VM only
  Kernel driver analysis: Windows/Linux driver RE
  Firmware extraction:    Extract and analyze IoT firmware

--- Learning Path ---
  1. Learn x86/x64 assembly basics
  2. Practice with crackmes (Ghidra or IDA Free)
  3. Learn to use a debugger (GDB/x64dbg)
  4. Try simple CTF RE challenges
  5. Analyze real malware in sandbox
  6. Learn ARM assembly (mobile/IoT)
  7. Study advanced protections (packing, VM)
  8. Contribute to open-source RE tools

--- Books ---
  "Practical Reverse Engineering" — Dang, Gazet, Bachaalany
  "Practical Malware Analysis" — Sikorski, Honig
  "Reverse Engineering for Beginners" — Yurichev (free)
  "The IDA Pro Book" — Eagle
  "Hacking: The Art of Exploitation" — Erickson
EOF
}

show_help() {
    cat << EOF
reverse v$VERSION — Reverse Engineering Reference

Usage: script.sh <command>

Commands:
  intro        RE overview, methodology, and legality
  static       Static analysis: disassembly, decompilation, patterns
  dynamic      Dynamic analysis: debuggers, tracing, sandboxes
  binary       Binary formats: ELF, PE, Mach-O structure
  protocols    Protocol reverse engineering techniques
  tools        RE toolchain: Ghidra, IDA, radare2, Frida
  anti         Anti-RE techniques: obfuscation, packing, anti-debug
  practice     CTF challenges, crackmes, and learning resources
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)     cmd_intro ;;
    static)    cmd_static ;;
    dynamic)   cmd_dynamic ;;
    binary)    cmd_binary ;;
    protocols) cmd_protocols ;;
    tools)     cmd_tools ;;
    anti)      cmd_anti ;;
    practice)  cmd_practice ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "reverse v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac

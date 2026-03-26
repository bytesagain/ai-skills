#!/bin/bash
# Obfuscator - Code Obfuscation Tools Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              OBFUSCATOR REFERENCE                           ║
║          Code Obfuscation & Protection                      ║
╚══════════════════════════════════════════════════════════════╝

Code obfuscation makes source code difficult to understand
while preserving functionality. Used to protect intellectual
property, prevent reverse engineering, and deter tampering.

OBFUSCATION vs MINIFICATION vs ENCRYPTION:
  Minification     Remove whitespace (still readable)
  Obfuscation      Transform to be unreadable (still runs)
  Encryption       Cannot run without key (needs decryption)

OBFUSCATION TECHNIQUES:
  Name mangling     userCount → _0x4a3f2c
  String encoding   "hello" → "\x68\x65\x6c\x6c\x6f"
  Control flow       if/else → switch + state machine
  Dead code          Insert unused functions
  Opaque predicates  Always-true conditions that look complex
  Self-defending     Crash if code is reformatted
  Debug protection   Detect and block debugger
  Domain locking     Only run on specific domain

OBFUSCATORS BY LANGUAGE:
  JavaScript   javascript-obfuscator, JScrambler, Uglify
  Python       PyArmor, Cython, Nuitka
  Java         ProGuard, DexGuard, Allatori
  .NET         Dotfuscator, ConfuserEx
  C/C++        LLVM obfuscator, Tigress
  PHP          ionCube, Zend Guard
  Android      ProGuard, R8 (built-in)
  iOS          SwiftShield

LIMITATIONS:
  ❌ Not true security (determined attacker can reverse)
  ❌ Increases file size (10-50%)
  ❌ Slight performance overhead
  ❌ Harder to debug production issues
  ✅ Raises cost of reverse engineering
  ✅ Protects proprietary algorithms
  ✅ Prevents casual code theft
EOF
}

cmd_javascript() {
cat << 'EOF'
JAVASCRIPT OBFUSCATION
=========================

JAVASCRIPT-OBFUSCATOR:
  npm install javascript-obfuscator

  npx javascript-obfuscator input.js \
    --output output.js \
    --compact true \
    --control-flow-flattening true \
    --dead-code-injection true \
    --string-array true \
    --string-array-encoding rc4

  // API
  const JavaScriptObfuscator = require('javascript-obfuscator');

  const result = JavaScriptObfuscator.obfuscate(code, {
    compact: true,
    controlFlowFlattening: true,
    controlFlowFlatteningThreshold: 0.75,
    deadCodeInjection: true,
    deadCodeInjectionThreshold: 0.4,
    debugProtection: true,
    debugProtectionInterval: 2000,
    disableConsoleOutput: true,
    identifierNamesGenerator: 'hexadecimal',
    log: false,
    numbersToExpressions: true,
    renameGlobals: false,
    selfDefending: true,
    simplify: true,
    splitStrings: true,
    splitStringsChunkLength: 5,
    stringArray: true,
    stringArrayCallsTransform: true,
    stringArrayEncoding: ['rc4'],
    stringArrayThreshold: 0.75,
    transformObjectKeys: true,
    unicodeEscapeSequence: false,
  });

PRESETS:
  // Low (performance-friendly)
  { compact: true, simplify: true, stringArray: true }

  // Medium (balanced)
  { compact: true, controlFlowFlattening: true,
    deadCodeInjection: true, stringArray: true }

  // High (maximum protection)
  { compact: true, controlFlowFlattening: true,
    controlFlowFlatteningThreshold: 1,
    deadCodeInjection: true, deadCodeInjectionThreshold: 1,
    debugProtection: true, selfDefending: true,
    stringArray: true, stringArrayEncoding: ['rc4'] }

WEBPACK PLUGIN:
  const WebpackObfuscator = require('webpack-obfuscator');
  plugins: [
    new WebpackObfuscator({
      rotateStringArray: true,
      stringArray: true,
    }, ['excluded_bundle.js']),
  ]
EOF
}

cmd_python_java() {
cat << 'EOF'
PYTHON & JAVA OBFUSCATION
============================

PYARMOR (Python):
  pip install pyarmor

  # Obfuscate single script
  pyarmor gen script.py
  # Output: dist/script.py (obfuscated)

  # Obfuscate package
  pyarmor gen --pack onefile src/

  # With expiration
  pyarmor gen --period 30 script.py   # Expires in 30 days

  # Domain lock
  pyarmor gen --bind-device "HW-ID" script.py

  # PyArmor modes
  pyarmor gen --enable-rft script.py   # Rename functions/classes
  pyarmor gen --enable-bcc script.py   # Convert to C extensions
  pyarmor gen --enable-jit script.py   # JIT compilation

NUITKA (compile Python → binary):
  pip install nuitka
  nuitka --standalone --onefile script.py
  # Produces native binary — best protection
  # But: large binary, longer compile time

CYTHON (compile to C extension):
  # setup.py
  from Cython.Build import cythonize
  from setuptools import setup
  setup(ext_modules=cythonize("module.pyx"))
  python setup.py build_ext --inplace
  # .so/.pyd binary — very hard to reverse

PROGUARD (Java/Android):
  # proguard-rules.pro
  -optimizationpasses 5
  -dontusemixedcaseclassnames
  -dontpreverify
  -verbose

  # Keep public API
  -keep public class com.example.MyApp {
      public static void main(java.lang.String[]);
  }
  -keep public interface com.example.api.** { *; }

  # Remove logging
  -assumenosideeffects class android.util.Log {
      public static int d(...);
      public static int v(...);
  }

R8 (Android, built-in):
  // build.gradle
  android {
    buildTypes {
      release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile(
          'proguard-android-optimize.txt'),
          'proguard-rules.pro'
      }
    }
  }

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Obfuscator - Code Obfuscation Tools Reference

Commands:
  intro        Techniques, limitations
  javascript   javascript-obfuscator, Webpack
  python_java  PyArmor, Nuitka, Cython, ProGuard, R8

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)       cmd_intro ;;
  javascript)  cmd_javascript ;;
  python_java) cmd_python_java ;;
  help|*)      show_help ;;
esac

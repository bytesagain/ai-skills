#!/bin/bash
# Meson - Modern Build System Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              MESON REFERENCE                                ║
║          Modern Build System for C/C++/Rust/etc.            ║
╚══════════════════════════════════════════════════════════════╝

Meson is a modern build system focused on speed, correctness,
and user-friendliness. It generates Ninja files for fast builds.
Used by GNOME, systemd, GStreamer, Xorg, and Mesa.

MESON vs CMAKE:
  ┌──────────────┬──────────┬──────────┐
  │ Feature      │ Meson    │ CMake    │
  ├──────────────┼──────────┼──────────┤
  │ Syntax       │ Clean    │ Verbose  │
  │ Speed        │ Very fast│ Fast     │
  │ Backend      │ Ninja    │ Many     │
  │ Learning     │ Easy     │ Hard     │
  │ Adoption     │ Growing  │ Standard │
  │ Ecosystem    │ WrapDB   │ vcpkg   │
  │ Cross-compile│ Built-in │ Toolchain│
  │ IDE support  │ Good     │ Excellent│
  └──────────────┴──────────┴──────────┘

SETUP:
  pip install meson
  sudo apt install ninja-build

WORKFLOW:
  meson setup builddir              # Configure
  meson compile -C builddir         # Build
  meson test -C builddir            # Test
  meson install -C builddir         # Install
EOF
}

cmd_config() {
cat << 'EOF'
MESON.BUILD
=============

MINIMAL PROJECT:
  project('myapp', 'cpp',
    version: '1.0.0',
    default_options: ['cpp_std=c++20', 'warning_level=3'])

  executable('myapp', 'src/main.cpp', 'src/utils.cpp')

LIBRARY:
  mylib = library('mylib',
    'src/mylib.cpp',
    'src/helper.cpp',
    include_directories: include_directories('include'),
    install: true)

  mylib_dep = declare_dependency(
    include_directories: include_directories('include'),
    link_with: mylib)

  executable('myapp', 'src/main.cpp',
    dependencies: mylib_dep)

DEPENDENCIES:
  # System libraries
  thread_dep = dependency('threads')
  ssl_dep = dependency('openssl', required: true)
  boost_dep = dependency('boost', modules: ['filesystem'])
  gtk_dep = dependency('gtk4', version: '>=4.10')

  executable('myapp', 'src/main.cpp',
    dependencies: [thread_dep, ssl_dep])

  # WrapDB (Meson's package manager)
  # meson.build
  fmt_dep = dependency('fmt', fallback: ['fmt', 'fmt_dep'])
  json_dep = dependency('nlohmann_json',
    fallback: ['nlohmann_json', 'nlohmann_json_dep'])

  # Download wrap file
  meson wrap install fmt
  meson wrap install nlohmann_json

SUBDIRECTORIES:
  # Root meson.build
  subdir('src')
  subdir('lib')
  subdir('tests')

  # src/meson.build
  executable('myapp', 'main.cpp',
    dependencies: mylib_dep)

OPTIONS:
  # meson_options.txt (or meson.options)
  option('enable_tests', type: 'boolean', value: true)
  option('backend', type: 'combo',
    choices: ['sqlite', 'postgres'], value: 'sqlite')

  # meson.build
  if get_option('enable_tests')
    subdir('tests')
  endif
EOF
}

cmd_advanced() {
cat << 'EOF'
TESTING & CROSS-COMPILATION
==============================

TESTING:
  gtest_dep = dependency('gtest', fallback: ['gtest', 'gtest_dep'])
  test_exe = executable('tests',
    'test/test_main.cpp',
    'test/test_utils.cpp',
    dependencies: [gtest_dep, mylib_dep])
  test('unit tests', test_exe)

  # Test with timeout and environment
  test('slow test', test_exe,
    timeout: 120,
    env: ['TEST_DATA=/path/to/data'],
    args: ['--gtest_filter=Slow*'])

  meson test -C builddir                # Run all tests
  meson test -C builddir --verbose       # Verbose output
  meson test -C builddir -t 0            # No timeout
  meson test -C builddir --suite unit    # Run test suite

CROSS-COMPILATION:
  # cross-file.txt
  [binaries]
  c = 'aarch64-linux-gnu-gcc'
  cpp = 'aarch64-linux-gnu-g++'
  ar = 'aarch64-linux-gnu-ar'
  strip = 'aarch64-linux-gnu-strip'

  [host_machine]
  system = 'linux'
  cpu_family = 'aarch64'
  cpu = 'cortex-a72'
  endian = 'little'

  meson setup builddir --cross-file cross-file.txt

BUILD TYPES:
  meson setup builddir --buildtype=debug
  meson setup builddir --buildtype=release
  meson setup builddir --buildtype=debugoptimized

  # Reconfigure
  meson configure builddir -Dbuildtype=release
  meson configure builddir -Dcpp_std=c++23

CUSTOM TARGETS:
  # Generate code
  gen = custom_target('generate',
    output: 'generated.h',
    command: ['python3', '@INPUT@', '@OUTPUT@'],
    input: 'generate.py')

  executable('myapp', 'main.cpp', gen)

INSTALL:
  install_headers('include/mylib.h', subdir: 'mylib')
  install_data('config.ini', install_dir: get_option('datadir'))
  
  # pkg-config file
  pkg = import('pkgconfig')
  pkg.generate(mylib,
    description: 'My awesome library')

  meson install -C builddir
  meson install -C builddir --destdir /staging

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Meson - Modern Build System Reference

Commands:
  intro      Overview, Meson vs CMake
  config     meson.build, deps, WrapDB, options
  advanced   Testing, cross-compilation, install

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  config)   cmd_config ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac

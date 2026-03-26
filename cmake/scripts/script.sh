#!/bin/bash
# CMake - Cross-Platform Build System Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              CMAKE REFERENCE                                ║
║          Cross-Platform Build System Generator              ║
╚══════════════════════════════════════════════════════════════╝

CMake is the industry-standard build system for C/C++ projects.
It generates native build files (Makefiles, Ninja, Visual Studio)
from a single CMakeLists.txt configuration.

CMAKE FLOW:
  CMakeLists.txt → cmake → Makefiles/Ninja → make/ninja → binary

  mkdir build && cd build
  cmake ..                    # Configure (generate build files)
  cmake --build .             # Build
  cmake --install .           # Install
  ctest                       # Run tests

MODERN CMAKE (3.x+):
  - Target-based (not variable-based)
  - Use target_* commands (not include_directories/link_libraries)
  - Use PRIVATE/PUBLIC/INTERFACE for dependency scoping
  - Minimum version: cmake_minimum_required(VERSION 3.20)

GENERATORS:
  cmake -G "Unix Makefiles" ..     # Default on Linux
  cmake -G "Ninja" ..              # Faster builds
  cmake -G "Visual Studio 17 2022" ..  # Windows
  cmake -G "Xcode" ..              # macOS
EOF
}

cmd_config() {
cat << 'EOF'
CMAKELISTS.TXT
================

MINIMAL PROJECT:
  cmake_minimum_required(VERSION 3.20)
  project(MyApp VERSION 1.0.0 LANGUAGES CXX)

  set(CMAKE_CXX_STANDARD 20)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)

  add_executable(myapp
    src/main.cpp
    src/utils.cpp
  )

LIBRARY:
  add_library(mylib STATIC        # or SHARED
    src/mylib.cpp
    src/helper.cpp
  )
  target_include_directories(mylib PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
  )
  target_compile_features(mylib PUBLIC cxx_std_20)

LINKING:
  # Link library to executable
  target_link_libraries(myapp PRIVATE mylib)

  # PUBLIC = propagates to dependents
  # PRIVATE = only this target
  # INTERFACE = only dependents (not this target)

FIND PACKAGES:
  find_package(OpenSSL REQUIRED)
  target_link_libraries(myapp PRIVATE OpenSSL::SSL OpenSSL::Crypto)

  find_package(Boost 1.80 REQUIRED COMPONENTS filesystem system)
  target_link_libraries(myapp PRIVATE Boost::filesystem Boost::system)

  find_package(Threads REQUIRED)
  target_link_libraries(myapp PRIVATE Threads::Threads)

FETCHCONTENT (download dependencies):
  include(FetchContent)
  FetchContent_Declare(
    fmt
    GIT_REPOSITORY https://github.com/fmtlib/fmt.git
    GIT_TAG 10.2.1
  )
  FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG v1.14.0
  )
  FetchContent_MakeAvailable(fmt googletest)
  target_link_libraries(myapp PRIVATE fmt::fmt)

SUBDIRECTORIES:
  # Root CMakeLists.txt
  add_subdirectory(src)
  add_subdirectory(lib)
  add_subdirectory(tests)

OPTIONS:
  option(BUILD_TESTS "Build tests" ON)
  option(BUILD_SHARED_LIBS "Build shared libraries" OFF)

  if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
  endif()
EOF
}

cmd_advanced() {
cat << 'EOF'
ADVANCED CMAKE
================

BUILD TYPES:
  cmake -DCMAKE_BUILD_TYPE=Debug ..
  cmake -DCMAKE_BUILD_TYPE=Release ..
  cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
  cmake -DCMAKE_BUILD_TYPE=MinSizeRel ..

PRESETS (CMakePresets.json):
  {
    "version": 6,
    "configurePresets": [{
      "name": "dev",
      "generator": "Ninja",
      "binaryDir": "${sourceDir}/build/dev",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug",
        "CMAKE_EXPORT_COMPILE_COMMANDS": "ON",
        "BUILD_TESTS": "ON"
      }
    }, {
      "name": "release",
      "generator": "Ninja",
      "binaryDir": "${sourceDir}/build/release",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_TESTS": "OFF"
      }
    }],
    "buildPresets": [{
      "name": "dev",
      "configurePreset": "dev"
    }]
  }

  cmake --preset dev
  cmake --build --preset dev

TESTING (CTest):
  enable_testing()
  add_executable(tests test/main.cpp)
  target_link_libraries(tests PRIVATE GTest::gtest_main mylib)
  include(GoogleTest)
  gtest_discover_tests(tests)

  ctest --test-dir build          # Run all tests
  ctest -R "test_name"             # Run matching tests
  ctest --output-on-failure        # Show output on fail
  ctest -j8                        # Parallel tests

INSTALL:
  install(TARGETS mylib
    EXPORT MyLibTargets
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include
  )
  install(DIRECTORY include/ DESTINATION include)
  install(EXPORT MyLibTargets
    FILE MyLibConfig.cmake
    NAMESPACE MyLib::
    DESTINATION lib/cmake/MyLib
  )

COMPILE COMMANDS (for IDEs/clangd):
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
  # Generates compile_commands.json in build dir
  # Symlink to project root for clangd:
  # ln -s build/compile_commands.json .

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
CMake - Cross-Platform Build System Reference

Commands:
  intro      Overview, flow, generators
  config     CMakeLists.txt, libraries, FetchContent
  advanced   Presets, CTest, install, compile_commands

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  config)   cmd_config ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac

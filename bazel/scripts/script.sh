#!/bin/bash
# Bazel - Fast, Scalable Build System Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              BAZEL REFERENCE                                ║
║          Fast, Correct, Multi-Language Build System          ║
╚══════════════════════════════════════════════════════════════╝

Bazel is Google's open-source build system. It builds and tests
software of any size, quickly and reliably, supporting multiple
languages and platforms.

KEY PRINCIPLES:
  Hermetic        Builds are isolated, reproducible
  Incremental     Only rebuild what changed
  Parallel        Maximum concurrency automatically
  Cached          Local + remote caching
  Multi-language  Java, C++, Go, Python, Rust, etc.
  Multi-platform  Cross-compile for any target

BAZEL vs MAKE vs GRADLE:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Bazel    │ Make     │ Gradle   │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Hermeticity  │ ✓        │ ✗        │ Partial  │
  │ Incremental  │ Precise  │ Timestamp│ Task hash│
  │ Remote cache │ Built-in │ ✗        │ Plugin   │
  │ Remote exec  │ Built-in │ ✗        │ ✗        │
  │ Multi-lang   │ Native   │ Manual   │ JVM-only │
  │ Learning     │ Steep    │ Medium   │ Medium   │
  │ Monorepo     │ Excellent│ Poor     │ OK       │
  │ Speed (warm) │ Fastest  │ Fast     │ Slow     │
  └──────────────┴──────────┴──────────┴──────────┘

CORE CONCEPTS:
  Workspace     Root of your project (WORKSPACE file)
  Package       Directory with a BUILD file
  Target        A buildable unit (library, binary, test)
  Rule          How to build a target (cc_binary, py_library)
  Label         Target identifier (//path/to:target)
  Action        Concrete build step (compile, link)
  Starlark      Configuration language (Python-like)
EOF
}

cmd_basics() {
cat << 'EOF'
PROJECT STRUCTURE & BUILD FILES
=================================

WORKSPACE SETUP:
  my-project/
  ├── WORKSPACE          # or WORKSPACE.bazel or MODULE.bazel (Bzlmod)
  ├── .bazelrc           # User config
  ├── BUILD              # Root package
  ├── src/
  │   ├── BUILD
  │   ├── main.cc
  │   └── lib/
  │       ├── BUILD
  │       ├── util.cc
  │       └── util.h
  └── test/
      ├── BUILD
      └── util_test.cc

BUILD FILE EXAMPLE (C++):
  # src/lib/BUILD
  cc_library(
      name = "util",
      srcs = ["util.cc"],
      hdrs = ["util.h"],
      visibility = ["//visibility:public"],
  )

  # src/BUILD
  cc_binary(
      name = "main",
      srcs = ["main.cc"],
      deps = ["//src/lib:util"],
  )

  # test/BUILD
  cc_test(
      name = "util_test",
      srcs = ["util_test.cc"],
      deps = [
          "//src/lib:util",
          "@googletest//:gtest_main",
      ],
  )

LABELS (how to reference targets):
  //src/lib:util         Absolute: package //src/lib, target util
  :util                  Relative: same package, target util
  //src/lib              Short for //src/lib:lib (target = package name)
  @repo//pkg:target      External repository target
  //...                  Recursive glob (all packages)

COMMANDS:
  bazel build //src:main              Build a target
  bazel build //...                   Build everything
  bazel test //test:util_test         Run a test
  bazel test //...                    Run all tests
  bazel run //src:main                Build and run
  bazel run //src:main -- --flag      Pass args to binary
  bazel query //...                   List all targets
  bazel clean                         Remove build outputs
  bazel clean --expunge               Remove entire output base
  bazel info                          Show workspace info
  bazel info output_base              Show output directory
  bazel build -c opt //src:main       Optimized build
  bazel build -c dbg //src:main       Debug build

.BAZELRC:
  # .bazelrc
  build --jobs=auto
  build --verbose_failures
  test --test_output=errors
  build:ci --remote_cache=grpc://cache.example.com:9092
  build:opt -c opt --strip=always
EOF
}

cmd_rules() {
cat << 'EOF'
RULES BY LANGUAGE
===================

C/C++:
  cc_library(name, srcs, hdrs, deps, copts, linkopts, visibility)
  cc_binary(name, srcs, deps, copts, linkopts)
  cc_test(name, srcs, deps, size)

  cc_library(
      name = "mylib",
      srcs = ["mylib.cc"],
      hdrs = ["mylib.h"],
      copts = ["-std=c++17", "-Wall"],
      deps = ["@abseil-cpp//absl/strings"],
  )

JAVA:
  java_library(name, srcs, deps, resources)
  java_binary(name, srcs, main_class, deps)
  java_test(name, srcs, deps, test_class)

  java_binary(
      name = "app",
      srcs = glob(["src/main/java/**/*.java"]),
      main_class = "com.example.App",
      deps = ["@maven//:com_google_guava_guava"],
  )

PYTHON:
  py_library(name, srcs, deps, imports)
  py_binary(name, srcs, main, deps)
  py_test(name, srcs, deps)

  py_binary(
      name = "server",
      srcs = ["server.py"],
      deps = [
          "//lib:utils",
          requirement("flask"),
      ],
  )

GO:
  go_library(name, srcs, deps, importpath)
  go_binary(name, srcs, deps)
  go_test(name, srcs, deps, embed)

  # Using rules_go
  go_binary(
      name = "server",
      srcs = ["main.go"],
      deps = ["@com_github_gin_gonic_gin//:gin"],
  )

RUST:
  rust_library(name, srcs, deps, edition)
  rust_binary(name, srcs, deps)
  rust_test(name, srcs, deps)

PROTOBUF:
  proto_library(
      name = "user_proto",
      srcs = ["user.proto"],
  )
  cc_proto_library(name = "user_cc_proto", deps = [":user_proto"])
  java_proto_library(name = "user_java_proto", deps = [":user_proto"])

DOCKER:
  # rules_docker or rules_oci
  oci_image(
      name = "app_image",
      base = "@distroless_base",
      tars = [":app_layer"],
      entrypoint = ["/app"],
  )

GENERIC:
  genrule(
      name = "generate",
      srcs = ["input.txt"],
      outs = ["output.txt"],
      cmd = "cat $(SRCS) | tr a-z A-Z > $@",
  )

  filegroup(name = "configs", srcs = glob(["config/*.yaml"]))

  sh_test(name = "integration", srcs = ["integration_test.sh"], data = [":configs"])
EOF
}

cmd_deps() {
cat << 'EOF'
DEPENDENCY MANAGEMENT
=======================

BZLMOD (MODULE.bazel — recommended for Bazel 6+):
  # MODULE.bazel
  module(
      name = "my-project",
      version = "1.0.0",
  )

  bazel_dep(name = "rules_go", version = "0.44.0")
  bazel_dep(name = "rules_python", version = "0.31.0")
  bazel_dep(name = "googletest", version = "1.14.0")

  # Python pip dependencies
  pip = use_extension("@rules_python//python/extensions:pip.bzl", "pip")
  pip.parse(
      hub_name = "pypi",
      python_version = "3.11",
      requirements_lock = "//python:requirements_lock.txt",
  )
  use_repo(pip, "pypi")

WORKSPACE (legacy):
  # WORKSPACE
  load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

  http_archive(
      name = "googletest",
      urls = ["https://github.com/google/googletest/archive/refs/tags/v1.14.0.tar.gz"],
      strip_prefix = "googletest-1.14.0",
      sha256 = "...",
  )

  # Maven dependencies (Java)
  load("@rules_jvm_external//:defs.bzl", "maven_install")
  maven_install(
      artifacts = [
          "com.google.guava:guava:32.0.0-jre",
          "junit:junit:4.13.2",
      ],
      repositories = ["https://repo1.maven.org/maven2"],
  )

QUERY DEPENDENCIES:
  # What does target X depend on?
  bazel query "deps(//src:main)"

  # What depends on target X?
  bazel query "rdeps(//..., //src/lib:util)"

  # All transitive deps
  bazel query "deps(//src:main)" --output graph | dot -Tpng > deps.png

  # Find why A depends on B
  bazel query "somepath(//src:main, @abseil-cpp//absl/strings)"

  # All external dependencies
  bazel query "deps(//...)" --output package | grep @

CQUERY (configured query — respects select()):
  bazel cquery "deps(//src:main)" --output=starlark \
    --starlark:expr="target.label"

AQUERY (action graph):
  bazel aquery "//src:main"   # Show all build actions
EOF
}

cmd_advanced() {
cat << 'EOF'
ADVANCED FEATURES
===================

SELECT (Platform-specific):
  cc_library(
      name = "platform_lib",
      srcs = select({
          "@platforms//os:linux": ["linux_impl.cc"],
          "@platforms//os:macos": ["macos_impl.cc"],
          "@platforms//os:windows": ["windows_impl.cc"],
      }),
  )

TRANSITIONS (cross-compilation):
  bazel build //app:mobile --platforms=//platforms:android_arm64
  bazel build //app:server --platforms=//platforms:linux_x86_64

REMOTE CACHING:
  # .bazelrc
  build --remote_cache=grpc://cache.example.com:9092
  build --remote_upload_local_results=true

  # Or with Google Cloud
  build --remote_cache=https://storage.googleapis.com/my-bazel-cache

  # Or with S3
  build --remote_cache=http://localhost:8080  # bazel-remote proxy

REMOTE EXECUTION:
  # .bazelrc
  build --remote_executor=grpc://executor.example.com:8980
  build --remote_instance_name=my-project
  build --jobs=100  # Massively parallel builds

CUSTOM RULES (Starlark):
  # my_rules.bzl
  def _my_rule_impl(ctx):
      output = ctx.actions.declare_file(ctx.label.name + ".out")
      ctx.actions.run(
          outputs = [output],
          inputs = ctx.files.srcs,
          executable = ctx.executable._tool,
          arguments = [f.path for f in ctx.files.srcs] + [output.path],
      )
      return [DefaultInfo(files = depset([output]))]

  my_rule = rule(
      implementation = _my_rule_impl,
      attrs = {
          "srcs": attr.label_list(allow_files = True),
          "_tool": attr.label(
              default = "//tools:my_tool",
              executable = True,
              cfg = "exec",
          ),
      },
  )

ASPECTS (cross-cutting analysis):
  # Analyze ALL targets in the graph
  def _lint_aspect_impl(target, ctx):
      # Run linter on every cc_library
      ...

TESTING:
  Test sizes control timeout and resources:
    size = "small"    1 min,  no network
    size = "medium"   5 min,  no network
    size = "large"    15 min, network OK
    size = "enormous" 60 min, network OK

  # Flaky test handling
  cc_test(name = "flaky", flaky = True)

  # Test sharding
  cc_test(name = "big_test", shard_count = 10)

  # Test tagging
  cc_test(name = "slow", tags = ["manual"])  # Only run explicitly

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Bazel - Build System Reference

Commands:
  intro     Overview, comparison, core concepts
  basics    Project structure, BUILD files, commands
  rules     C++, Java, Python, Go, Rust, Protobuf, Docker
  deps      Bzlmod, WORKSPACE, query, cquery, aquery
  advanced  Select, remote cache/exec, custom rules, testing

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  basics)   cmd_basics ;;
  rules)    cmd_rules ;;
  deps)     cmd_deps ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac

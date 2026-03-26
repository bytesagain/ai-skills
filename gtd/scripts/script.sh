#!/usr/bin/env bash
# gtd — Gtd reference tool. Use when working with gtd in life contexts.
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
gtd v$VERSION — Gtd Reference Tool

Usage: gtd <command>

Commands:
  intro           Overview and basics
  guide           Step-by-step guide
  tips            Pro tips and tricks
  planning        Planning and preparation
  resources       Recommended resources
  mistakes        Common mistakes to avoid
  examples        Real-world examples
  faq             Frequently asked questions
  help              Show this help
  version           Show version

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_intro() {
    cat << 'EOF'
# Gtd — Overview

## What is Gtd?
Gtd (gtd) is a specialized tool/concept in the life domain.
It provides essential capabilities for professionals working with gtd.

## Key Concepts
- Core gtd principles and fundamentals
- How gtd fits into the broader life ecosystem  
- Essential terminology every practitioner should know

## Why Gtd Matters
Understanding gtd is critical for:
- Improving efficiency in life workflows
- Reducing errors and downtime
- Meeting industry standards and compliance requirements
- Enabling better decision-making with accurate data

## Getting Started
1. Understand the basic gtd concepts
2. Learn the standard tools and interfaces
3. Practice with common scenarios
4. Review safety and compliance requirements
EOF
}

cmd_guide() {
    cat << 'EOF'
# Gtd — Step-by-Step Guide

## Overview
This guide walks you through the essential gtd workflows.

## Step 1: Preparation
- Gather required materials and information
- Review prerequisites and requirements
- Set up your workspace

## Step 2: Execution
- Follow the standard procedure
- Monitor progress at each stage
- Document any deviations

## Step 3: Verification
- Check results against expected outcomes
- Run validation tests
- Get peer review if applicable

## Step 4: Documentation
- Record what was done and the results
- Note any lessons learned
- Update procedures if needed
EOF
}

cmd_tips() {
    cat << 'EOF'
# Gtd — Pro Tips & Tricks

## Efficiency Tips
1. Automate repetitive tasks
2. Use templates for common operations
3. Set up keyboard shortcuts
4. Batch similar operations together
5. Keep a personal cheat sheet

## Expert Tricks
- Learn the less-known features
- Build custom workflows
- Connect with the community for insights
- Study how experts approach problems
- Practice regularly to build muscle memory
EOF
}

cmd_planning() {
    cat << 'EOF'
# Gtd — Planning & Preparation

## Planning Framework
1. **Define Goals**: What do you want to achieve?
2. **Assess Current State**: Where are you now?
3. **Identify Gaps**: What needs to change?
4. **Create Plan**: Steps, timeline, resources
5. **Execute & Monitor**: Track progress

## Resource Planning
- Budget allocation
- Team and skills needed
- Tools and infrastructure
- Timeline and milestones
EOF
}

cmd_resources() {
    cat << 'EOF'
# Gtd — Recommended Resources

## Learning Resources
- Official documentation and guides
- Online courses and tutorials
- Community forums and Q&A sites
- Books and publications

## Tools
- Essential software and utilities
- Online calculators and generators
- Testing and validation tools
- Monitoring and analytics platforms
EOF
}

cmd_mistakes() {
    cat << 'EOF'
# Gtd — Common Mistakes to Avoid

## Top Mistakes
1. **Skipping planning**: Jumping in without understanding requirements
2. **Ignoring documentation**: Not recording decisions and changes
3. **Over-complicating**: Adding unnecessary complexity
4. **Skipping tests**: Deploying without verification
5. **Working in isolation**: Not seeking feedback or review

## How to Avoid Them
- Use checklists for routine operations
- Always test before deploying
- Get peer review on important changes
- Keep documentation current
- Learn from past incidents
EOF
}

cmd_examples() {
    cat << 'EOF'
# Gtd — Real-World Examples

## Example 1: Basic Setup
A typical gtd setup for a small team:
- Standard configuration with defaults
- Basic monitoring enabled
- Manual backup schedule

## Example 2: Production Deployment
An enterprise gtd deployment:
- High-availability configuration
- Automated monitoring and alerting
- Continuous backup with point-in-time recovery

## Example 3: Troubleshooting Scenario
When things go wrong:
- Symptom identification
- Root cause analysis
- Fix implementation and verification
EOF
}

cmd_faq() {
    cat << 'EOF'
# Gtd — Frequently Asked Questions

## General
**Q: What is Gtd?**
A: Gtd is a reference tool for gtd in the life domain.

**Q: Who should use this?**
A: Anyone working with gtd who needs quick reference material.

**Q: How do I get started?**
A: Run the intro command for an overview, then explore other commands.

## Technical
**Q: What are the system requirements?**
A: Bash 4.0+ on any Unix-like system (Linux, macOS).

**Q: Can I customize the output?**
A: The tool provides reference content. Customize by editing the script.

**Q: How do I report issues?**
A: Visit github.com/bytesagain/ai-skills or email hello@bytesagain.com
EOF
}

CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
    intro) cmd_intro "$@" ;;
    guide) cmd_guide "$@" ;;
    tips) cmd_tips "$@" ;;
    planning) cmd_planning "$@" ;;
    resources) cmd_resources "$@" ;;
    mistakes) cmd_mistakes "$@" ;;
    examples) cmd_examples "$@" ;;
    faq) cmd_faq "$@" ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "gtd v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: gtd help"; exit 1 ;;
esac

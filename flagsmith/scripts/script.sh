#!/bin/bash
# Flagsmith - Feature Flag & Remote Config Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              FLAGSMITH REFERENCE                            ║
║          Open Source Feature Flags & Remote Config           ║
╚══════════════════════════════════════════════════════════════╝

Flagsmith is an open-source feature flag and remote config service.
Toggle features without deploying, A/B test, and manage configs
across environments.

KEY FEATURES:
  Feature flags    Toggle features on/off per environment
  Remote config    Change values without deploying
  User segments    Target flags to specific user groups
  A/B testing      Multivariate flags with percentages
  Audit log        Track all flag changes
  Integrations     Slack, Datadog, Amplitude, Segment
  Self-hosted      Run your own instance

FLAGSMITH vs LAUNCHDARKLY vs UNLEASH:
  ┌──────────────┬──────────┬──────────────┬──────────┐
  │ Feature      │Flagsmith │ LaunchDarkly │ Unleash  │
  ├──────────────┼──────────┼──────────────┼──────────┤
  │ Open source  │ Yes      │ No           │ Yes      │
  │ Self-hosted  │ Yes      │ No           │ Yes      │
  │ Free tier    │ 50K req  │ Limited      │ 2 envs   │
  │ Remote config│ Yes      │ No           │ No       │
  │ A/B testing  │ Built-in │ Experimentation│ Plugin │
  │ SDKs         │ 15+      │ 25+          │ 15+      │
  │ Segments     │ Built-in │ Built-in     │ Built-in │
  │ Audit log    │ Yes      │ Yes          │ Premium  │
  └──────────────┴──────────┴──────────────┴──────────┘
EOF
}

cmd_flags() {
cat << 'EOF'
FEATURE FLAGS
===============

JAVASCRIPT SDK:
  import flagsmith from "flagsmith";

  // Initialize
  await flagsmith.init({
    environmentID: "your-environment-key",
    onChange: (oldFlags, params) => {
      // Called when flags change
    },
  });

  // Check boolean flag
  if (flagsmith.hasFeature("new_checkout")) {
    showNewCheckout();
  } else {
    showOldCheckout();
  }

  // Get remote config value
  const maxItems = flagsmith.getValue("max_cart_items");  // "50"
  const theme = flagsmith.getValue("ui_theme");           // "dark"

  // With default
  const limit = flagsmith.getValue("rate_limit") || "100";

PYTHON SDK:
  from flagsmith import Flagsmith

  flagsmith = Flagsmith(environment_key="your-key")

  # Get all flags
  flags = flagsmith.get_environment_flags()

  # Check flag
  if flags.is_feature_enabled("new_algorithm"):
      use_new_algorithm()

  # Get value
  max_retries = flags.get_feature_value("max_retries")

IDENTITY (per-user flags):
  // JavaScript — identify user
  await flagsmith.identify("user-123", {
    email: "alice@example.com",
    plan: "pro",
    country: "US",
  });

  // Now flags are personalized
  if (flagsmith.hasFeature("beta_feature")) {
    // Only shown to users who match segment rules
  }

  // Python
  flags = flagsmith.get_identity_flags("user-123", traits={
      "plan": "enterprise",
      "signup_date": "2026-01-15",
  })

  if flags.is_feature_enabled("advanced_analytics"):
      show_analytics_dashboard()

REST API:
  # Get environment flags
  curl https://edge.api.flagsmith.com/api/v1/flags/ \
    -H "X-Environment-Key: your-key"

  # Get identity flags
  curl -X POST https://edge.api.flagsmith.com/api/v1/identities/ \
    -H "X-Environment-Key: your-key" \
    -H "Content-Type: application/json" \
    -d '{"identifier": "user-123", "traits": [{"trait_key": "plan", "trait_value": "pro"}]}'
EOF
}

cmd_segments() {
cat << 'EOF'
SEGMENTS & PATTERNS
======================

SEGMENTS (user targeting):
  Rules target users based on traits:

  Beta Testers:
    trait "beta_enrolled" EQUALS true

  Pro Users:
    trait "plan" IN ["pro", "enterprise"]

  US Users:
    trait "country" EQUALS "US"

  Recent Signups:
    trait "signup_date" GREATER THAN "2026-01-01"

  Compound:
    trait "plan" EQUALS "enterprise"
    AND trait "employee_count" GREATER THAN 100

MULTIVARIATE FLAGS (A/B testing):
  Feature: "checkout_button_color"
  Variations:
    - "blue"    (33%)
    - "green"   (33%)
    - "red"     (34%)

  const color = flagsmith.getValue("checkout_button_color");
  // Returns "blue", "green", or "red" based on user assignment

  // Assignment is sticky — same user always gets same variant

DEPLOYMENT PATTERNS:

  Canary release:
    1. Create flag "new_feature" (default: off)
    2. Create segment "canary_users" (trait "canary" = true)
    3. Enable flag for canary segment only
    4. Monitor metrics
    5. Gradually expand to more segments
    6. Enable for all → remove flag from code

  Kill switch:
    if (flagsmith.hasFeature("payment_processing")) {
      processPayment();
    } else {
      showMaintenanceMessage();
    }

  Gradual rollout:
    Feature: "new_dashboard"
    Segment: "percentage_rollout"
    Rule: trait "user_id" % 100 < 10  → 10% of users
    Increase to 25%, 50%, 100% over time

  Entitlements:
    "max_projects" = 3  (free)
    "max_projects" = 10 (pro segment)
    "max_projects" = -1 (enterprise segment, unlimited)

ENVIRONMENTS:
  Development  → Test flags freely
  Staging      → Mirror production flags
  Production   → Careful changes with audit log

  Each environment has its own API key.
  Flags can have different states per environment.

BEST PRACTICES:
  ✓ Name flags descriptively: "enable_v2_checkout" not "flag1"
  ✓ Remove flags from code after full rollout
  ✓ Use segments for gradual rollout, not hardcoded user lists
  ✓ Set default values in code (don't rely on service being up)
  ✓ Use local evaluation SDK for latency-sensitive paths
  ✓ Audit log before making production changes

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Flagsmith - Feature Flags & Remote Config Reference

Commands:
  intro     Overview, comparison
  flags     SDKs (JS/Python), identities, REST API
  segments  User segments, A/B testing, deployment patterns

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  flags)    cmd_flags ;;
  segments) cmd_segments ;;
  help|*)   show_help ;;
esac

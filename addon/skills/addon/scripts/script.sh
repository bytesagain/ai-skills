#!/usr/bin/env bash
# addon — Addon & Extension Architecture Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Addon / Extension Architecture ===

An addon (or extension/plugin) extends a host application's
functionality without modifying its core codebase.

Types of Addons:

  Browser Extensions:
    Run inside web browsers (Chrome, Firefox, Safari, Edge)
    Built with web technologies (HTML, CSS, JavaScript)
    Access browser APIs (tabs, bookmarks, history, storage)
    Examples: uBlock Origin, LastPass, React DevTools

  Application Plugins:
    Extend desktop/server applications
    VSCode extensions, Photoshop plugins, WordPress plugins
    Usually use host app's plugin API/SDK

  Library/Framework Addons:
    Extend frameworks (Express middleware, webpack plugins)
    Follow framework's composition model
    Usually npm/pip packages with specific interface

Architecture Models:

  Monolithic + Hooks:
    App exposes lifecycle hooks (beforeSave, afterRender)
    Plugins register callbacks at hooks
    Simple but limited (can only extend where hooks exist)

  Message Bus / Event System:
    App emits events, plugins subscribe
    Loose coupling, flexible
    Used by: VSCode, Electron apps

  Microkernel:
    Minimal core + everything else is a plugin
    Eclipse, IntelliJ IDEA, webpack
    Most flexible but most complex

  Sandboxed Process:
    Plugin runs in isolated process/thread
    Communicates via IPC/message passing
    Browser extensions, VSCode extensions
    Best security — plugin can't crash host

Key Principles:
  1. Isolation: plugins shouldn't crash the host
  2. Security: plugins get minimum necessary permissions
  3. Discoverability: users can find, install, manage plugins
  4. Compatibility: handle version mismatches gracefully
  5. Performance: lazy-load plugins, don't slow down startup
EOF
}

cmd_manifest() {
    cat << 'EOF'
=== Extension Manifest Formats ===

--- Chrome Manifest V3 (manifest.json) ---
{
  "manifest_version": 3,
  "name": "My Extension",
  "version": "1.0.0",
  "description": "What it does",

  "permissions": [
    "storage",          // chrome.storage API
    "tabs",             // chrome.tabs API
    "activeTab",        // access to current tab only when clicked
    "alarms",           // chrome.alarms API
    "notifications"     // chrome.notifications API
  ],

  "host_permissions": [
    "https://api.example.com/*",   // specific sites
    "<all_urls>"                    // all sites (scrutinized in review)
  ],

  "background": {
    "service_worker": "background.js",  // V3: service worker, not persistent page
    "type": "module"                     // optional: ES modules support
  },

  "content_scripts": [{
    "matches": ["https://*.example.com/*"],
    "js": ["content.js"],
    "css": ["styles.css"],
    "run_at": "document_idle"            // document_start, document_end, document_idle
  }],

  "action": {
    "default_popup": "popup.html",
    "default_icon": "icon-48.png"
  },

  "icons": {
    "16": "icon-16.png",
    "48": "icon-48.png",
    "128": "icon-128.png"
  }
}

--- V2 → V3 Key Changes ---
  Background pages → Service workers (no persistent background)
  webRequest blocking → declarativeNetRequest (rules-based)
  Remote code execution → Banned (no eval, no CDN scripts)
  Permissions → Split into permissions + host_permissions

--- Firefox Add-on Manifest ---
  Uses same WebExtension format (mostly compatible with Chrome)
  Additional keys:
    "browser_specific_settings": {
      "gecko": { "id": "addon@example.com" }
    }
  Firefox supports both MV2 and MV3

--- Permission Levels ---
  No permission needed:  storage, alarms, i18n, runtime
  Required permission:   tabs, bookmarks, history, cookies
  Host permission:       access to specific website content
  Optional permission:   request at runtime (better UX)

  Best practice: request minimum permissions
  Use optional permissions for features user may not need
  activeTab > <all_urls> (user-triggered, less scary)
EOF
}

cmd_lifecycle() {
    cat << 'EOF'
=== Addon Lifecycle ===

--- Browser Extension Lifecycle ---

  Install:
    chrome.runtime.onInstalled (reason: "install")
    Initialize storage defaults
    Show onboarding page (optional)
    Register context menus, alarms

  Update:
    chrome.runtime.onInstalled (reason: "update")
    Migrate storage schema if needed
    previousVersion available in event details
    Content scripts re-injected automatically

  Enable:
    Extension activated by user (was disabled)
    Service worker starts
    Content scripts begin matching

  Disable:
    User disables in chrome://extensions
    Service worker terminates
    Content scripts stop executing
    Storage persists (not cleared)

  Uninstall:
    All data cleared (storage, cookies, alarms)
    chrome.runtime.setUninstallURL() — redirect to survey page
    Cannot execute code during uninstall

--- Service Worker Lifecycle (MV3) ---
  Service workers are NOT persistent — they start and stop.

  Starts when:
    Extension installed or updated
    Event listener fires (alarm, message, web request)
    User clicks extension icon

  Stops when:
    Idle for ~30 seconds (Chrome)
    No active event handlers
    All message ports closed

  Implications:
    Cannot use global variables for state — use chrome.storage
    Cannot use setInterval — use chrome.alarms
    Cannot keep WebSocket connections — use offscreen documents
    Must register event listeners synchronously at top level

--- Plugin System Lifecycle (General) ---

  Discovery:   Host scans plugin directory or registry
  Loading:     Plugin code loaded (lazy or eager)
  Validation:  Check plugin interface compatibility
  Activation:  Plugin's activate() called, registers capabilities
  Running:     Plugin responds to events, provides features
  Deactivation: Plugin's deactivate() called, cleanup resources
  Unloading:   Plugin code removed from memory

  VSCode Example:
    exports.activate = function(context) {
      // Register commands, providers, listeners
      context.subscriptions.push(disposable);
    };
    exports.deactivate = function() {
      // Cleanup
    };
EOF
}

cmd_apis() {
    cat << 'EOF'
=== Browser Extension APIs ===

--- Storage ---
  chrome.storage.local.set({ key: value })
  chrome.storage.local.get("key", (result) => ...)
  chrome.storage.sync — syncs across devices (100KB limit)
  chrome.storage.local — local only (5MB default, unlimited with permission)
  chrome.storage.session — cleared when browser closes (MV3)

--- Tabs ---
  chrome.tabs.query({ active: true, currentWindow: true })
  chrome.tabs.create({ url: "https://example.com" })
  chrome.tabs.update(tabId, { url: "https://new.com" })
  chrome.tabs.remove(tabId)
  chrome.tabs.sendMessage(tabId, message)  // to content script
  chrome.tabs.onUpdated — fires when tab loads/changes

--- Messaging ---
  // Content script → Background
  chrome.runtime.sendMessage(message, callback)

  // Background → Content script
  chrome.tabs.sendMessage(tabId, message, callback)

  // Long-lived connections
  const port = chrome.runtime.connect({ name: "channel" })
  port.postMessage(message)
  port.onMessage.addListener(handler)

  // External messaging (from web pages)
  chrome.runtime.onMessageExternal.addListener(handler)
  // Requires "externally_connectable" in manifest

--- Alarms ---
  chrome.alarms.create("checkUpdates", { periodInMinutes: 30 })
  chrome.alarms.onAlarm.addListener((alarm) => {
    if (alarm.name === "checkUpdates") { ... }
  })
  Replaces setInterval (service workers can't use timers)

--- Notifications ---
  chrome.notifications.create("id", {
    type: "basic",
    iconUrl: "icon.png",
    title: "Title",
    message: "Body text"
  })
  chrome.notifications.onClicked.addListener(handler)

--- Context Menus ---
  chrome.contextMenus.create({
    id: "myMenu",
    title: "Do something with '%s'",
    contexts: ["selection"]  // page, link, image, selection
  })
  chrome.contextMenus.onClicked.addListener(handler)

--- DeclarativeNetRequest (MV3) ---
  Replaces webRequest for blocking/redirecting:
  Rules defined in JSON, not procedural code
  {
    "id": 1,
    "action": { "type": "block" },
    "condition": { "urlFilter": "ads.example.com" }
  }
  More performant, but less flexible than webRequest
EOF
}

cmd_security() {
    cat << 'EOF'
=== Addon Security ===

--- Browser Extension Threat Model ---
  Extensions run with elevated privileges:
    Can read/modify any webpage content
    Can access browsing history, bookmarks, passwords
    Can intercept network requests
    Can execute code in page context

  Common attack vectors:
    Supply chain: compromised developer account or dependency
    Malicious update: benign extension updated with malware
    Permission abuse: extension over-requests permissions
    Data exfiltration: sending user data to external servers

--- Content Security Policy (CSP) ---
  MV3 enforces strict CSP by default:
    script-src 'self'         No inline scripts, no eval
    object-src 'self'         No plugins (Flash, Java)
    No remote code loading    All code must be in extension package

  Cannot be relaxed in MV3 (V2 allowed custom CSP)
  Prevents: XSS in extension pages, remote code injection

--- Sandboxing ---
  Content scripts run in isolated world:
    Share DOM with page but NOT JavaScript context
    Cannot access page's variables (window.X)
    Page cannot access content script variables
    Prevents: page from attacking extension

  Extension pages (popup, options):
    Run in extension process, not web page process
    Separate origin: chrome-extension://<id>
    Cannot be framed by web pages

--- Permission Best Practices ---
  1. Request minimum permissions (principle of least privilege)
  2. Use activeTab instead of <all_urls> when possible
  3. Use optional permissions for non-core features
  4. Explain permissions in extension description
  5. Never request permissions you don't use (review flags)

--- Code Review Red Flags ---
  eval(), Function(), setTimeout(string)  — dynamic code execution
  Fetching remote JS and executing it
  Sending browsing data to unknown servers
  Requesting permissions unrelated to functionality
  Obfuscated/minified source without build process
  Injecting scripts into banking/payment pages
  Accessing cookies or localStorage of visited sites
  Running in background without clear purpose

--- Secure Development ---
  Use TypeScript (catches bugs at compile time)
  Bundle with webpack/rollup (no loose dependencies at runtime)
  Pin dependency versions (lockfile)
  Audit dependencies (npm audit)
  Use chrome.storage, not localStorage (encrypted at rest)
  Validate all data from content scripts (untrusted context)
  Use CSP in your extension pages even beyond default
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Plugin Architecture Patterns ===

--- Hook System (WordPress-style) ---
  Host defines named hook points
  Plugins register callbacks at hooks

  // Host defines hooks
  const hooks = {};
  function addHook(name, callback, priority = 10) {
    hooks[name] = hooks[name] || [];
    hooks[name].push({ callback, priority });
    hooks[name].sort((a, b) => a.priority - b.priority);
  }
  function runHook(name, ...args) {
    return (hooks[name] || []).reduce(
      (result, { callback }) => callback(result, ...args),
      args[0]
    );
  }

  // Plugin uses hooks
  addHook('beforeSave', (data) => {
    data.timestamp = Date.now();
    return data;
  });

--- Middleware Pattern (Express-style) ---
  Plugins are functions in a chain
  Each calls next() to pass control

  function use(middleware) {
    stack.push(middleware);
  }
  async function execute(context) {
    let index = 0;
    async function next() {
      if (index < stack.length) {
        await stack[index++](context, next);
      }
    }
    await next();
  }

  // Plugin
  use(async (ctx, next) => {
    console.log('before');
    await next();
    console.log('after');
  });

--- Event Bus Pattern (VSCode-style) ---
  Host emits events, plugins subscribe

  const emitter = new EventEmitter();
  // Host
  emitter.emit('document:save', document);
  // Plugin
  emitter.on('document:save', (doc) => {
    validate(doc);
  });

--- Extension Point Pattern (Eclipse-style) ---
  Host declares extension points with schemas
  Plugins declare contributions to extension points

  Extension point: "commands"
  Plugin contributes:
    { id: "myPlugin.hello", title: "Say Hello", handler: fn }
  Host collects all contributions and presents them

--- Dependency Injection ---
  Host provides services to plugins via DI container
  Plugin declares what it needs in metadata
  Host resolves and injects at activation time

  // Plugin manifest
  { "requires": ["database", "logger"] }

  // Host injects
  plugin.activate({ database: dbService, logger: logService });
EOF
}

cmd_messaging() {
    cat << 'EOF'
=== Inter-Component Messaging ===

Browser extensions have multiple execution contexts that
must communicate via message passing.

--- Architecture ---
  ┌─────────────────┐
  │  Service Worker  │  Background (MV3)
  │  (background.js) │  Persistent state, API calls, coordination
  └────────┬────────┘
           │ chrome.runtime messages
  ┌────────┴────────┐
  │  Content Script  │  Injected into web pages
  │  (content.js)    │  DOM access, page interaction
  └────────┬────────┘
           │ window.postMessage (if needed)
  ┌────────┴────────┐
  │  Web Page        │  The actual website
  │  (page context)  │  No extension API access
  └──────────────────┘

  Also:
  ┌─────────────────┐
  │  Popup           │  Extension popup UI
  │  (popup.html/js) │  Short-lived (closes when unfocused)
  └─────────────────┘
  ┌─────────────────┐
  │  Options Page    │  Extension settings UI
  │  (options.html)  │  Longer-lived than popup
  └─────────────────┘

--- One-Time Messages ---

  Content Script → Background:
    // content.js
    chrome.runtime.sendMessage({ type: "getData", key: "user" },
      (response) => { console.log(response.data); }
    );

    // background.js
    chrome.runtime.onMessage.addListener((msg, sender, sendResponse) => {
      if (msg.type === "getData") {
        sendResponse({ data: storageCache[msg.key] });
      }
      return true; // keep channel open for async response
    });

  Background → Content Script:
    // background.js
    chrome.tabs.sendMessage(tabId, { type: "highlight", selector: ".result" });

    // content.js
    chrome.runtime.onMessage.addListener((msg, sender, sendResponse) => {
      if (msg.type === "highlight") {
        document.querySelector(msg.selector).style.background = "yellow";
      }
    });

--- Long-Lived Connections ---
  For ongoing communication (streaming data, real-time sync):

  // content.js
  const port = chrome.runtime.connect({ name: "stream" });
  port.postMessage({ subscribe: "updates" });
  port.onMessage.addListener((msg) => { updateUI(msg); });

  // background.js
  chrome.runtime.onConnect.addListener((port) => {
    if (port.name === "stream") {
      port.onMessage.addListener((msg) => {
        // Start sending updates
        setInterval(() => port.postMessage({ data: "..." }), 1000);
      });
    }
  });

--- Content Script ↔ Web Page ---
  Content scripts share DOM but NOT JS context.
  Communication via DOM events or window.postMessage:

  // Page → Content Script
  window.postMessage({ source: "page", type: "request" }, "*");

  // Content Script listens
  window.addEventListener("message", (event) => {
    if (event.source !== window) return;
    if (event.data.source === "page") {
      // Handle page request
    }
  });
EOF
}

cmd_publishing() {
    cat << 'EOF'
=== Publishing Addons ===

--- Chrome Web Store ---
  Developer fee: $5 one-time registration
  Review time: 1-3 business days (can be longer)
  Package: ZIP file of extension directory

  Requirements:
    manifest.json with valid manifest_version: 3
    At least one icon (128×128)
    Description, screenshots
    Privacy policy (if handling user data)

  Listing:
    Title (up to 45 characters)
    Summary (up to 132 characters)
    Description (up to 16,000 characters)
    Screenshots (1280×800 or 640×400, up to 5)
    Promotional images (optional)

  Review triggers (longer review):
    <all_urls> or broad host permissions
    webRequest / declarativeNetRequest usage
    activeTab + scripting (code injection capability)
    Remote server communication
    First submission (new developers scrutinized more)

  Updates:
    Upload new ZIP with incremented version
    Auto-update: Chrome checks every few hours
    Can set update_url for self-hosted extensions

--- Firefox Add-ons (AMO) ---
  Developer fee: free
  Review: automated + human review
  Package: ZIP (renamed to .xpi)
  Signing required: all Firefox addons must be signed by Mozilla
  Self-distribution: allowed (sign via AMO, distribute yourself)
  Listed vs Unlisted: choose visibility

--- Edge Add-ons ---
  Uses Chrome extension format (MV3)
  Developer fee: free
  Review: similar to Chrome Web Store
  Can migrate Chrome extension with minimal changes

--- Self-Hosting ---
  Chrome: enterprise policy only (can't self-host for public)
  Firefox: sign via AMO, distribute .xpi from your server
  Update manifest: XML file for automatic updates

--- Monetization ---
  Freemium: free extension + paid premium features
  Subscription: monthly/yearly via your own payment system
  Donations: link to Ko-fi, GitHub Sponsors, etc.
  Chrome Web Store Payments: deprecated (removed in 2020)

--- Common Rejection Reasons ---
  Insufficient description of functionality
  Requesting excessive permissions
  Deceptive behavior (does more than described)
  Keyword stuffing in title/description
  Low quality (crashes, errors, broken features)
  Privacy policy missing for data-handling extensions
  Duplicate of existing extension without added value
EOF
}

show_help() {
    cat << EOF
addon v$VERSION — Addon & Extension Architecture Reference

Usage: script.sh <command>

Commands:
  intro        Addon architecture types and design patterns
  manifest     Extension manifest formats and permissions
  lifecycle    Install, update, enable, disable, uninstall hooks
  apis         Browser extension APIs: tabs, storage, messaging
  security     Sandboxing, CSP, permissions, code review
  patterns     Plugin patterns: hooks, middleware, event bus
  messaging    Background ↔ content script ↔ popup communication
  publishing   Chrome Web Store, AMO, review process
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    manifest)   cmd_manifest ;;
    lifecycle)  cmd_lifecycle ;;
    apis)       cmd_apis ;;
    security)   cmd_security ;;
    patterns)   cmd_patterns ;;
    messaging)  cmd_messaging ;;
    publishing) cmd_publishing ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "addon v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac

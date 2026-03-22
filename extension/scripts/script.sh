#!/usr/bin/env bash
# extension — Browser & Editor Extension Development Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Extension Development ===

Extensions augment existing software with custom functionality without
modifying the host application's source code.

Major Extension Platforms:
  Chrome Extensions    Manifest V3, Chromium-based browsers
  Firefox Add-ons      WebExtensions API (mostly compatible)
  Safari Extensions    WebExtensions + Xcode wrapper
  VS Code Extensions   Node.js-based, rich API
  Figma Plugins        iframe sandbox, Figma API

Browser Extension Architecture:
  ┌─────────────┐  messages  ┌──────────────────┐
  │Content Script│ ←──────→  │Background Worker  │
  │(runs in page)│           │(service worker)   │
  └─────────────┘            └──────────────────┘
         ↓                          ↕
  ┌─────────────┐            ┌──────────────────┐
  │  Web Page   │            │  Popup / Options  │
  │  (DOM)      │            │  (extension UI)   │
  └─────────────┘            └──────────────────┘

Extension Types:
  Browser Action    Icon in toolbar, popup UI
  Page Action       Icon active on specific pages
  Content Script    Runs in web page context
  DevTools          Adds panels to browser DevTools
  Side Panel        Persistent sidebar (Chrome 114+)

Key Evolution: Manifest V2 → V3 (Chrome)
  V2: Persistent background pages, blocking webRequest
  V3: Service workers (non-persistent), declarativeNetRequest
  Migration deadline: V2 sunset in Chrome (2024+)

VS Code Extension Types:
  Language Support   Syntax, completions, diagnostics
  Debugger          Debug Adapter Protocol
  Theme             Color themes, icon themes
  Formatter         Code formatting providers
  Webview           Full HTML/CSS/JS panels
EOF
}

cmd_manifest() {
    cat << 'EOF'
=== Chrome Manifest V3 Reference ===

Minimal manifest.json:
  {
    "manifest_version": 3,
    "name": "My Extension",
    "version": "1.0",
    "description": "What it does",
    "icons": {
      "16": "icons/16.png",
      "48": "icons/48.png",
      "128": "icons/128.png"
    },
    "action": {
      "default_popup": "popup.html",
      "default_icon": "icons/48.png"
    },
    "permissions": ["storage", "activeTab"],
    "background": {
      "service_worker": "background.js",
      "type": "module"
    },
    "content_scripts": [{
      "matches": ["https://*.example.com/*"],
      "js": ["content.js"],
      "css": ["content.css"]
    }]
  }

Permissions (request minimum needed):
  "activeTab"        Access current tab on user action
  "storage"          chrome.storage API (sync/local)
  "tabs"             Tab URLs and metadata
  "scripting"        Programmatic script injection
  "alarms"           Periodic background tasks
  "notifications"    Desktop notifications
  "contextMenus"     Right-click menu items
  "webRequest"       Observe network requests (V3: limited)
  "cookies"          Read/write cookies
  "identity"         OAuth2 authentication

Host Permissions (V3 — separate from permissions):
  "host_permissions": [
    "https://*.example.com/*",
    "https://api.service.com/*"
  ]

Optional Permissions (request at runtime):
  "optional_permissions": ["bookmarks", "history"],
  "optional_host_permissions": ["https://*.google.com/*"]

  // Request in code:
  chrome.permissions.request({
    permissions: ['bookmarks'],
    origins: ['https://*.google.com/*']
  });

Content Security Policy (V3):
  "content_security_policy": {
    "extension_pages": "script-src 'self'; object-src 'self'"
  }
  // No remote code allowed in V3!
EOF
}

cmd_content() {
    cat << 'EOF'
=== Content Scripts ===

Content scripts run in the context of web pages but in an ISOLATED world.

What Content Scripts CAN Access:
  ✓ Full DOM of the page
  ✓ window.getComputedStyle, document.querySelector
  ✓ chrome.runtime (messaging), chrome.storage
  ✓ Shared DOM — changes are visible to page

What Content Scripts CANNOT Access:
  ✗ Page's JavaScript variables/functions
  ✗ Other chrome.* APIs (use messaging instead)
  ✗ Variables from other content scripts

Isolated World:
  Page JS:    window.myVar = 42
  Content JS: window.myVar → undefined (different world)

  To access page JS, inject into MAIN world:
    chrome.scripting.executeScript({
      target: {tabId},
      world: 'MAIN',        // runs in page's JS context
      func: () => window.myVar
    });

Injection Methods:

  1. Static (manifest.json):
     "content_scripts": [{
       "matches": ["https://example.com/*"],
       "js": ["content.js"],
       "run_at": "document_idle"
     }]

  2. Programmatic (from background):
     chrome.scripting.executeScript({
       target: {tabId: tab.id},
       files: ['inject.js']
     });

  3. Dynamic registration:
     chrome.scripting.registerContentScripts([{
       id: "my-script",
       matches: ["https://example.com/*"],
       js: ["dynamic.js"]
     }]);

Run Timing:
  "document_start"   Before DOM is built (earliest)
  "document_end"     DOM ready, before images/subframes
  "document_idle"    After DOM + resources (default, safest)

DOM Manipulation Example:
  // Hide all ads with class 'ad-banner'
  const ads = document.querySelectorAll('.ad-banner');
  ads.forEach(ad => ad.style.display = 'none');

  // Observe DOM changes (SPA support)
  const observer = new MutationObserver((mutations) => {
    mutations.forEach(m => processNewNodes(m.addedNodes));
  });
  observer.observe(document.body, {childList: true, subtree: true});
EOF
}

cmd_background() {
    cat << 'EOF'
=== Background Service Workers (V3) ===

Service workers replace persistent background pages in Manifest V3.
They are EVENT-DRIVEN and NON-PERSISTENT.

Key Differences from V2 Background Pages:
  V2: Always running, has window/document access
  V3: Starts on event, terminates when idle (~30 sec)
       No DOM access, no XMLHttpRequest (use fetch)

Lifecycle:
  Install → chrome.runtime.onInstalled
  Activate → ready to handle events
  Idle → terminated (no timers survive!)
  Event → wakes up, handles, goes idle again

Event Registration (MUST be top-level, synchronous):
  // ✓ Correct — registered at top level
  chrome.runtime.onInstalled.addListener((details) => {
    if (details.reason === 'install') {
      chrome.storage.local.set({settings: defaults});
    }
  });

  // ✗ Wrong — conditional registration may not persist
  if (someCondition) {
    chrome.runtime.onMessage.addListener(handler);
  }

Alarms (replace setInterval):
  // setInterval does NOT survive service worker termination
  // Use chrome.alarms instead:
  chrome.alarms.create('check-updates', {periodInMinutes: 30});

  chrome.alarms.onAlarm.addListener((alarm) => {
    if (alarm.name === 'check-updates') {
      checkForUpdates();
    }
  });

Storage (replaces global variables):
  // Global variables are LOST on termination
  // ✗ let count = 0;  // resets every wake-up
  // ✓ Use chrome.storage:
  const {count = 0} = await chrome.storage.session.get('count');
  await chrome.storage.session.set({count: count + 1});

  Storage types:
    chrome.storage.local     Persists, per-device, ~10MB
    chrome.storage.sync      Syncs across devices, 100KB
    chrome.storage.session   In-memory, cleared on restart

Context Menus:
  chrome.runtime.onInstalled.addListener(() => {
    chrome.contextMenus.create({
      id: 'lookup',
      title: 'Look up "%s"',
      contexts: ['selection']
    });
  });

  chrome.contextMenus.onClicked.addListener((info, tab) => {
    if (info.menuItemId === 'lookup') {
      lookupWord(info.selectionText);
    }
  });
EOF
}

cmd_messaging() {
    cat << 'EOF'
=== Extension Messaging ===

--- Content Script ↔ Background ---

  Content → Background (one-time):
    // content.js
    const response = await chrome.runtime.sendMessage({
      type: 'FETCH_DATA',
      url: 'https://api.example.com/data'
    });

    // background.js
    chrome.runtime.onMessage.addListener((msg, sender, sendResponse) => {
      if (msg.type === 'FETCH_DATA') {
        fetch(msg.url)
          .then(r => r.json())
          .then(data => sendResponse({data}));
        return true;  // keep channel open for async response
      }
    });

  Background → Content (to specific tab):
    chrome.tabs.sendMessage(tabId, {type: 'UPDATE', data: newData});

--- Long-Lived Connections ---
  // content.js
  const port = chrome.runtime.connect({name: 'sidebar'});
  port.postMessage({type: 'INIT'});
  port.onMessage.addListener((msg) => { /* handle */ });

  // background.js
  chrome.runtime.onConnect.addListener((port) => {
    if (port.name === 'sidebar') {
      port.onMessage.addListener((msg) => {
        port.postMessage({type: 'RESPONSE', data: result});
      });
    }
  });

--- Popup ↔ Background ---
  // popup.js (same extension context, can directly call)
  chrome.runtime.sendMessage({type: 'GET_STATUS'});

  // Or access background directly (V3 — limited):
  // Use messaging instead of getBackgroundPage (removed in V3)

--- Cross-Extension Messaging ---
  // Sender (knows target extension ID)
  chrome.runtime.sendMessage(
    'other-extension-id',
    {type: 'REQUEST'},
    (response) => { /* handle */ }
  );

  // Receiver (in manifest: "externally_connectable")
  chrome.runtime.onMessageExternal.addListener(
    (msg, sender, sendResponse) => {
      if (sender.id === 'trusted-extension-id') {
        sendResponse({data: 'ok'});
      }
    }
  );

--- Web Page → Extension ---
  // manifest.json
  "externally_connectable": {
    "matches": ["https://example.com/*"]
  }

  // Web page JS
  chrome.runtime.sendMessage('extension-id', {type: 'FROM_WEB'});
EOF
}

cmd_vscode() {
    cat << 'EOF'
=== VS Code Extension Development ===

--- Project Structure ---
  my-extension/
  ├── package.json          Extension manifest
  ├── src/
  │   └── extension.ts      Entry point
  ├── syntaxes/             Language grammars (TextMate)
  ├── snippets/             Code snippets
  ├── themes/               Color themes
  └── tsconfig.json

--- package.json (Extension Manifest) ---
  {
    "name": "my-extension",
    "displayName": "My Extension",
    "version": "1.0.0",
    "engines": {"vscode": "^1.85.0"},
    "categories": ["Programming Languages"],
    "activationEvents": [],
    "main": "./out/extension.js",
    "contributes": {
      "commands": [{
        "command": "myext.helloWorld",
        "title": "Hello World"
      }],
      "keybindings": [{
        "command": "myext.helloWorld",
        "key": "ctrl+shift+h"
      }]
    }
  }

--- Entry Point ---
  import * as vscode from 'vscode';

  export function activate(context: vscode.ExtensionContext) {
    const cmd = vscode.commands.registerCommand(
      'myext.helloWorld',
      () => vscode.window.showInformationMessage('Hello!')
    );
    context.subscriptions.push(cmd);
  }

  export function deactivate() {}

--- Key APIs ---
  vscode.window           Editors, terminals, UI
  vscode.workspace        Files, configuration, events
  vscode.languages        Language features, diagnostics
  vscode.commands          Command palette integration
  vscode.debug            Debugger integration
  vscode.extensions       Other extensions, API sharing

--- Language Features ---
  CompletionProvider       Autocomplete suggestions
  HoverProvider            Hover information
  DefinitionProvider       Go to definition
  DiagnosticCollection     Errors/warnings (squiggles)
  CodeActionProvider       Quick fixes, refactorings
  DocumentFormattingProvider  Format on save

--- Webview (full HTML UI) ---
  const panel = vscode.window.createWebviewPanel(
    'myView', 'My View', vscode.ViewColumn.One,
    {enableScripts: true}
  );
  panel.webview.html = '<html>...</html>';

--- Debugging Extensions ---
  Press F5 in VS Code → launches Extension Development Host
  console.log → appears in Debug Console
  Breakpoints work normally in TypeScript source
EOF
}

cmd_security() {
    cat << 'EOF'
=== Extension Security ===

--- Content Security Policy (CSP) ---
  Manifest V3 enforces strict CSP:
    - No inline scripts (<script>alert(1)</script> blocked)
    - No eval(), new Function(), setTimeout(string)
    - No remote code (CDN scripts blocked)
    - All code must be in the extension package

  Custom CSP (stricter than default):
    "content_security_policy": {
      "extension_pages": "script-src 'self'; object-src 'self'"
    }

--- Principle of Least Privilege ---
  ✗ "permissions": ["<all_urls>", "tabs", "cookies", "history"]
  ✓ "permissions": ["activeTab", "storage"]
  ✓ "optional_permissions": ["cookies"]  // request when needed

  activeTab > host permissions:
    Only activates on user click
    Only for current tab
    No persistent access

--- Common Vulnerabilities ---
  1. XSS via innerHTML
     ✗ element.innerHTML = userInput
     ✓ element.textContent = userInput
     ✓ DOMPurify.sanitize(userInput) if HTML needed

  2. Message origin validation
     ✗ chrome.runtime.onMessage.addListener((msg) => {
         eval(msg.code);  // arbitrary code execution
       });
     ✓ Validate message types, sanitize data
     ✓ Check sender.id for cross-extension messages

  3. HTTPS-only communication
     ✗ fetch('http://api.example.com/data')
     ✓ fetch('https://api.example.com/data')

  4. Storage of sensitive data
     ✗ chrome.storage.sync.set({password: '...'})
     ✓ Use oauth tokens with minimal scope
     ✓ Never store credentials in plaintext

--- Chrome Web Store Review ---
  Automated + manual review
  Checks for: obfuscated code, excessive permissions,
  privacy policy requirements, remote code loading
  Review time: days to weeks
  Rejections require fixing and resubmission

--- Privacy Requirements ---
  Must disclose: data collected, how it's used, who it's shared with
  Privacy policy required if collecting personal data
  User consent required for data collection
  Must honor "limited use" policy for Google user data
EOF
}

cmd_publish() {
    cat << 'EOF'
=== Publishing Extensions ===

--- Chrome Web Store ---
  1. Create developer account ($5 one-time fee)
  2. Package extension as .zip
  3. Upload to Chrome Web Store Developer Dashboard
  4. Fill listing: description, screenshots, category
  5. Submit for review

  Package: zip -r extension.zip . -x ".*" "node_modules/*"

  Listing requirements:
    - Clear, accurate description
    - At least 1 screenshot (1280x800 or 640x400)
    - Small icon: 128x128, Store icon: 96x96
    - Privacy policy URL (if collecting data)
    - Single-purpose: one narrowly-scoped functionality

  Update process:
    - Bump version in manifest.json
    - Upload new .zip
    - Incremental review (usually faster)

--- Firefox AMO (addons.mozilla.org) ---
  1. Create AMO developer account (free)
  2. web-ext build → creates .zip
  3. Upload to AMO
  4. Automated + human review
  5. Listed or self-hosted (unsigned = dev only)

  CLI tool: web-ext
    web-ext lint      Validate extension
    web-ext run       Test in Firefox
    web-ext build     Create installable package
    web-ext sign      Sign for self-distribution

--- VS Code Marketplace ---
  1. Create Azure DevOps organization
  2. Get Personal Access Token
  3. Install: npm install -g @vscode/vsce
  4. Package: vsce package → creates .vsix
  5. Publish: vsce publish

  Or: upload .vsix to marketplace.visualstudio.com

  vsce commands:
    vsce package      Create .vsix file
    vsce publish      Publish to marketplace
    vsce unpublish    Remove from marketplace
    vsce ls-publishers List your publishers

--- Version Strategy ---
  Semantic versioning: MAJOR.MINOR.PATCH
  Chrome auto-updates extensions (check every few hours)
  Users can pin versions or disable auto-update
  Staged rollout available on Chrome Web Store
EOF
}

show_help() {
    cat << EOF
extension v$VERSION — Browser & Editor Extension Development Reference

Usage: script.sh <command>

Commands:
  intro        Extension architecture overview
  manifest     Chrome Manifest V3 reference
  content      Content scripts and DOM interaction
  background   Background service workers
  messaging    Extension messaging patterns
  vscode       VS Code extension development
  security     Extension security best practices
  publish      Publishing to stores and marketplaces
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    manifest)   cmd_manifest ;;
    content)    cmd_content ;;
    background) cmd_background ;;
    messaging)  cmd_messaging ;;
    vscode)     cmd_vscode ;;
    security)   cmd_security ;;
    publish)    cmd_publish ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "extension v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac

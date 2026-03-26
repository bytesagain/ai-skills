#!/bin/bash
# Cypress - E2E Testing Framework Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              CYPRESS REFERENCE                              ║
║          Modern E2E Testing for the Web                     ║
╚══════════════════════════════════════════════════════════════╝

Cypress is a JavaScript end-to-end testing framework that runs
directly in the browser. It provides fast, reliable testing with
automatic waiting, time-travel debugging, and real-time reloads.

KEY FEATURES:
  Real browser    Tests run in actual Chrome/Firefox/Edge
  Auto-waiting    No sleep/wait — Cypress retries automatically
  Time travel     Hover over commands to see DOM snapshots
  Network control Stub/intercept HTTP requests
  Screenshots     Automatic on failure
  Video           Record full test runs
  Component test  Test React/Vue/Angular components in isolation

CYPRESS vs PLAYWRIGHT vs SELENIUM:
  ┌──────────────┬──────────┬────────────┬──────────┐
  │ Feature      │ Cypress  │ Playwright │ Selenium │
  ├──────────────┼──────────┼────────────┼──────────┤
  │ Language     │ JS only  │ Multi      │ Multi    │
  │ Auto-wait    │ Built-in │ Built-in   │ Manual   │
  │ Multi-tab    │ No       │ Yes        │ Yes      │
  │ iframes      │ Limited  │ Full       │ Full     │
  │ Network stub │ Built-in │ Built-in   │ No       │
  │ Speed        │ Fast     │ Fastest    │ Slow     │
  │ Debugging    │ Best     │ Good       │ Poor     │
  │ CI support   │ Cloud    │ Built-in   │ Manual   │
  │ Cross-origin │ Limited* │ Full       │ Full     │
  └──────────────┴──────────┴────────────┴──────────┘
  * Improved in Cypress 12+

INSTALL:
  npm install --save-dev cypress
  npx cypress open      # GUI mode
  npx cypress run        # Headless mode
EOF
}

cmd_basics() {
cat << 'EOF'
WRITING TESTS
===============

BASIC TEST:
  // cypress/e2e/login.cy.js
  describe("Login", () => {
    beforeEach(() => {
      cy.visit("/login");
    });

    it("should log in with valid credentials", () => {
      cy.get('[data-testid="email"]').type("user@example.com");
      cy.get('[data-testid="password"]').type("password123");
      cy.get('[data-testid="submit"]').click();
      cy.url().should("include", "/dashboard");
      cy.get("h1").should("contain", "Welcome");
    });

    it("should show error for invalid password", () => {
      cy.get('[data-testid="email"]').type("user@example.com");
      cy.get('[data-testid="password"]').type("wrong");
      cy.get('[data-testid="submit"]').click();
      cy.get(".error").should("be.visible").and("contain", "Invalid");
    });
  });

SELECTORS:
  cy.get("button")                    // Tag
  cy.get(".submit-btn")               // Class
  cy.get("#login-form")               // ID
  cy.get('[data-testid="email"]')     // Data attribute (recommended!)
  cy.get('[type="submit"]')           // Attribute
  cy.contains("Sign In")             // Text content
  cy.get("ul").find("li")            // Child elements
  cy.get("li").first()               // First element
  cy.get("li").last()                // Last element
  cy.get("li").eq(2)                 // Third element (0-indexed)

ACTIONS:
  cy.get("input").type("hello")       // Type text
  cy.get("input").clear()             // Clear input
  cy.get("button").click()            // Click
  cy.get("button").dblclick()         // Double click
  cy.get("button").rightclick()       // Right click
  cy.get("select").select("Option 1") // Select dropdown
  cy.get("input[type=checkbox]").check()
  cy.get("input[type=checkbox]").uncheck()
  cy.get("input[type=file]").selectFile("data.csv")
  cy.get(".draggable").trigger("mousedown")
  cy.scrollTo("bottom")

ASSERTIONS:
  cy.get("h1").should("exist");
  cy.get("h1").should("not.exist");
  cy.get("h1").should("be.visible");
  cy.get("h1").should("contain", "Hello");
  cy.get("h1").should("have.text", "Hello World");
  cy.get("input").should("have.value", "test");
  cy.get("button").should("be.disabled");
  cy.get("ul li").should("have.length", 3);
  cy.get("div").should("have.class", "active");
  cy.get("div").should("have.css", "color", "rgb(255, 0, 0)");
  cy.url().should("include", "/dashboard");
  cy.title().should("eq", "My App");

  // Chained
  cy.get("table tbody tr")
    .should("have.length.greaterThan", 0)
    .first()
    .should("contain", "Alice");
EOF
}

cmd_network() {
cat << 'EOF'
NETWORK & API TESTING
=======================

INTERCEPT REQUESTS:
  // Stub API response
  cy.intercept("GET", "/api/users", {
    statusCode: 200,
    body: [
      { id: 1, name: "Alice" },
      { id: 2, name: "Bob" },
    ],
  }).as("getUsers");

  cy.visit("/users");
  cy.wait("@getUsers");
  cy.get("table tr").should("have.length", 2);

  // Stub with fixture file
  cy.intercept("GET", "/api/products", { fixture: "products.json" });

  // Modify response
  cy.intercept("GET", "/api/users", (req) => {
    req.continue((res) => {
      res.body.push({ id: 99, name: "Injected" });
    });
  });

  // Delay response
  cy.intercept("GET", "/api/slow", (req) => {
    req.reply({ delay: 2000, body: { ok: true } });
  });

  // Error response
  cy.intercept("POST", "/api/submit", {
    statusCode: 500,
    body: { error: "Server Error" },
  });

  // Assert request was made
  cy.wait("@getUsers").its("response.statusCode").should("eq", 200);

REAL API TESTING:
  cy.request("GET", "/api/users").then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body).to.have.length.greaterThan(0);
  });

  cy.request({
    method: "POST",
    url: "/api/users",
    body: { name: "Alice", email: "alice@example.com" },
    headers: { Authorization: "Bearer token123" },
  }).then((response) => {
    expect(response.status).to.eq(201);
    expect(response.body).to.have.property("id");
  });

CUSTOM COMMANDS:
  // cypress/support/commands.js
  Cypress.Commands.add("login", (email, password) => {
    cy.request("POST", "/api/login", { email, password })
      .its("body.token")
      .then((token) => {
        cy.setCookie("auth", token);
      });
  });

  // In tests:
  cy.login("admin@example.com", "password123");
  cy.visit("/dashboard");

FIXTURES:
  // cypress/fixtures/users.json
  [
    { "id": 1, "name": "Alice", "email": "alice@example.com" },
    { "id": 2, "name": "Bob", "email": "bob@example.com" }
  ]

  // Load in test
  cy.fixture("users").then((users) => {
    expect(users).to.have.length(2);
  });
EOF
}

cmd_config() {
cat << 'EOF'
CONFIGURATION & CI
=====================

CYPRESS.CONFIG.JS:
  const { defineConfig } = require("cypress");

  module.exports = defineConfig({
    e2e: {
      baseUrl: "http://localhost:3000",
      viewportWidth: 1280,
      viewportHeight: 720,
      defaultCommandTimeout: 10000,
      requestTimeout: 10000,
      responseTimeout: 30000,
      video: true,
      screenshotOnRunFailure: true,
      retries: { runMode: 2, openMode: 0 },
      specPattern: "cypress/e2e/**/*.cy.{js,ts}",
      supportFile: "cypress/support/e2e.js",

      setupNodeEvents(on, config) {
        // Plugins here
      },
    },

    component: {
      devServer: {
        framework: "react",
        bundler: "vite",
      },
    },
  });

ENV VARIABLES:
  // cypress.env.json
  { "API_URL": "http://localhost:8080", "AUTH_TOKEN": "test-token" }

  // Access in tests
  Cypress.env("API_URL")

  // CLI
  npx cypress run --env API_URL=http://staging.example.com

PROJECT STRUCTURE:
  cypress/
  ├── e2e/                 # Test files
  │   ├── auth/
  │   │   ├── login.cy.js
  │   │   └── register.cy.js
  │   └── dashboard.cy.js
  ├── fixtures/            # Test data (JSON)
  │   └── users.json
  ├── support/
  │   ├── commands.js      # Custom commands
  │   └── e2e.js           # Support file (loaded before tests)
  └── downloads/           # Downloaded files

CI (GitHub Actions):
  - name: Cypress Tests
    uses: cypress-io/github-action@v6
    with:
      start: npm run dev
      wait-on: "http://localhost:3000"
      browser: chrome
      record: true
    env:
      CYPRESS_RECORD_KEY: ${{ secrets.CYPRESS_RECORD_KEY }}

CLI:
  npx cypress open                        # GUI
  npx cypress run                         # Headless
  npx cypress run --browser chrome        # Specific browser
  npx cypress run --spec "cypress/e2e/login.cy.js"  # Single spec
  npx cypress run --headed                # Show browser
  npx cypress run --record               # Record to Cloud
  npx cypress run --parallel             # Parallel (Cloud)

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Cypress - E2E Testing Framework Reference

Commands:
  intro     Overview, comparison, install
  basics    Selectors, actions, assertions
  network   Intercept, stub, API testing, commands
  config    Configuration, CI, project structure

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)   cmd_intro ;;
  basics)  cmd_basics ;;
  network) cmd_network ;;
  config)  cmd_config ;;
  help|*)  show_help ;;
esac

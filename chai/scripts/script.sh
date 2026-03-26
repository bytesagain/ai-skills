#!/bin/bash
# Chai - BDD/TDD Assertion Library Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              CHAI REFERENCE                                 ║
║          BDD/TDD Assertion Library for JavaScript           ║
╚══════════════════════════════════════════════════════════════╝

Chai is a BDD/TDD assertion library for Node.js and browsers.
It pairs well with any test framework (Mocha, Jest, etc.)

THREE ASSERTION STYLES:
  expect    BDD style   expect(foo).to.equal("bar")
  should    BDD style   foo.should.equal("bar")
  assert    TDD style   assert.equal(foo, "bar")

INSTALL:
  npm install --save-dev chai
  // ESM
  import { expect, should, assert } from "chai";
  // CommonJS
  const { expect } = require("chai");

PLUGINS:
  chai-http           HTTP request testing
  chai-as-promised    Promise assertions
  chai-subset         Partial object matching
  chai-things         Array element assertions
  chai-spies          Spy/stub assertions
  sinon-chai          Sinon.JS integration
  chai-datetime       Date comparisons
EOF
}

cmd_expect() {
cat << 'EOF'
EXPECT API (BDD)
==================

The most popular style. Chainable, readable assertions.

EQUALITY:
  expect(42).to.equal(42);                    // Strict ===
  expect({a: 1}).to.deep.equal({a: 1});       // Deep equality
  expect("test").to.not.equal("other");       // Negation
  expect(null).to.be.null;
  expect(undefined).to.be.undefined;
  expect(true).to.be.true;
  expect(false).to.be.false;
  expect(NaN).to.be.NaN;

TYPE CHECKING:
  expect("hello").to.be.a("string");
  expect(42).to.be.a("number");
  expect([]).to.be.an("array");
  expect({}).to.be.an("object");
  expect(new Date()).to.be.an.instanceOf(Date);
  expect(null).to.be.a("null");

COMPARISON:
  expect(10).to.be.above(5);                  // >
  expect(10).to.be.at.least(10);              // >=
  expect(5).to.be.below(10);                  // <
  expect(5).to.be.at.most(5);                 // <=
  expect(7).to.be.within(5, 10);              // 5 <= x <= 10
  expect(0.1 + 0.2).to.be.closeTo(0.3, 0.001); // Float tolerance

STRINGS:
  expect("hello world").to.include("world");
  expect("hello").to.have.lengthOf(5);
  expect("test@email.com").to.match(/^[^@]+@[^@]+$/);
  expect("").to.be.empty;
  expect("foobar").to.have.string("bar");

ARRAYS:
  expect([1, 2, 3]).to.include(2);
  expect([1, 2, 3]).to.have.lengthOf(3);
  expect([1, 2, 3]).to.have.members([3, 1, 2]);      // Same members
  expect([1, 2, 3]).to.include.members([1, 3]);       // Subset
  expect([1, 2, 3]).to.have.ordered.members([1, 2, 3]);
  expect([]).to.be.empty;
  expect([1, 2, 3]).to.deep.include({a: 1});          // With objects

OBJECTS:
  expect({a: 1, b: 2}).to.have.property("a");
  expect({a: 1}).to.have.property("a", 1);            // Key + value
  expect({a: 1, b: 2}).to.have.all.keys("a", "b");
  expect({a: 1, b: 2}).to.have.any.keys("a", "c");
  expect({a: {b: 1}}).to.have.nested.property("a.b");
  expect({a: {b: 1}}).to.have.nested.property("a.b", 1);
  expect({a: 1, b: 2}).to.include({a: 1});            // Partial match
  expect({a: 1}).to.have.own.property("a");            // Not inherited
  expect({a: 1, b: 2, c: 3}).to.have.all.keys("a", "b", "c");

DEEP:
  expect([{a: 1}]).to.deep.include({a: 1});
  expect({a: {b: {c: 1}}}).to.deep.equal({a: {b: {c: 1}}});
  expect(new Set([1, 2])).to.deep.equal(new Set([1, 2]));
  expect(new Map([["a", 1]])).to.deep.equal(new Map([["a", 1]]));
EOF
}

cmd_advanced() {
cat << 'EOF'
ADVANCED PATTERNS
===================

ERRORS:
  expect(() => { throw new Error("boom"); }).to.throw();
  expect(() => { throw new Error("boom"); }).to.throw("boom");
  expect(() => { throw new Error("boom"); }).to.throw(Error);
  expect(() => { throw new Error("boom"); }).to.throw(Error, "boom");
  expect(() => { throw new TypeError("bad"); }).to.throw(TypeError);
  expect(() => {}).to.not.throw();

  // Async errors
  await expect(asyncFn()).to.be.rejectedWith("error");  // chai-as-promised

PROMISES (chai-as-promised):
  const chai = require("chai");
  const chaiAsPromised = require("chai-as-promised");
  chai.use(chaiAsPromised);

  await expect(Promise.resolve(42)).to.eventually.equal(42);
  await expect(Promise.resolve([1,2])).to.eventually.have.lengthOf(2);
  await expect(Promise.reject(new Error("fail"))).to.be.rejected;
  await expect(Promise.reject(new Error("fail"))).to.be.rejectedWith("fail");
  await expect(fetchUser(1)).to.eventually.have.property("name");

HTTP TESTING (chai-http):
  const chai = require("chai");
  const chaiHttp = require("chai-http");
  chai.use(chaiHttp);
  const app = require("../app");

  // GET
  const res = await chai.request(app).get("/api/users");
  expect(res).to.have.status(200);
  expect(res).to.be.json;
  expect(res.body).to.be.an("array");

  // POST
  const res = await chai.request(app)
    .post("/api/users")
    .set("Authorization", "Bearer token123")
    .send({ name: "Alice", email: "alice@example.com" });
  expect(res).to.have.status(201);
  expect(res.body).to.have.property("id");

  // Assertions
  expect(res).to.have.header("content-type", /json/);
  expect(res).to.redirectTo("https://example.com");
  expect(res).to.have.cookie("session");

SINON-CHAI:
  const sinon = require("sinon");
  const sinonChai = require("sinon-chai");
  chai.use(sinonChai);

  const spy = sinon.spy();
  spy("hello");

  expect(spy).to.have.been.called;
  expect(spy).to.have.been.calledOnce;
  expect(spy).to.have.been.calledWith("hello");
  expect(spy).to.have.been.calledBefore(otherSpy);
  expect(spy).to.have.returned(42);

CUSTOM ASSERTIONS:
  chai.use((chai, utils) => {
    chai.Assertion.addMethod("validEmail", function () {
      const obj = this._obj;
      const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      this.assert(
        re.test(obj),
        "expected #{this} to be a valid email",
        "expected #{this} to not be a valid email"
      );
    });
  });

  expect("user@example.com").to.be.a.validEmail();

CHAINING LANGUAGE:
  These words don't do anything — they just improve readability:
  to, be, been, is, that, which, and, has, have, with, at, of, same, but, does

  expect(foo).to.be.an("object").that.has.property("x");

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Chai - BDD/TDD Assertion Library Reference

Commands:
  intro      Overview, styles, plugins
  expect     Expect API: equality, types, strings, arrays, objects
  advanced   Errors, promises, HTTP, Sinon, custom assertions

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  expect)   cmd_expect ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac

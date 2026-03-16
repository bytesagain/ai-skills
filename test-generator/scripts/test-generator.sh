#!/usr/bin/env bash
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in

unit)
  LANG="${1:-python}"
  FUNC="${2:-calculate_total}"
  python3 << 'PYEOF'
import sys
lang = sys.argv[1] if len(sys.argv) > 1 else "python"
func = sys.argv[2] if len(sys.argv) > 2 else "calculate_total"
snake = func.replace("-", "_")
camel = "".join(w.capitalize() for w in snake.split("_"))

print("=" * 60)
print("  Unit Test: {}".format(func))
print("  Language: {}".format(lang))
print("=" * 60)
print("")

if lang == "python":
    print("import pytest")
    print("from module import {}".format(snake))
    print("")
    print("")
    print("class Test{}:".format(camel))
    print('    """Tests for {}"""'.format(snake))
    print("")
    print("    def test_{}_basic(self):".format(snake))
    print("        # Arrange")
    print("        input_data = None  # TODO: set input")
    print("        expected = None    # TODO: set expected")
    print("        # Act")
    print("        result = {}(input_data)".format(snake))
    print("        # Assert")
    print("        assert result == expected")
    print("")
    print("    def test_{}_empty_input(self):".format(snake))
    print("        with pytest.raises(ValueError):")
    print("            {}(None)".format(snake))
    print("")
    print("    def test_{}_returns_correct_type(self):".format(snake))
    print("        result = {}(sample_input)".format(snake))
    print("        assert isinstance(result, expected_type)")
    print("")
    print("    @pytest.mark.parametrize('input_val,expected', [")
    print("        (1, 1),")
    print("        (0, 0),")
    print("        (-1, -1),")
    print("    ])")
    print("    def test_{}_parametrized(self, input_val, expected):".format(snake))
    print("        assert {}(input_val) == expected".format(snake))

elif lang == "javascript":
    print("const {{ {} }} = require('./module');".format(func))
    print("")
    print("describe('{}', () => {{".format(func))
    print("  test('should handle basic case', () => {")
    print("    const input = null; // TODO: set input")
    print("    const expected = null; // TODO: set expected")
    print("    expect({}(input)).toBe(expected);".format(func))
    print("  });")
    print("")
    print("  test('should throw on invalid input', () => {")
    print("    expect(() => {}(null)).toThrow();".format(func))
    print("  });")
    print("")
    print("  test('should return correct type', () => {")
    print("    const result = {}(validInput);".format(func))
    print("    expect(typeof result).toBe('number');")
    print("  });")
    print("")
    print("  test.each([")
    print("    [1, 1],")
    print("    [0, 0],")
    print("    [-1, -1],")
    print("  ])('given %i should return %i', (input, expected) => {")
    print("    expect({}(input)).toBe(expected);".format(func))
    print("  });")
    print("});")

elif lang == "go":
    print("package main")
    print("")
    print('import "testing"')
    print("")
    print("func Test{}Basic(t *testing.T) {{".format(camel))
    print("    got := {}(input)".format(camel))
    print("    want := expected")
    print("    if got != want {")
    print('        t.Errorf("{} = %v, want %v", got, want)'.format(camel))
    print("    }")
    print("}")
    print("")
    print("func Test{}TableDriven(t *testing.T) {{".format(camel))
    print("    tests := []struct {")
    print("        name  string")
    print("        input int")
    print("        want  int")
    print("    }{")
    print('        {"zero", 0, 0},')
    print('        {"positive", 1, 1},')
    print('        {"negative", -1, -1},')
    print("    }")
    print("    for _, tt := range tests {")
    print("        t.Run(tt.name, func(t *testing.T) {")
    print("            if got := {}(tt.input); got != tt.want {{".format(camel))
    print('                t.Errorf("got %v, want %v", got, tt.want)')
    print("            }")
    print("        })")
    print("    }")
    print("}")

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

integration)
  LANG="${1:-python}"
  MODULE="${2:-user_service}"
  python3 << 'PYEOF'
import sys
lang = sys.argv[1] if len(sys.argv) > 1 else "python"
module = sys.argv[2] if len(sys.argv) > 2 else "user_service"

print("=" * 60)
print("  Integration Test: {}".format(module))
print("=" * 60)
print("")

if lang == "python":
    print("import pytest")
    print("from {} import {}".format(module, module.split("_")[0].capitalize() + "Service"))
    print("")
    print("")
    print("@pytest.fixture")
    print("def db_session():")
    print("    # Setup: create test database/connection")
    print("    session = create_test_session()")
    print("    yield session")
    print("    # Teardown: rollback and close")
    print("    session.rollback()")
    print("    session.close()")
    print("")
    print("")
    print("@pytest.fixture")
    print("def service(db_session):")
    print("    return {}(db=db_session)".format(module.split("_")[0].capitalize() + "Service"))
    print("")
    print("")
    print("class TestIntegration{}:".format(module.replace("_", " ").title().replace(" ", "")))
    print("")
    print("    def test_create_and_retrieve(self, service):")
    print("        # Create")
    print("        obj = service.create(data={'name': 'test'})")
    print("        assert obj.id is not None")
    print("        # Retrieve")
    print("        found = service.get(obj.id)")
    print("        assert found.name == 'test'")
    print("")
    print("    def test_update_persists(self, service):")
    print("        obj = service.create(data={'name': 'old'})")
    print("        service.update(obj.id, {'name': 'new'})")
    print("        found = service.get(obj.id)")
    print("        assert found.name == 'new'")

elif lang == "javascript":
    print("const request = require('supertest');")
    print("const app = require('../app');")
    print("const db = require('../db');")
    print("")
    print("beforeAll(async () => {")
    print("  await db.connect('test_db');")
    print("});")
    print("")
    print("afterAll(async () => {")
    print("  await db.disconnect();")
    print("});")
    print("")
    print("afterEach(async () => {")
    print("  await db.clear();")
    print("});")
    print("")
    print("describe('{} integration', () => {{".format(module))
    print("  test('create and retrieve', async () => {")
    print("    const res = await request(app)")
    print("      .post('/api/{}')".format(module.replace("_", "-")))
    print("      .send({ name: 'test' });")
    print("    expect(res.status).toBe(201);")
    print("")
    print("    const get = await request(app)")
    print("      .get('/api/{}/{}'.format(module.replace('_', '-'), '${res.body.id}'));")
    print("    expect(get.body.name).toBe('test');")
    print("  });")
    print("});")

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

e2e)
  LANG="${1:-javascript}"
  FLOW="${2:-login}"
  python3 << 'PYEOF'
import sys
lang = sys.argv[1] if len(sys.argv) > 1 else "javascript"
flow = sys.argv[2] if len(sys.argv) > 2 else "login"

print("=" * 60)
print("  E2E Test: {} flow".format(flow))
print("=" * 60)
print("")

if lang == "javascript":
    print("// Playwright E2E Test")
    print("const {{ test, expect }} = require('@playwright/test');")
    print("")
    print("test.describe('{} flow', () => {{".format(flow))
    print("")
    print("  test.beforeEach(async ({{ page }}) => {")
    print("    await page.goto('http://localhost:3000');")
    print("  });")
    print("")
    if flow == "login":
        print("  test('successful login', async ({ page }) => {")
        print("    await page.fill('[data-testid=\"email\"]', 'user@test.com');")
        print("    await page.fill('[data-testid=\"password\"]', 'password123');")
        print("    await page.click('[data-testid=\"login-btn\"]');")
        print("    await expect(page.locator('[data-testid=\"dashboard\"]')).toBeVisible();")
        print("  });")
        print("")
        print("  test('invalid credentials', async ({ page }) => {")
        print("    await page.fill('[data-testid=\"email\"]', 'wrong@test.com');")
        print("    await page.fill('[data-testid=\"password\"]', 'wrong');")
        print("    await page.click('[data-testid=\"login-btn\"]');")
        print("    await expect(page.locator('.error-message')).toContainText('Invalid');")
        print("  });")
    else:
        print("  test('{} happy path', async ({{ page }}) => {{".format(flow))
        print("    // TODO: implement {} flow steps".format(flow))
        print("    await expect(page.locator('.success')).toBeVisible();")
        print("  });")
    print("});")

elif lang == "python":
    print("# Selenium E2E Test")
    print("import pytest")
    print("from selenium import webdriver")
    print("from selenium.webdriver.common.by import By")
    print("from selenium.webdriver.support.ui import WebDriverWait")
    print("from selenium.webdriver.support import expected_conditions as EC")
    print("")
    print("")
    print("@pytest.fixture")
    print("def driver():")
    print("    d = webdriver.Chrome()")
    print("    d.implicitly_wait(10)")
    print("    yield d")
    print("    d.quit()")
    print("")
    print("")
    print("class TestE2E{}:".format(flow.capitalize()))
    print("")
    print("    def test_{}_success(self, driver):".format(flow))
    print("        driver.get('http://localhost:3000')")
    print("        # TODO: implement {} flow".format(flow))
    print("        assert driver.find_element(By.CSS_SELECTOR, '.success')")

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

mock)
  LANG="${1:-python}"
  TARGET="${2:-database}"
  python3 << 'PYEOF'
import sys
lang = sys.argv[1] if len(sys.argv) > 1 else "python"
target = sys.argv[2] if len(sys.argv) > 2 else "database"

print("=" * 60)
print("  Mock Object: {}".format(target))
print("=" * 60)
print("")

if lang == "python":
    print("from unittest.mock import Mock, patch, MagicMock")
    print("")
    if target == "database":
        print("# Mock database connection")
        print("mock_db = MagicMock()")
        print("mock_db.query.return_value = [{'id': 1, 'name': 'test'}]")
        print("mock_db.insert.return_value = {'id': 2}")
        print("mock_db.delete.return_value = True")
        print("")
        print("# Usage with patch")
        print("@patch('myapp.db.get_connection')")
        print("def test_with_mock_db(mock_conn):")
        print("    mock_conn.return_value = mock_db")
        print("    result = my_function()")
        print("    mock_db.query.assert_called_once()")
    elif target == "api":
        print("# Mock HTTP API")
        print("mock_response = Mock()")
        print("mock_response.status_code = 200")
        print("mock_response.json.return_value = {'data': 'test'}")
        print("mock_response.raise_for_status = Mock()")
        print("")
        print("@patch('requests.get')")
        print("def test_api_call(mock_get):")
        print("    mock_get.return_value = mock_response")
        print("    result = fetch_data()")
        print("    assert result == {'data': 'test'}")
    else:
        print("# Generic mock for {}".format(target))
        print("mock_{} = MagicMock(spec={})".format(target, target.capitalize()))
        print("mock_{}.method.return_value = 'mocked'".format(target))
        print("mock_{}.property = 'value'".format(target))

elif lang == "javascript":
    print("// Jest Mock")
    if target == "database":
        print("const mockDb = {")
        print("  query: jest.fn().mockResolvedValue([{ id: 1 }]),")
        print("  insert: jest.fn().mockResolvedValue({ id: 2 }),")
        print("  close: jest.fn(),")
        print("};")
        print("")
        print("jest.mock('../db', () => mockDb);")
    elif target == "api":
        print("global.fetch = jest.fn(() =>")
        print("  Promise.resolve({")
        print("    ok: true,")
        print("    json: () => Promise.resolve({ data: 'test' }),")
        print("  })")
        print(");")
    else:
        print("const mock{} = {{".format(target.capitalize()))
        print("  method: jest.fn().mockReturnValue('mocked'),")
        print("};")

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

fixture)
  LANG="${1:-python}"
  TYPE="${2:-user}"
  python3 << 'PYEOF'
import sys
lang = sys.argv[1] if len(sys.argv) > 1 else "python"
ftype = sys.argv[2] if len(sys.argv) > 2 else "user"

print("=" * 60)
print("  Test Fixture: {}".format(ftype))
print("=" * 60)
print("")

fixtures = {
    "user": {"name": "Test User", "email": "test@example.com", "age": 25, "role": "user"},
    "product": {"name": "Widget", "price": 9.99, "sku": "WGT-001", "stock": 100},
    "order": {"id": "ORD-001", "user_id": 1, "total": 29.97, "status": "pending"},
}
data = fixtures.get(ftype, {"id": 1, "name": "test", "value": "sample"})

if lang == "python":
    print("import pytest")
    print("")
    print("")
    print("@pytest.fixture")
    print("def sample_{}():".format(ftype))
    print("    return {}".format(repr(data)))
    print("")
    print("")
    print("@pytest.fixture")
    print("def {}_factory():".format(ftype))
    print("    def _create(**overrides):")
    print("        defaults = {}".format(repr(data)))
    print("        defaults.update(overrides)")
    print("        return defaults")
    print("    return _create")
    print("")
    print("")
    print("# Usage in test:")
    print("# def test_something(sample_{}, {}_factory):".format(ftype, ftype))
    print("#     custom = {}_factory(name='Custom')".format(ftype))

elif lang == "javascript":
    import json
    print("// Test fixtures")
    print("const sample{} = {};".format(ftype.capitalize(), json.dumps(data, indent=2)))
    print("")
    print("function create{}(overrides = {{}}) {{".format(ftype.capitalize()))
    print("  return {{ ...sample{}, ...overrides }};".format(ftype.capitalize()))
    print("}")
    print("")
    print("module.exports = {{ sample{}, create{} }};".format(ftype.capitalize(), ftype.capitalize()))

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

coverage)
  LANG="${1:-python}"
  python3 << 'PYEOF'
import sys
lang = sys.argv[1] if len(sys.argv) > 1 else "python"

print("=" * 60)
print("  Coverage Configuration & Tips ({})".format(lang))
print("=" * 60)
print("")

if lang == "python":
    print("# --- pytest coverage setup ---")
    print("# pip install pytest-cov")
    print("")
    print("# Run with coverage:")
    print("# pytest --cov=myapp --cov-report=html --cov-report=term-missing")
    print("")
    print("# --- .coveragerc ---")
    print("[run]")
    print("source = myapp")
    print("omit =")
    print("    */tests/*")
    print("    */migrations/*")
    print("    */__pycache__/*")
    print("")
    print("[report]")
    print("fail_under = 80")
    print("show_missing = true")
    print("exclude_lines =")
    print("    pragma: no cover")
    print("    def __repr__")
    print("    if __name__ == .__main__.")

elif lang == "javascript":
    print("// --- jest.config.js coverage ---")
    print("module.exports = {")
    print("  collectCoverage: true,")
    print("  coverageDirectory: 'coverage',")
    print("  coverageThreshold: {")
    print("    global: {")
    print("      branches: 80,")
    print("      functions: 80,")
    print("      lines: 80,")
    print("      statements: 80,")
    print("    },")
    print("  },")
    print("  collectCoverageFrom: [")
    print("    'src/**/*.{js,ts}',")
    print("    '!src/**/*.test.{js,ts}',")
    print("    '!src/**/index.{js,ts}',")
    print("  ],")
    print("};")
    print("")
    print("// Run: npx jest --coverage")

print("")
print("Priority coverage targets:")
print("  1. Business logic / core algorithms")
print("  2. Error handling / edge cases")
print("  3. API endpoints / public interfaces")
print("  4. Data validation / transformation")
print("  5. Authentication / authorization")
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

edge)
  TYPE="${1:-number}"
  RANGE="${2:-0-100}"
  python3 << 'PYEOF'
import sys
etype = sys.argv[1] if len(sys.argv) > 1 else "number"
erange = sys.argv[2] if len(sys.argv) > 2 else "0-100"

print("=" * 60)
print("  Edge Cases: {} ({})".format(etype, erange))
print("=" * 60)
print("")

if etype == "number":
    parts = erange.split("-")
    lo = int(parts[0]) if len(parts) > 0 else 0
    hi = int(parts[1]) if len(parts) > 1 else 100
    cases = [
        (lo, "minimum value"),
        (hi, "maximum value"),
        (lo - 1, "below minimum"),
        (hi + 1, "above maximum"),
        (0, "zero"),
        (-1, "negative"),
        ((lo + hi) // 2, "midpoint"),
        (None, "null/None"),
        ("abc", "non-numeric string"),
        (float("inf"), "infinity"),
        (0.1 + 0.2, "floating point precision"),
    ]
elif etype == "string":
    cases = [
        ("", "empty string"),
        (" ", "whitespace only"),
        ("a", "single character"),
        ("a" * 1000, "very long string"),
        (None, "null/None"),
        (123, "non-string type"),
        ("Hello World", "with spaces"),
        ("<script>alert(1)</script>", "XSS attempt"),
        ("DROP TABLE users;--", "SQL injection"),
        ("unicode: \u00e4\u00f6\u00fc\u00df", "special characters"),
        ("line1\\nline2", "with newlines"),
    ]
elif etype == "array":
    cases = [
        ([], "empty array"),
        ([1], "single element"),
        (list(range(10000)), "very large array"),
        (None, "null/None"),
        ([None, None], "array of nulls"),
        ([1, "a", True], "mixed types"),
        ([[1], [2]], "nested arrays"),
        ([1, 1, 1], "all same values"),
    ]
else:
    cases = [
        (None, "null/None"),
        ("", "empty"),
        (0, "zero"),
        (-1, "negative"),
        (True, "boolean true"),
        (False, "boolean false"),
        ({}, "empty object"),
        ([], "empty array"),
    ]

print("Generated {} edge cases:".format(len(cases)))
print("")
for i, (val, desc) in enumerate(cases, 1):
    print("  {:>2}. Input: {:<30} # {}".format(i, repr(val), desc))

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

benchmark)
  LANG="${1:-python}"
  TARGET="${2:-sort_function}"
  python3 << 'PYEOF'
import sys
lang = sys.argv[1] if len(sys.argv) > 1 else "python"
target = sys.argv[2] if len(sys.argv) > 2 else "sort_function"

print("=" * 60)
print("  Benchmark Test: {}".format(target))
print("=" * 60)
print("")

if lang == "python":
    print("import time")
    print("import statistics")
    print("")
    print("")
    print("def benchmark(func, *args, iterations=1000, warmup=100):")
    print('    """Run benchmark with warmup and statistics"""')
    print("    # Warmup")
    print("    for _ in range(warmup):")
    print("        func(*args)")
    print("    # Measure")
    print("    times = []")
    print("    for _ in range(iterations):")
    print("        start = time.perf_counter()")
    print("        func(*args)")
    print("        times.append(time.perf_counter() - start)")
    print("    return {{")
    print("        'mean': statistics.mean(times),")
    print("        'median': statistics.median(times),")
    print("        'stdev': statistics.stdev(times),")
    print("        'min': min(times),")
    print("        'max': max(times),")
    print("        'iterations': iterations,")
    print("    }}")
    print("")
    print("")
    print("# Usage:")
    print("# result = benchmark({}, test_data)".format(target))
    print("# print('Mean: {:.6f}s'.format(result['mean']))")
    print("# print('Median: {:.6f}s'.format(result['median']))")

elif lang == "javascript":
    print("async function benchmark(fn, args = [], iterations = 1000) {")
    print("  // Warmup")
    print("  for (let i = 0; i < 100; i++) fn(...args);")
    print("")
    print("  const times = [];")
    print("  for (let i = 0; i < iterations; i++) {")
    print("    const start = performance.now();")
    print("    fn(...args);")
    print("    times.push(performance.now() - start);")
    print("  }")
    print("  times.sort((a, b) => a - b);")
    print("  const sum = times.reduce((a, b) => a + b, 0);")
    print("  return {")
    print("    mean: sum / times.length,")
    print("    median: times[Math.floor(times.length / 2)],")
    print("    min: times[0],")
    print("    max: times[times.length - 1],")
    print("    p95: times[Math.floor(times.length * 0.95)],")
    print("  };")
    print("}")

elif lang == "go":
    print("package main")
    print("")
    print('import "testing"')
    print("")
    print("func Benchmark{}(b *testing.B) {{".format(target.replace("_", " ").title().replace(" ", "")))
    print("    for i := 0; i < b.N; i++ {")
    print("        {}(testData)".format(target))
    print("    }")
    print("}")
    print("")
    print("// Run: go test -bench=. -benchmem -count=5")

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

*)
  echo "Test Generator - Automated Test Case Generation"
  echo ""
  echo "Usage: bash test-generator.sh <command> [args]"
  echo ""
  echo "Commands:"
  echo "  unit <lang> <function>     Generate unit test template"
  echo "  integration <lang> <mod>   Generate integration test"
  echo "  e2e <lang> <flow>          Generate E2E test flow"
  echo "  mock <lang> <target>       Generate mock objects"
  echo "  fixture <lang> <type>      Generate test fixtures"
  echo "  coverage <lang>            Coverage config & tips"
  echo "  edge <type> <range>        Generate edge cases"
  echo "  benchmark <lang> <target>  Generate benchmark test"
  echo ""
  echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
  ;;

esac

#!/usr/bin/env bash
# code-generator: Multi-language code generator
# Usage: bash codegen.sh <command> [description]

set -euo pipefail

COMMAND="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

# Export INPUT so Python can read it from env
export CODEGEN_INPUT="$INPUT"

case "$COMMAND" in
  function)
    python3 << 'PYEOF'
import os
inp = os.environ.get("CODEGEN_INPUT", "").strip()
if not inp:
    inp = "calculate fibonacci number"
desc = inp
print("=" * 60)
print("  FUNCTION GENERATOR")
print("=" * 60)
print()
print("Description: {}".format(desc))
print()
words = desc.lower().replace("-", "_").replace(" ", "_")
func_name = "_".join(words.split("_")[:4])
print("[Python] # {}.py".format(func_name))
print("-" * 40)
print('def {}(n):'.format(func_name))
print('    """')
print('    {}'.format(desc))
print('    ')
print('    Args:')
print('        n: Input parameter')
print('    ')
print('    Returns:')
print('        Result of computation')
print('    """')
print('    # TODO: Implement {} logic'.format(desc))
print('    if n <= 0:')
print('        return 0')
print('    if n == 1:')
print('        return 1')
print('    result = n  # placeholder')
print('    return result')
print()
print()
print("[JavaScript] // {}.js".format(func_name))
print("-" * 40)
print("/**")
print(" * {}".format(desc))
print(" * @param {{number}} n - Input parameter")
print(" * @returns {{number}} Result")
print(" */")
print("function {}(n) {{".format(func_name))
print("  // TODO: Implement {} logic".format(desc))
print("  if (n <= 0) return 0;")
print("  if (n === 1) return 1;")
print("  const result = n; // placeholder")
print("  return result;")
print("}}")
print()
print("Usage: {}(10)".format(func_name))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  class)
    python3 << 'PYEOF'
import os
inp = os.environ.get("CODEGEN_INPUT", "").strip()
if not inp:
    inp = "User with name email and password"
desc = inp
print("=" * 60)
print("  CLASS GENERATOR")
print("=" * 60)
print()
words = desc.split()
class_name = words[0].capitalize() if words else "MyClass"
print("[Python] # {}.py".format(class_name.lower()))
print("-" * 40)
print("class {}:".format(class_name))
print('    """{}"""'.format(desc))
print()
print("    def __init__(self, name, value=None):")
print("        self.name = name")
print("        self.value = value")
print("        self._created = True")
print()
print("    def __repr__(self):")
print('        return "{}(name={{}})".format(self.name)'.format(class_name))
print()
print("    def validate(self):")
print('        """Validate the {} data"""'.format(class_name.lower()))
print("        if not self.name:")
print('            raise ValueError("name is required")')
print("        return True")
print()
print("    def to_dict(self):")
print('        """Convert to dictionary"""')
print('        return {{"name": self.name, "value": self.value}}')
print()
print("    @classmethod")
print("    def from_dict(cls, data):")
print('        """Create from dictionary"""')
print('        return cls(name=data.get("name"), value=data.get("value"))')
print()
print()
print("[TypeScript] // {}.ts".format(class_name.lower()))
print("-" * 40)
print("export class {} {{".format(class_name))
print("  name: string;")
print("  value: any;")
print()
print("  constructor(name: string, value?: any) {{")
print("    this.name = name;")
print("    this.value = value;")
print("  }}")
print()
print("  validate(): boolean {{")
print("    if (!this.name) throw new Error('name required');")
print("    return true;")
print("  }}")
print()
print("  toJSON(): object {{")
print("    return {{ name: this.name, value: this.value }};")
print("  }}")
print("}}")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  api)
    python3 << 'PYEOF'
import os
inp = os.environ.get("CODEGEN_INPUT", "").strip()
if not inp:
    inp = "users"
resource = inp.lower().replace(" ", "_")
print("=" * 60)
print("  API ENDPOINT GENERATOR")
print("=" * 60)
print()
print("Resource: {}".format(resource))
print()
print("[Python Flask]")
print("-" * 40)
endpoints = [
    ("GET", "/api/{}".format(resource), "list", "List all {}".format(resource)),
    ("GET", "/api/{}/<id>".format(resource), "get", "Get single {}".format(resource)),
    ("POST", "/api/{}".format(resource), "create", "Create new {}".format(resource)),
    ("PUT", "/api/{}/<id>".format(resource), "update", "Update {}".format(resource)),
    ("DELETE", "/api/{}/<id>".format(resource), "delete", "Delete {}".format(resource)),
]
for method, path, action, desc in endpoints:
    print()
    print("# {} {}".format(method, desc))
    print('@app.route("{}", methods=["{}"])'.format(path, method))
    print("def {}_{}({}):".format(action, resource, "id" if "<id>" in path else ""))
    if method == "GET" and "<id>" not in path:
        print("    items = db.query({}.capitalize()).all()".format(resource))
        print("    return jsonify(items), 200")
    elif method == "GET":
        print("    item = db.query({}.capitalize()).get(id)".format(resource))
        print("    if not item:")
        print("        return jsonify({{'error': 'not found'}}), 404")
        print("    return jsonify(item), 200")
    elif method == "POST":
        print("    data = request.get_json()")
        print("    # validate data")
        print("    item = create_{}(data)".format(resource))
        print("    return jsonify(item), 201")
    elif method == "PUT":
        print("    data = request.get_json()")
        print("    item = update_{}(id, data)".format(resource))
        print("    return jsonify(item), 200")
    elif method == "DELETE":
        print("    delete_{}(id)".format(resource))
        print("    return '', 204")
print()
print()
print("[Express.js]")
print("-" * 40)
print("router.get('/api/{}', async (req, res) => {{".format(resource))
print("  const items = await {}.find();".format(resource.capitalize()))
print("  res.json(items);")
print("}});")
print()
print("router.post('/api/{}', async (req, res) => {{".format(resource))
print("  const item = await {}.create(req.body);".format(resource.capitalize()))
print("  res.status(201).json(item);")
print("}});")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  crud)
    python3 << 'PYEOF'
import os
inp = os.environ.get("CODEGEN_INPUT", "").strip()
if not inp:
    inp = "Product"
model = inp.split()[0].capitalize()
print("=" * 60)
print("  CRUD OPERATIONS: {}".format(model))
print("=" * 60)
print()
print("[Python SQLAlchemy]")
print("-" * 40)
print()
print("# Model")
print("class {}(db.Model):".format(model))
print("    id = db.Column(db.Integer, primary_key=True)")
print("    name = db.Column(db.String(100), nullable=False)")
print("    created_at = db.Column(db.DateTime, default=datetime.utcnow)")
print()
print("# CREATE")
print("def create_{}(data):".format(model.lower()))
print("    item = {}(name=data['name'])".format(model))
print("    db.session.add(item)")
print("    db.session.commit()")
print("    return item")
print()
print("# READ")
print("def get_{}(id):".format(model.lower()))
print("    return {}.query.get_or_404(id)".format(model))
print()
print("def list_{}s(page=1, per_page=20):".format(model.lower()))
print("    return {}.query.paginate(page=page, per_page=per_page)".format(model))
print()
print("# UPDATE")
print("def update_{}(id, data):".format(model.lower()))
print("    item = {}.query.get_or_404(id)".format(model))
print("    item.name = data.get('name', item.name)")
print("    db.session.commit()")
print("    return item")
print()
print("# DELETE")
print("def delete_{}(id):".format(model.lower()))
print("    item = {}.query.get_or_404(id)".format(model))
print("    db.session.delete(item)")
print("    db.session.commit()")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  test)
    python3 << 'PYEOF'
import os
inp = os.environ.get("CODEGEN_INPUT", "").strip()
if not inp:
    inp = "calculator add subtract multiply divide"
desc = inp
print("=" * 60)
print("  TEST CODE GENERATOR")
print("=" * 60)
print()
words = desc.split()
module = words[0].lower() if words else "module"
print("[Python pytest] # test_{}.py".format(module))
print("-" * 40)
print("import pytest")
print("# from {} import *".format(module))
print()
print()
print("class Test{}:".format(module.capitalize()))
print()
print("    def setup_method(self):")
print('        """Set up test fixtures"""')
print("        self.instance = None  # Initialize test subject")
print()
print("    def test_basic_functionality(self):")
print('        """Test basic {} operation"""'.format(module))
print("        result = True  # Replace with actual test")
print("        assert result is True")
print()
print("    def test_edge_case_empty(self):")
print('        """Test with empty input"""')
print("        result = None")
print("        assert result is None")
print()
print("    def test_edge_case_invalid(self):")
print('        """Test with invalid input"""')
print("        with pytest.raises(Exception):")
print("            pass  # Call with invalid args")
print()
print("    def test_expected_output(self):")
print('        """Test expected return value"""')
print("        expected = 42")
print("        actual = 42  # Replace with function call")
print("        assert actual == expected")
print()
print()
print("[JavaScript Jest] // {}.test.js".format(module))
print("-" * 40)
print("describe('{}', () => {{".format(module.capitalize()))
print("  test('basic functionality', () => {{")
print("    expect(true).toBe(true);")
print("  }});")
print()
print("  test('handles edge cases', () => {{")
print("    expect(() => {{ throw new Error('test'); }}).toThrow();")
print("  }});")
print("}});")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  refactor)
    python3 << 'PYEOF'
import os
inp = os.environ.get("CODEGEN_INPUT", "").strip()
if not inp:
    inp = "messy code with nested loops"
print("=" * 60)
print("  REFACTORING SUGGESTIONS")
print("=" * 60)
print()
print("Input: {}".format(inp))
print()
suggestions = [
    ("Extract Method", "Break large functions into smaller, focused ones. Each function should do one thing well."),
    ("Remove Duplication", "Identify repeated code patterns. Extract into shared utilities or base classes."),
    ("Simplify Conditionals", "Replace nested if/else with guard clauses, early returns, or strategy pattern."),
    ("Use Meaningful Names", "Rename variables from 'x', 'tmp', 'data' to descriptive names that explain intent."),
    ("Reduce Parameters", "Functions with 3+ params: group into config objects or use builder pattern."),
    ("Add Type Hints", "Add type annotations for better IDE support and fewer runtime errors."),
    ("Error Handling", "Replace bare except with specific exceptions. Add proper error messages."),
    ("Performance", "Consider list comprehensions, generators, caching for hot paths.")
]
for i, (title, desc) in enumerate(suggestions, 1):
    print("{}. [{}]".format(i, title))
    print("   {}".format(desc))
    print()
print("Priority: Start with #1-#3 for maximum impact.")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  convert)
    python3 << 'PYEOF'
import os
inp = os.environ.get("CODEGEN_INPUT", "").strip()
if not inp:
    inp = "python to javascript: def hello(name): return 'Hello ' + name"
print("=" * 60)
print("  LANGUAGE CONVERTER")
print("=" * 60)
print()
print("Input: {}".format(inp[:200]))
print()
print("Conversion Guide:")
print("-" * 40)
print()
mappings = [
    ("Python -> JavaScript", [
        ("def func(x):", "function func(x) {"),
        ("print(x)", "console.log(x)"),
        ("list/dict", "Array/Object"),
        ("None", "null"),
        ("True/False", "true/false"),
    ]),
    ("Python -> Go", [
        ("def func(x):", "func funcName(x Type) ReturnType {"),
        ("print(x)", "fmt.Println(x)"),
        ("list", "[]Type (slice)"),
        ("dict", "map[KeyType]ValueType"),
    ]),
    ("Python -> Java", [
        ("def func(x):", "public ReturnType func(Type x) {"),
        ("print(x)", "System.out.println(x)"),
        ("list", "List<Type>"),
        ("dict", "Map<K,V>"),
    ]),
]
for lang_pair, rules in mappings:
    print("[{}]".format(lang_pair))
    for py, target in rules:
        print("  {} => {}".format(py, target))
    print()
print("Note: Provide specific code for accurate conversion.")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  boilerplate)
    python3 << 'PYEOF'
import os
inp = os.environ.get("CODEGEN_INPUT", "").strip()
if not inp:
    inp = "web api"
project = inp.lower()
print("=" * 60)
print("  PROJECT BOILERPLATE: {}".format(project.upper()))
print("=" * 60)
print()
print("[Python Flask API]")
print("-" * 40)
print("project/")
print("  app/")
print("    __init__.py")
print("    models/")
print("      __init__.py")
print("      user.py")
print("    routes/")
print("      __init__.py")
print("      api.py")
print("    services/")
print("      __init__.py")
print("    utils/")
print("      __init__.py")
print("  tests/")
print("    test_api.py")
print("    conftest.py")
print("  config.py")
print("  requirements.txt")
print("  Dockerfile")
print("  docker-compose.yml")
print("  README.md")
print("  .env.example")
print("  .gitignore")
print()
print("[Node.js Express API]")
print("-" * 40)
print("project/")
print("  src/")
print("    controllers/")
print("    middleware/")
print("    models/")
print("    routes/")
print("    services/")
print("    utils/")
print("    app.js")
print("    server.js")
print("  tests/")
print("  package.json")
print("  Dockerfile")
print("  .env.example")
print("  README.md")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  help|*)
    cat << 'HELPEOF'
========================================
  Code Generator - Multi-Language
========================================

Commands:
  function     Generate functions
  class        Generate classes
  api          API endpoints (REST)
  crud         CRUD operations
  test         Test code (pytest/Jest)
  refactor     Refactoring suggestions
  convert      Language conversion guide
  boilerplate  Project scaffolding

Usage:
  bash codegen.sh <command> <description>

Languages: Python, JS, TS, Go, Java, Rust, PHP, Ruby, C#

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
    ;;
esac

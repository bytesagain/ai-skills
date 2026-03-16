#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# License: MIT — independent, not derived from any third-party source
# Contact book — manage personal contacts
set -euo pipefail
CONTACT_DIR="${CONTACT_DIR:-$HOME/.contacts}"
mkdir -p "$CONTACT_DIR"
DB="$CONTACT_DIR/contacts.json"
[ ! -f "$DB" ] && echo '[]' > "$DB"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Contact Book — manage personal contacts
Commands:
  add <name> <phone> [email]  Add contact
  list [n]                    List contacts (default all)
  search <query>              Search contacts
  view <name>                 View contact details
  edit <name> <field> <val>   Edit contact field
  group <name> <group>        Add to group
  groups                      List groups
  birthday <name> <date>      Set birthday
  birthdays                   Upcoming birthdays
  delete <name>               Delete contact
  export [format]             Export (csv/vcf/json)
  stats                       Contact statistics
  info                        Version info
Powered by BytesAgain | bytesagain.com";;
add)
    name="${1:-}"; phone="${2:-}"; email="${3:-}"
    [ -z "$name" ] || [ -z "$phone" ] && { echo "Usage: add <name> <phone> [email]"; exit 1; }
    python3 << PYEOF
import json, time
with open("$DB") as f: contacts = json.load(f)
contacts.append({"name":"$name","phone":"$phone","email":"$email",
                 "groups":[],"birthday":"","notes":"",
                 "added":time.strftime("%Y-%m-%d")})
with open("$DB","w") as f: json.dump(contacts, f, indent=2, ensure_ascii=False)
print("👤 Added: $name ($phone)")
PYEOF
;;
list)
    n="${1:-999}"
    python3 << PYEOF
import json
with open("$DB") as f: contacts = json.load(f)
contacts.sort(key=lambda x: x["name"])
print("📇 Contacts ({} total):".format(len(contacts)))
for c in contacts[:int("$n")]:
    groups = " ".join(["["+g+"]" for g in c.get("groups",[]) if g])
    print("  👤 {:20s} {:15s} {:20s} {}".format(c["name"][:20], c.get("phone","")[:15], c.get("email","")[:20], groups))
PYEOF
;;
search)
    q="${1:-}"; [ -z "$q" ] && { echo "Usage: search <query>"; exit 1; }
    python3 -c "
import json
with open('$DB') as f: contacts = json.load(f)
q = '$q'.lower()
found = [c for c in contacts if q in c['name'].lower() or q in c.get('phone','') or q in c.get('email','').lower()]
print('🔍 Found {}:'.format(len(found)))
for c in found:
    print('  👤 {} {} {}'.format(c['name'], c.get('phone',''), c.get('email','')))
";;
view)
    name="${1:-}"; [ -z "$name" ] && { echo "Usage: view <name>"; exit 1; }
    python3 -c "
import json
with open('$DB') as f: contacts = json.load(f)
for c in contacts:
    if c['name'] == '$name':
        print('👤 {}'.format(c['name']))
        print('   📱 {}'.format(c.get('phone','-')))
        print('   📧 {}'.format(c.get('email','-')))
        if c.get('birthday'): print('   🎂 {}'.format(c['birthday']))
        if c.get('groups'): print('   🏷 {}'.format(', '.join(c['groups'])))
        if c.get('notes'): print('   📝 {}'.format(c['notes']))
        break
else: print('Not found: $name')
";;
edit)
    name="${1:-}"; field="${2:-}"; val="${3:-}"
    [ -z "$name" ] && { echo "Usage: edit <name> <field> <value>"; exit 1; }
    python3 -c "
import json
with open('$DB') as f: contacts = json.load(f)
for c in contacts:
    if c['name'] == '$name':
        c['$field'] = '$val'
        print('✏️ Updated {} {} → {}'.format('$name', '$field', '$val'))
        break
with open('$DB','w') as f: json.dump(contacts, f, indent=2, ensure_ascii=False)
";;
group)
    name="${1:-}"; group="${2:-}"
    [ -z "$name" ] && { echo "Usage: group <name> <group>"; exit 1; }
    python3 -c "
import json
with open('$DB') as f: contacts = json.load(f)
for c in contacts:
    if c['name'] == '$name':
        if '$group' not in c.get('groups',[]): c.setdefault('groups',[]).append('$group')
        print('🏷 {} added to group: $group'.format('$name'))
        break
with open('$DB','w') as f: json.dump(contacts, f, indent=2, ensure_ascii=False)
";;
groups)
    python3 -c "
import json
from collections import Counter
with open('$DB') as f: contacts = json.load(f)
groups = Counter(g for c in contacts for g in c.get('groups',[]) if g)
print('🏷 Groups:')
for g, n in groups.most_common():
    print('  {} ({} contacts)'.format(g, n))
";;
birthday)
    name="${1:-}"; date="${2:-}"
    [ -z "$name" ] && { echo "Usage: birthday <name> <YYYY-MM-DD>"; exit 1; }
    python3 -c "
import json
with open('$DB') as f: contacts = json.load(f)
for c in contacts:
    if c['name'] == '$name':
        c['birthday'] = '$date'
        print('🎂 Birthday set: $name → $date')
        break
with open('$DB','w') as f: json.dump(contacts, f, indent=2, ensure_ascii=False)
";;
birthdays)
    python3 << PYEOF
import json, time
with open("$DB") as f: contacts = json.load(f)
today = time.strftime("%m-%d")
upcoming = []
for c in contacts:
    if c.get("birthday"):
        bd_md = c["birthday"][5:]
        if bd_md >= today:
            upcoming.append((bd_md, c["name"], c["birthday"]))
upcoming.sort()
print("🎂 Upcoming Birthdays:")
for md, name, full in upcoming[:10]:
    print("  {} — {}".format(full, name))
if not upcoming: print("  (none set — use 'birthday' command)")
PYEOF
;;
delete)
    name="${1:-}"; [ -z "$name" ] && { echo "Usage: delete <name>"; exit 1; }
    python3 -c "
import json
with open('$DB') as f: contacts = json.load(f)
new = [c for c in contacts if c['name'] != '$name']
with open('$DB','w') as f: json.dump(new, f, indent=2, ensure_ascii=False)
print('🗑 Deleted: $name ({} removed)'.format(len(contacts)-len(new)))
";;
export)
    fmt="${1:-csv}"
    python3 -c "
import json
with open('$DB') as f: contacts = json.load(f)
if '$fmt'=='csv':
    print('name,phone,email,birthday,groups')
    for c in contacts:
        print('{},{},{},{},{}'.format(c['name'],c.get('phone',''),c.get('email',''),c.get('birthday',''),';'.join(c.get('groups',[]))))
elif '$fmt'=='vcf':
    for c in contacts:
        print('BEGIN:VCARD')
        print('VERSION:3.0')
        print('FN:{}'.format(c['name']))
        if c.get('phone'): print('TEL:{}'.format(c['phone']))
        if c.get('email'): print('EMAIL:{}'.format(c['email']))
        if c.get('birthday'): print('BDAY:{}'.format(c['birthday']))
        print('END:VCARD')
else: print(json.dumps(contacts, indent=2, ensure_ascii=False))
";;
stats)
    python3 -c "
import json
from collections import Counter
with open('$DB') as f: contacts = json.load(f)
print('📊 Contact Stats:')
print('  Total: {}'.format(len(contacts)))
with_email = len([c for c in contacts if c.get('email')])
with_bday = len([c for c in contacts if c.get('birthday')])
groups = len(set(g for c in contacts for g in c.get('groups',[]) if g))
print('  With email: {}'.format(with_email))
print('  With birthday: {}'.format(with_bday))
print('  Groups: {}'.format(groups))
";;
info) echo "Contact Book v1.0.0"; echo "Manage personal contacts"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac

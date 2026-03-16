#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# License: MIT — independent, not derived from any third-party source
# Reading log — track books, progress, and reading habits
set -euo pipefail
READ_DIR="${READ_DIR:-$HOME/.reading}"
mkdir -p "$READ_DIR"
DB="$READ_DIR/books.json"
[ ! -f "$DB" ] && echo '[]' > "$DB"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Reading Log — track books & reading habits
Commands:
  add <title> [author]    Add book to reading list
  start <title>           Start reading a book
  progress <title> <pct>  Update progress (0-100%)
  finish <title> [rating] Mark book finished (1-5 stars)
  list [filter]           List books (all/reading/done/todo)
  search <query>          Search books
  stats                   Reading statistics
  streak                  Reading streak
  recommend [genre]       Book recommendations
  shelf                   Visual bookshelf
  export [format]         Export (md/csv/json)
  info                    Version info
Powered by BytesAgain | bytesagain.com";;
add)
    title="${1:-}"; author="${2:-Unknown}"
    [ -z "$title" ] && { echo "Usage: add <title> [author]"; exit 1; }
    python3 << PYEOF
import json, time
with open("$DB") as f: books = json.load(f)
books.append({"title":"$title","author":"$author","status":"todo","progress":0,
              "rating":0,"added":time.strftime("%Y-%m-%d"),"started":"","finished":"","notes":""})
with open("$DB","w") as f: json.dump(books, f, indent=2, ensure_ascii=False)
print("📚 Added: $title by $author")
PYEOF
;;
start)
    title="${1:-}"; [ -z "$title" ] && { echo "Usage: start <title>"; exit 1; }
    python3 -c "
import json, time
with open('$DB') as f: books = json.load(f)
for b in books:
    if b['title'] == '$title':
        b['status'] = 'reading'
        b['started'] = time.strftime('%Y-%m-%d')
        print('📖 Started: $title')
        break
with open('$DB','w') as f: json.dump(books, f, indent=2, ensure_ascii=False)
";;
progress)
    title="${1:-}"; pct="${2:-0}"
    [ -z "$title" ] && { echo "Usage: progress <title> <percent>"; exit 1; }
    python3 -c "
import json
with open('$DB') as f: books = json.load(f)
for b in books:
    if b['title'] == '$title':
        b['progress'] = int('$pct')
        bar = '█' * (int('$pct')//10) + '░' * (10-int('$pct')//10)
        print('📖 {} [{}] {}%'.format(b['title'], bar, '$pct'))
        break
with open('$DB','w') as f: json.dump(books, f, indent=2, ensure_ascii=False)
";;
finish)
    title="${1:-}"; rating="${2:-0}"
    [ -z "$title" ] && { echo "Usage: finish <title> [rating]"; exit 1; }
    python3 -c "
import json, time
with open('$DB') as f: books = json.load(f)
for b in books:
    if b['title'] == '$title':
        b['status'] = 'done'
        b['progress'] = 100
        b['finished'] = time.strftime('%Y-%m-%d')
        b['rating'] = int('$rating')
        stars = '⭐' * int('$rating')
        print('✅ Finished: {} {}'.format(b['title'], stars))
        break
with open('$DB','w') as f: json.dump(books, f, indent=2, ensure_ascii=False)
";;
list)
    filt="${1:-all}"
    python3 << PYEOF
import json
with open("$DB") as f: books = json.load(f)
if "$filt" != "all": books = [b for b in books if b["status"] == "$filt"]
icons = {"todo":"📋","reading":"📖","done":"✅"}
print("📚 Books ({}):".format("$filt"))
for b in books:
    icon = icons.get(b["status"], "📄")
    stars = "⭐" * b.get("rating", 0) if b.get("rating") else ""
    bar = ""
    if b["status"] == "reading":
        bar = " [{}%]".format(b.get("progress",0))
    print("  {} {:30s} {:15s} {}{}".format(icon, b["title"][:30], b["author"][:15], stars, bar))
print("  Total: {} books".format(len(books)))
PYEOF
;;
search)
    q="${1:-}"; [ -z "$q" ] && { echo "Usage: search <query>"; exit 1; }
    python3 -c "
import json
with open('$DB') as f: books = json.load(f)
found = [b for b in books if '$q'.lower() in b['title'].lower() or '$q'.lower() in b['author'].lower()]
print('🔍 Found {}:'.format(len(found)))
for b in found: print('  {} by {} [{}]'.format(b['title'], b['author'], b['status']))
";;
stats)
    python3 << PYEOF
import json
with open("$DB") as f: books = json.load(f)
total = len(books)
done = [b for b in books if b["status"] == "done"]
reading = [b for b in books if b["status"] == "reading"]
todo = [b for b in books if b["status"] == "todo"]
rated = [b for b in done if b.get("rating", 0) > 0]
avg_rating = sum(b["rating"] for b in rated) / len(rated) if rated else 0
print("📊 Reading Stats:")
print("  Total books: {}".format(total))
print("  Reading: {}  Done: {}  To-read: {}".format(len(reading), len(done), len(todo)))
print("  Avg rating: {:.1f}/5 ({} rated)".format(avg_rating, len(rated)))
from collections import Counter
authors = Counter(b["author"] for b in books)
if authors:
    fav = authors.most_common(1)[0]
    print("  Favorite author: {} ({} books)".format(fav[0], fav[1]))
PYEOF
;;
streak)
    python3 -c "
import json
with open('$DB') as f: books = json.load(f)
reading = len([b for b in books if b['status'] == 'reading'])
done = len([b for b in books if b['status'] == 'done'])
print('📖 Reading streak:')
print('   Currently reading: {} books'.format(reading))
print('   Completed: {} books'.format(done))
print('   ' + '📚' * min(done, 15))
";;
recommend)
    genre="${1:-fiction}"
    python3 -c "
import random
recs = {
    'fiction': ['1984 by George Orwell','Dune by Frank Herbert','The Alchemist by Paulo Coelho','Sapiens by Yuval Noah Harari'],
    'tech': ['Clean Code by Robert Martin','The Pragmatic Programmer by Hunt & Thomas','Designing Data-Intensive Applications by Martin Kleppmann'],
    'business': ['Zero to One by Peter Thiel','The Lean Startup by Eric Ries','Atomic Habits by James Clear'],
    'self-help': ['Thinking, Fast and Slow by Daniel Kahneman','The 7 Habits by Stephen Covey','Deep Work by Cal Newport'],
}
books = recs.get('$genre', recs['fiction'])
print('📚 Recommended ({}):'.format('$genre'))
for b in random.sample(books, min(3,len(books))): print('  📖 ' + b)
";;
shelf)
    python3 -c "
import json
with open('$DB') as f: books = json.load(f)
print('📚 Bookshelf:')
print('  ┌' + '─'*40 + '┐')
for b in books[:10]:
    icon = '✅' if b['status']=='done' else ('📖' if b['status']=='reading' else '📋')
    print('  │ {} {:37s}│'.format(icon, b['title'][:37]))
print('  └' + '─'*40 + '┘')
print('  {} books total'.format(len(books)))
";;
export)
    fmt="${1:-md}"
    python3 -c "
import json
with open('$DB') as f: books = json.load(f)
if '$fmt'=='md':
    print('# Reading List\n')
    for b in books:
        check = 'x' if b['status']=='done' else ' '
        stars = ' ⭐'*b.get('rating',0) if b.get('rating') else ''
        print('- [{}] {} by {}{}'.format(check, b['title'], b['author'], stars))
elif '$fmt'=='csv':
    print('title,author,status,progress,rating')
    for b in books: print('{},{},{},{},{}'.format(b['title'],b['author'],b['status'],b.get('progress',0),b.get('rating',0)))
else: print(json.dumps(books, indent=2, ensure_ascii=False))
";;
info) echo "Reading Log v1.0.0"; echo "Track books and reading habits"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac

#!/usr/bin/env bash
# web-scraper-pro — Web scraping toolkit
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
#
# Extract text, links, images from web pages with CSS-like selector support.
# Output as JSON, CSV, or Markdown. Uses Python3 urllib + html.parser only.

set -euo pipefail

VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Defaults ───
FORMAT="json"
TIMEOUT=10
USER_AGENT="WebScraperPro/${VERSION} (bytesagain.com)"
FOLLOW_REDIRECTS="true"
MAX_DEPTH=1
OUTPUT_FILE=""
QUIET="false"

# ─── Usage ───
usage() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  web-scraper-pro — Web Scraping Toolkit                      ║
║  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com║
╚══════════════════════════════════════════════════════════════╝

USAGE:
    bash scripts/main.sh <command> <url> [options]

COMMANDS:
    text <url>              Extract all visible text content
    links <url>             Extract all hyperlinks with anchor text
    images <url>            Extract all image URLs with alt text
    select <url> <selector> Extract elements matching CSS-like selector
    full <url>              Full extraction (text + links + images)
    headers <url>           Show HTTP response headers

OPTIONS:
    --format json|csv|md    Output format (default: json)
    --timeout <seconds>     Request timeout (default: 10)
    --user-agent <string>   Custom User-Agent header
    --output <file>         Save output to file
    --quiet                 Suppress progress messages
    --version               Show version
    --help                  Show this help

EXAMPLES:
    bash scripts/main.sh links https://example.com --format json
    bash scripts/main.sh images https://example.com --format csv
    bash scripts/main.sh select https://example.com .article --format md
    bash scripts/main.sh full https://example.com --output result.json
EOF
}

# ─── Logging ───
log() {
    if [[ "${QUIET}" != "true" ]]; then
        echo "[web-scraper-pro] $*" >&2
    fi
}

error() {
    echo "[ERROR] $*" >&2
    exit 1
}

# ─── Argument Parsing ───
COMMAND=""
URL=""
SELECTOR=""
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --format)
            FORMAT="${2:-json}"
            shift 2
            ;;
        --timeout)
            TIMEOUT="${2:-10}"
            shift 2
            ;;
        --user-agent)
            USER_AGENT="${2:-}"
            shift 2
            ;;
        --output)
            OUTPUT_FILE="${2:-}"
            shift 2
            ;;
        --quiet)
            QUIET="true"
            shift
            ;;
        --follow-redirects)
            FOLLOW_REDIRECTS="true"
            shift
            ;;
        --max-depth)
            MAX_DEPTH="${2:-1}"
            shift 2
            ;;
        --version)
            echo "web-scraper-pro v${VERSION}"
            echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
            exit 0
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        -*)
            error "Unknown option: $1"
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

# Parse positional args
if [[ ${#POSITIONAL_ARGS[@]} -lt 1 ]]; then
    usage
    exit 1
fi

COMMAND="${POSITIONAL_ARGS[0]}"
URL="${POSITIONAL_ARGS[1]:-}"
SELECTOR="${POSITIONAL_ARGS[2]:-}"

# Validate command
case "${COMMAND}" in
    text|links|images|full|headers) 
        [[ -z "${URL}" ]] && error "URL is required for '${COMMAND}' command"
        ;;
    select)
        [[ -z "${URL}" ]] && error "URL is required for 'select' command"
        [[ -z "${SELECTOR}" ]] && error "CSS selector is required for 'select' command"
        ;;
    *)
        error "Unknown command: ${COMMAND}. Use --help for usage."
        ;;
esac

# ─── Main Python Script ───
run_scraper() {
    python3 << 'PYEOF'
import sys
import json
import csv
import io
import ssl
import socket
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError
from urllib.parse import urljoin, urlparse
from html.parser import HTMLParser
from datetime import datetime

# Read environment variables for configuration
import os
command = os.environ.get('SCRAPER_COMMAND', 'text')
url = os.environ.get('SCRAPER_URL', '')
selector = os.environ.get('SCRAPER_SELECTOR', '')
output_format = os.environ.get('SCRAPER_FORMAT', 'json')
timeout = int(os.environ.get('SCRAPER_TIMEOUT', '10'))
user_agent = os.environ.get('SCRAPER_USER_AGENT', 'WebScraperPro/1.0.0')
output_file = os.environ.get('SCRAPER_OUTPUT', '')

# ─── HTML Parser Classes ───

class TextExtractor(HTMLParser):
    """Extract visible text from HTML."""
    def __init__(self):
        super().__init__()
        self.text_parts = []
        self.skip_tags = {'script', 'style', 'noscript', 'head', 'meta', 'link'}
        self.current_tag = None
        self.skip_depth = 0

    def handle_starttag(self, tag, attrs):
        self.current_tag = tag
        if tag in self.skip_tags:
            self.skip_depth += 1

    def handle_endtag(self, tag):
        if tag in self.skip_tags and self.skip_depth > 0:
            self.skip_depth -= 1
        if tag in ('p', 'div', 'br', 'li', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'tr', 'blockquote'):
            self.text_parts.append('\n')

    def handle_data(self, data):
        if self.skip_depth == 0:
            text = data.strip()
            if text:
                self.text_parts.append(text)

    def get_text(self):
        return ' '.join(self.text_parts).strip()


class LinkExtractor(HTMLParser):
    """Extract all links with anchor text."""
    def __init__(self, base_url):
        super().__init__()
        self.base_url = base_url
        self.links = []
        self.current_link = None
        self.current_text = []

    def handle_starttag(self, tag, attrs):
        if tag == 'a':
            attrs_dict = dict(attrs)
            href = attrs_dict.get('href', '')
            if href:
                full_url = urljoin(self.base_url, href)
                self.current_link = {
                    'tag': 'a',
                    'href': full_url,
                    'rel': attrs_dict.get('rel', ''),
                    'title': attrs_dict.get('title', ''),
                    'text': ''
                }
                self.current_text = []

    def handle_data(self, data):
        if self.current_link is not None:
            self.current_text.append(data.strip())

    def handle_endtag(self, tag):
        if tag == 'a' and self.current_link is not None:
            self.current_link['text'] = ' '.join(self.current_text).strip()
            self.links.append(self.current_link)
            self.current_link = None
            self.current_text = []


class ImageExtractor(HTMLParser):
    """Extract all images with metadata."""
    def __init__(self, base_url):
        super().__init__()
        self.base_url = base_url
        self.images = []

    def handle_starttag(self, tag, attrs):
        if tag == 'img':
            attrs_dict = dict(attrs)
            src = attrs_dict.get('src', '')
            if src:
                self.images.append({
                    'tag': 'img',
                    'src': urljoin(self.base_url, src),
                    'alt': attrs_dict.get('alt', ''),
                    'title': attrs_dict.get('title', ''),
                    'width': attrs_dict.get('width', ''),
                    'height': attrs_dict.get('height', ''),
                    'loading': attrs_dict.get('loading', '')
                })


class SelectorExtractor(HTMLParser):
    """Extract elements matching a CSS-like selector (tag, .class, #id)."""
    def __init__(self, selector):
        super().__init__()
        self.results = []
        self.selector_type = 'tag'
        self.selector_value = selector
        self.capturing = False
        self.capture_depth = 0
        self.current_text = []
        self.current_attrs = {}

        if selector.startswith('.'):
            self.selector_type = 'class'
            self.selector_value = selector[1:]
        elif selector.startswith('#'):
            self.selector_type = 'id'
            self.selector_value = selector[1:]

    def _matches(self, tag, attrs):
        attrs_dict = dict(attrs)
        if self.selector_type == 'tag':
            return tag == self.selector_value
        elif self.selector_type == 'class':
            classes = attrs_dict.get('class', '').split()
            return self.selector_value in classes
        elif self.selector_type == 'id':
            return attrs_dict.get('id', '') == self.selector_value
        return False

    def handle_starttag(self, tag, attrs):
        if self.capturing:
            self.capture_depth += 1
        elif self._matches(tag, attrs):
            self.capturing = True
            self.capture_depth = 1
            self.current_text = []
            self.current_attrs = dict(attrs)

    def handle_data(self, data):
        if self.capturing:
            text = data.strip()
            if text:
                self.current_text.append(text)

    def handle_endtag(self, tag):
        if self.capturing:
            self.capture_depth -= 1
            if self.capture_depth <= 0:
                self.results.append({
                    'tag': tag,
                    'text': ' '.join(self.current_text),
                    'attributes': self.current_attrs
                })
                self.capturing = False
                self.current_text = []
                self.current_attrs = {}


class FullExtractor(HTMLParser):
    """Extract text, links, and images all at once."""
    def __init__(self, base_url):
        super().__init__()
        self.base_url = base_url
        self.text_parts = []
        self.links = []
        self.images = []
        self.skip_tags = {'script', 'style', 'noscript'}
        self.skip_depth = 0
        self.current_link = None
        self.link_text = []
        self.meta = {}
        self.in_title = False
        self.title_text = []

    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)
        if tag in self.skip_tags:
            self.skip_depth += 1
        if tag == 'title':
            self.in_title = True
            self.title_text = []
        if tag == 'meta':
            name = attrs_dict.get('name', attrs_dict.get('property', ''))
            content = attrs_dict.get('content', '')
            if name and content:
                self.meta[name] = content
        if tag == 'a':
            href = attrs_dict.get('href', '')
            if href:
                self.current_link = {'tag': 'a', 'href': urljoin(self.base_url, href), 'text': ''}
                self.link_text = []
        if tag == 'img':
            src = attrs_dict.get('src', '')
            if src:
                self.images.append({
                    'tag': 'img',
                    'src': urljoin(self.base_url, src),
                    'alt': attrs_dict.get('alt', '')
                })

    def handle_data(self, data):
        if self.in_title:
            self.title_text.append(data.strip())
        if self.skip_depth == 0:
            text = data.strip()
            if text:
                self.text_parts.append(text)
        if self.current_link is not None:
            self.link_text.append(data.strip())

    def handle_endtag(self, tag):
        if tag in self.skip_tags and self.skip_depth > 0:
            self.skip_depth -= 1
        if tag == 'title':
            self.in_title = False
            self.meta['title'] = ' '.join(self.title_text)
        if tag == 'a' and self.current_link is not None:
            self.current_link['text'] = ' '.join(self.link_text)
            self.links.append(self.current_link)
            self.current_link = None


# ─── Fetch URL ───
def fetch_url(target_url):
    """Fetch URL content with error handling."""
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE

    req = Request(target_url, headers={'User-Agent': user_agent})
    try:
        response = urlopen(req, timeout=timeout, context=ctx)
        charset = response.headers.get_content_charset() or 'utf-8'
        html_content = response.read().decode(charset, errors='replace')
        headers_dict = dict(response.headers)
        return html_content, headers_dict, response.status
    except HTTPError as e:
        print(json.dumps({'error': f'HTTP {e.code}: {e.reason}', 'url': target_url}), file=sys.stderr)
        sys.exit(1)
    except URLError as e:
        print(json.dumps({'error': str(e.reason), 'url': target_url}), file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(json.dumps({'error': str(e), 'url': target_url}), file=sys.stderr)
        sys.exit(1)


# ─── Output Formatters ───
def format_output(data, fmt, data_key='data'):
    """Format data as JSON, CSV, or Markdown."""
    if fmt == 'json':
        return json.dumps(data, indent=2, ensure_ascii=False)
    elif fmt == 'csv':
        items = data.get(data_key, [])
        if not items:
            return ''
        output = io.StringIO()
        if isinstance(items, list) and len(items) > 0:
            if isinstance(items[0], dict):
                fieldnames = list(items[0].keys())
                writer = csv.DictWriter(output, fieldnames=fieldnames)
                writer.writeheader()
                for item in items:
                    clean_item = {}
                    for k, v in item.items():
                        if isinstance(v, dict):
                            clean_item[k] = json.dumps(v)
                        else:
                            clean_item[k] = str(v)
                    writer.writerow(clean_item)
            else:
                writer = csv.writer(output)
                for item in items:
                    writer.writerow([item])
        return output.getvalue()
    elif fmt == 'md':
        items = data.get(data_key, [])
        if not items:
            return '_No data found._'
        if isinstance(items, list) and len(items) > 0 and isinstance(items[0], dict):
            headers = list(items[0].keys())
            lines = ['| ' + ' | '.join(headers) + ' |']
            lines.append('| ' + ' | '.join(['---'] * len(headers)) + ' |')
            for item in items:
                row = []
                for h in headers:
                    val = item.get(h, '')
                    if isinstance(val, dict):
                        val = json.dumps(val)
                    row.append(str(val).replace('|', '\\|').replace('\n', ' ')[:80])
                lines.append('| ' + ' | '.join(row) + ' |')
            return '\n'.join(lines)
        elif isinstance(items, str):
            return items
        return str(items)
    return json.dumps(data, indent=2, ensure_ascii=False)


def write_output(content):
    """Write output to file or stdout."""
    if output_file:
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'Output saved to: {output_file}', file=sys.stderr)
    else:
        print(content)


# ─── Command Handlers ───

def cmd_text():
    html, _, _ = fetch_url(url)
    extractor = TextExtractor()
    extractor.feed(html)
    text = extractor.get_text()
    data = {
        'url': url,
        'timestamp': datetime.now().isoformat(),
        'command': 'text',
        'data': text
    }
    if output_format == 'json':
        write_output(json.dumps(data, indent=2, ensure_ascii=False))
    elif output_format == 'csv':
        write_output(f'url,text\n"{url}","{text[:1000]}"')
    else:
        write_output(f'# Text from {url}\n\n{text}')


def cmd_links():
    html, _, _ = fetch_url(url)
    extractor = LinkExtractor(url)
    extractor.feed(html)
    data = {
        'url': url,
        'timestamp': datetime.now().isoformat(),
        'command': 'links',
        'count': len(extractor.links),
        'data': extractor.links
    }
    write_output(format_output(data, output_format))


def cmd_images():
    html, _, _ = fetch_url(url)
    extractor = ImageExtractor(url)
    extractor.feed(html)
    data = {
        'url': url,
        'timestamp': datetime.now().isoformat(),
        'command': 'images',
        'count': len(extractor.images),
        'data': extractor.images
    }
    write_output(format_output(data, output_format))


def cmd_select():
    html, _, _ = fetch_url(url)
    extractor = SelectorExtractor(selector)
    extractor.feed(html)
    data = {
        'url': url,
        'timestamp': datetime.now().isoformat(),
        'command': 'select',
        'selector': selector,
        'count': len(extractor.results),
        'data': extractor.results
    }
    write_output(format_output(data, output_format))


def cmd_full():
    html, _, status = fetch_url(url)
    extractor = FullExtractor(url)
    extractor.feed(html)
    data = {
        'url': url,
        'timestamp': datetime.now().isoformat(),
        'command': 'full',
        'status_code': status,
        'meta': extractor.meta,
        'text_length': len(' '.join(extractor.text_parts)),
        'links_count': len(extractor.links),
        'images_count': len(extractor.images),
        'text': ' '.join(extractor.text_parts)[:5000],
        'links': extractor.links,
        'images': extractor.images
    }
    write_output(format_output(data, output_format, 'links'))


def cmd_headers():
    _, headers, status = fetch_url(url)
    data = {
        'url': url,
        'timestamp': datetime.now().isoformat(),
        'command': 'headers',
        'status_code': status,
        'headers': headers
    }
    if output_format == 'json':
        write_output(json.dumps(data, indent=2, ensure_ascii=False))
    elif output_format == 'md':
        lines = [f'# HTTP Headers for {url}\n', f'**Status:** {status}\n']
        lines.append('| Header | Value |')
        lines.append('|--------|-------|')
        for k, v in headers.items():
            lines.append(f'| {k} | {v} |')
        write_output('\n'.join(lines))
    else:
        lines = ['header,value']
        for k, v in headers.items():
            lines.append(f'"{k}","{v}"')
        write_output('\n'.join(lines))


# ─── Main ───
commands = {
    'text': cmd_text,
    'links': cmd_links,
    'images': cmd_images,
    'select': cmd_select,
    'full': cmd_full,
    'headers': cmd_headers
}

if command in commands:
    commands[command]()
else:
    print(f'Unknown command: {command}', file=sys.stderr)
    sys.exit(1)
PYEOF
}

# ─── Execute ───
export SCRAPER_COMMAND="${COMMAND}"
export SCRAPER_URL="${URL}"
export SCRAPER_SELECTOR="${SELECTOR}"
export SCRAPER_FORMAT="${FORMAT}"
export SCRAPER_TIMEOUT="${TIMEOUT}"
export SCRAPER_USER_AGENT="${USER_AGENT}"
export SCRAPER_OUTPUT="${OUTPUT_FILE}"

log "Running '${COMMAND}' on ${URL} (format: ${FORMAT})"
run_scraper
log "Done."

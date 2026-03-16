# File Converter Tips

1. **Round-trip test** — Pipe `json2yaml` into `yaml2json` to verify lossless conversion
2. **Batch convert** — `for f in *.json; do bash convert.sh json2yaml "$f" > "${f%.json}.yaml"; done`
3. **Detect first** — Always run `detect` on unknown files before converting to avoid garbled output
4. **Minify for production** — `minify` on JSON configs can cut size by 30-60%
5. **Prettify for debugging** — Got a minified JSON/JS blob? Run `prettify` first, read second
6. **Watch for encoding** — CSV files must be UTF-8. Convert encoding before running `csv2md`
7. **XML namespaces** — `xml2json` preserves namespace prefixes as keys — handle them in your code

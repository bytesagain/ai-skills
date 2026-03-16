# 💡 Doc Converter Tips

1. **Pipe files directly**: `cat file.md | bash convert.sh md2html` processes file content without copy-pasting.

2. **Validate JSON before csv conversion**: Make sure your JSON is an array `[{}, {}]` — objects need to be wrapped first.

3. **Clean as a first pass**: Messy text? Run `clean` first, then do your actual conversion — much better results.

4. **Table auto-detects delimiters**: Commas, tabs, pipes `|`, and semicolons are all recognized automatically.

5. **YAML is indentation-sensitive**: Keep consistent spacing in your YAML input — mixed tabs and spaces will break parsing.

6. **HTML to MD preserves structure**: Heading levels and list nesting are maintained during conversion.

7. **Chain conversions**: Run `yaml2json` then `json2csv` to go from YAML to CSV in two steps.

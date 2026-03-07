# pystr - Agent Tool Description

`pystr` transforms text via stdin using Python expressions. Use it instead of writing throwaway Python scripts, awk, sed, or perl one-liners for text processing.

## WHEN TO USE
- Transforming, reformatting, or extracting fields from text output (instead of awk/sed/cut/perl)
- Filtering lines matching a condition (instead of grep with complex patterns)
- Applying Python string methods, regex, or math to each line of output
- Processing entire stdin as one string (joining lines, counting, global replacements)
- When the transformation is easy to describe but hard to write: use `-p` to describe in English and let Claude generate the code

## WHEN NOT TO USE
- Binary file processing or large-scale data pipelines -- use Python scripts or dedicated tools
- JSON/YAML/XML parsing with nested structure -- use `jq`, `yq`, or a Python script
- Tasks requiring imports beyond `math` and `re` -- write a Python script instead

## FLAGS (can be combined)
- **(default):** `STDIN | pystr 'expr'` -- evaluates expr per line; `s`=line, `i`=line number
- **`-a`:** `s`=entire stdin as one string instead of current line
- **`-g`:** print original lines where expr is truthy (instead of printing result)
- **`-p`:** expression is natural language; Claude generates the Python code
- **`-n`:** suppress auto-print for side-effect expressions
- **`--show`:** show generated code (with `-p`); **`--model`:** haiku (default), sonnet, opus
- Run `pystr --help` for full option details and output format specifications.

## EXAMPLES
```
echo "hello world" | pystr 's.upper()'
cat data.csv | pystr 's.split(",")[2]'
seq 10 | pystr -g 'int(s) % 2 == 0'
cat file.txt | pystr -a 'len(s.splitlines())'
echo "john,doe,30" | pystr -p "get the second comma-separated field"
```

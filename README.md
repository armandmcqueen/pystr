# pystr

A CLI for transforming text with Python expressions. If you know Python, you already know pystr. Or let an LLM write the Python for you.

```bash
echo "Hello World" | pystr 's.lower().replace(" ", "-")'
hello-world

echo "5550123456" | pystr --prompt "format as US phone number: 000-000-0000"
555-012-3456

cat first10primes.txt | pystr --grep "float(s) <= 5"
2
3
5

# Combine grep and prompt to filter invalid UUIDs
cat uuids.txt | pystr -g -p "invalid uuids"
```

## Installation

Requires [uv](https://docs.astral.sh/uv/getting-started/installation/).

```bash
curl -fsSL https://raw.githubusercontent.com/armandmcqueen/pystr/main/install-remote.sh | bash
```

## How It Works

pystr reads from stdin and evaluates your Python expression for each line.

| Variable | Description |
|----------|-------------|
| `s` | The current line (string) |
| `i` | Line number (0-indexed) |
| `math` | The `math` module |
| `re` | The `re` module for regex |

All Python builtins (`len`, `int`, `str`, `sum`, `sorted`, etc.) are available. The result of your expression is printed automatically.

## Examples

**Reverse each line:**
```bash
cat file.txt | pystr 's[::-1]'
```

**Number lines:**
```bash
cat file.txt | pystr 'f"{i}: {s}"'
```

**Filter lines (grep mode):**
```bash
seq 10 | pystr -g 'int(s) % 2 == 0'
2
4
6
8
10
```

**Process entire input at once:**
```bash
cat file.txt | pystr -a 'len(s.splitlines())'  # count lines
cat file.txt | pystr -a '",".join(s.splitlines())'  # join lines with commas
```

## Natural Language Mode

Don't want to write the expression yourself? Describe what you want in plain English:

```bash
echo "5550123456" | pystr -p "format as US phone number: 000-000-0000"
555-012-3456

echo "john,doe,30" | pystr -p "get the second field, it's comma-separated"
doe

seq 10 | pystr -g -p "even numbers"
2
4
6
8
10
```

Use `--show` to see the generated code:

```bash
echo "5550123456" | pystr -p --show "format as US phone number: 000-000-0000"
Generated code: s[:3] + '-' + s[3:6] + '-' + s[6:]
555-012-3456
```

Requires `ANTHROPIC_API_KEY` environment variable. Uses Claude Haiku by default (`--model sonnet` or `--model opus` for alternatives). Haiku is fast but you might need to provide clearer instructions. Sonnet tends to be pretty good if you don't want to think.

## All Options

```
pystr [OPTIONS] EXPRESSION

Options:
  -a, --all       Read all input at once (s = entire input)
  -g, --grep      Filter mode: print lines where expression is truthy
  -n, --no-print  Don't auto-print (for expressions with side effects)
  -p, --prompt    Interpret expression as natural language
  --show          Show generated code (with -p)
  --confirm       Ask before executing generated code (with -p)
  --model MODEL   haiku (default), sonnet, or opus (with -p)
  --dry-run       Show the LLM prompt without executing (with -p)
  -v, --version   Show version
```

## License

Apache 2.0

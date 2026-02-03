# pystr

A CLI for transforming text with Python expressions. If you know Python, you already know pystr. 

```bash
echo "Hello World" | pystr 's.lower().replace(" ", "-")'
hello-world
```

Or let Claude write the Python for you.
```bash
echo "5550123456" | pystr --prompt "format as US phone number: 000-000-0000"
555-012-3456
```

Grep mode
```bash
cat first10primes.txt | pystr --grep "float(s) <= 5"
2
3
5
```

Combine grep and prompt. For example to filter invalid UUIDs
```bash
cat uuids.txt | pystr -g -p "invalid uuids"
```

## Installation

pystr is a single ~250 line [Python script](https://github.com/armandmcqueen/pystr/blob/main/pystr). Copy [it](https://raw.githubusercontent.com/armandmcqueen/pystr/refs/heads/main/pystr) or install it from github:

```bash
curl -fsSL https://raw.githubusercontent.com/armandmcqueen/pystr/main/install-remote.sh | bash
```

Requires [uv](https://docs.astral.sh/uv/getting-started/installation/).

## LLM

For prompt mode (`-p`), set your `ANTHROPIC_API_KEY` environment variable.

## Usage

pystr reads from stdin and evaluates your Python expression for each line. The result is printed automatically.

| Variable | Description |
|----------|-------------|
| `s` | The current line (string) |
| `i` | Line number (0-indexed) |
| `math` | The `math` module |
| `re` | The `re` module for regex |

All Python builtins (`len`, `int`, `str`, `sum`, `sorted`, etc.) are available.

### Basic: transform each line

```bash
echo "hello world" | pystr 's.upper()'
HELLO WORLD

seq 5 | pystr 'int(s) ** 2'
1
4
9
16
25

cat file.txt | pystr 'f"{i}: {s}"'  # number lines
```

### Grep mode (`-g`): filter lines

Print lines where the expression is truthy.

```bash
seq 10 | pystr -g 'int(s) % 2 == 0'
2
4
6
8
10

cat log.txt | pystr -g '"ERROR" in s'  # find error lines
```

### All mode (`-a`): process entire input at once

Instead of line-by-line, `s` becomes the entire input.

```bash
cat file.txt | pystr -a 'len(s.splitlines())'  # count lines
cat file.txt | pystr -a '",".join(s.splitlines())'  # join lines
```

### Prompt mode (`-p`): let Claude write the Python

Don't want to write the expression? Describe what you want in plain English.

```bash
echo "5550123456" | pystr -p "format as US phone number"
555-012-3456

echo "john,doe,30" | pystr -p "get the second comma-separated field"
doe
```

Use `--show` to see the generated code:

```bash
echo "hello world" | pystr -p --show "reverse each word"
Generated code: ' '.join(word[::-1] for word in s.split())
olleh dlrow
```

Uses Claude Haiku by default (`--model sonnet` or `--model opus` for smarter models). Haiku is fast, but you may need to be descriptive. Sonnet is good if you don't want to think.

### Combining flags

Flags can be combined. For example, grep + prompt:

```bash
cat uuids.txt | pystr -g -p "invalid uuids"
not-a-uuid
hello world
```

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

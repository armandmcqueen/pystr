# CLAUDE.md

## Project Overview

**pystr** is a command-line utility for transforming text using Python expressions. It reads from stdin, evaluates Python code on each line (or entire input), and prints results. It also supports an AI-powered prompt mode (`-p`) where users describe transformations in plain English and Claude generates the Python code.

## Architecture

This is a single-file project. The entire application is the `pystr` script (≈270 lines) in the repo root. It uses a `uv` shebang (`#!/usr/bin/env -S uv run --script`) with inline dependency metadata, so it runs as a standalone script with no install step beyond having `uv` available.

### Key files

```
pystr              # Main executable script (the entire application)
tests/
  test_pystr.py    # All tests (subprocess-based integration tests)
  uuids.txt        # Test fixture data
pyproject.toml     # Project metadata and dependencies
install.sh         # User-facing install script (copies pystr to ~/.local/bin)
```

## Development Commands

### Run tests
```bash
uv run --with pytest pytest tests/ -v
```

### Run the tool locally
```bash
echo "hello world" | ./pystr 's.upper()'
```

## Dependencies

- **Runtime:** `anthropic` (only imported when `-p` prompt mode is used)
- **Dev:** `pytest`
- **Python:** >= 3.10
- **Tool:** `uv` (Astral's Python package manager, used as script runner)

## Code Conventions

- Single-file design — all application code lives in `./pystr`
- Type hints on function signatures
- Standard 4-space Python indentation
- No linter/formatter config enforced — write clean, PEP 8-style code
- Error messages go to stderr; results go to stdout
- Lazy imports for `anthropic` (only in `generate_code()`) to keep non-prompt-mode fast

## Testing Approach

- Tests are **subprocess-based integration tests** — they invoke `./pystr` as a subprocess and check stdout/stderr/return code
- Helper function `run_pystr(expression, input_text, *args)` wraps subprocess calls
- Tests are organized into classes by feature area: `TestBasicTransformations`, `TestLineByLine`, `TestAllMode`, `TestFlags`, `TestEdgeCases`, `TestGrepMode`, `TestPromptMode`
- Prompt mode tests mock/skip API calls (test flag parsing and error messages, not actual API responses)

## CI

GitHub Actions (`.github/workflows/test.yml`): runs `uv run --with pytest pytest tests/ -v` on push/PR to main.

## Key Application Concepts

- **Line mode (default):** Expression evaluated per line. `s` = current line, `i` = 0-indexed line number
- **All mode (`-a`):** `s` = entire stdin input as one string
- **Grep mode (`-g`):** Print lines where expression is truthy
- **Prompt mode (`-p`):** Natural language → Claude generates Python expression
- **No-print mode (`-n`):** Suppress auto-print (for expressions with side effects like `print()`)
- Available in expressions: `s`, `i`, `math`, `re`, all Python builtins

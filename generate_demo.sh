#!/bin/bash
# Generates demo.md showing pystr examples

demo() {
    local description="$1"
    local cmd="$2"
    local input="$3"

    echo "### $description"
    echo
    echo '```bash'
    echo "$cmd"
    echo '```'
    echo
    echo "**Input:**"
    echo '```'
    echo "$input"
    echo '```'
    echo
    echo "**Output:**"
    echo '```'
    eval "$cmd" <<< "$input"
    echo '```'
    echo
}

cat << 'EOF'
# pystr Demo

Examples of using `pystr` for command-line string manipulation.

## Basic String Operations

EOF

demo "Uppercase" \
    "echo 'hello world' | ./pystr 's.upper()'" \
    "hello world"

demo "Reverse" \
    "echo 'hello' | ./pystr 's[::-1]'" \
    "hello"

demo "Length" \
    "echo 'hello world' | ./pystr 'len(s)'" \
    "hello world"

demo "Replace" \
    "echo 'hello world' | ./pystr 's.replace(\"world\", \"there\")'" \
    "hello world"

demo "Title Case" \
    "echo 'hello world' | ./pystr 's.title()'" \
    "hello world"

cat << 'EOF'
## Line-by-Line Processing

EOF

demo "Transform each line" \
    "printf 'one\ntwo\nthree' | ./pystr 's.upper()'" \
    "one
two
three"

demo "Number lines" \
    "printf 'apple\nbanana\ncherry' | ./pystr 'f\"{i}: {s}\"'" \
    "apple
banana
cherry"

demo "Square numbers" \
    "seq 5 | ./pystr 'int(s) ** 2'" \
    "1
2
3
4
5"

demo "Filter even numbers" \
    "seq 10 | ./pystr 'int(s) if int(s) % 2 == 0 else None' -q" \
    "1
2
3
4
5
6
7
8
9
10"

cat << 'EOF'
## Field Extraction

EOF

demo "First field" \
    "echo 'john doe 30' | ./pystr 'f[0]'" \
    "john doe 30"

demo "Last field" \
    "echo 'john doe 30' | ./pystr 'f[-1]'" \
    "john doe 30"

demo "Format with fields" \
    "echo 'john doe 30 engineer' | ./pystr 'f\"{f[0]} is a {f[3]}\"'" \
    "john doe 30 engineer"

demo "CSV field" \
    "echo 'alice,bob,charlie' | ./pystr 's.split(\",\")[1]'" \
    "alice,bob,charlie"

cat << 'EOF'
## All-Input Mode (-a)

EOF

demo "Join lines" \
    "printf 'one\ntwo\nthree' | ./pystr -a 's.replace(\"\\n\", \" \")'" \
    "one
two
three"

demo "Count lines" \
    "printf 'a\nb\nc\nd\ne' | ./pystr -a 'len(s.splitlines())'" \
    "a
b
c
d
e"

demo "Sort lines" \
    "printf 'cherry\napple\nbanana' | ./pystr -a '\"\\n\".join(sorted(s.splitlines()))'" \
    "cherry
apple
banana"

cat << 'EOF'
## Grep Mode (-g)

Filter lines where the expression is truthy.

EOF

demo "Filter even numbers" \
    "seq 10 | ./pystr -g 'int(s) % 2 == 0'" \
    "1
2
3
4
5
6
7
8
9
10"

demo "Lines containing 'error'" \
    "printf 'info: ok\nerror: failed\ninfo: done\nerror: timeout' | ./pystr -g '\"error\" in s'" \
    "info: ok
error: failed
info: done
error: timeout"

demo "Lines longer than 5 characters" \
    "printf 'hi\nhello\nworld\nhello world' | ./pystr -g 'len(s) > 5'" \
    "hi
hello
world
hello world"

cat << 'EOF'
## Natural Language Mode (-p)

Use Claude to generate Python expressions from natural language descriptions.
Requires ANTHROPIC_API_KEY environment variable.

EOF

demo "Uppercase (natural language)" \
    "echo 'hello world' | ./pystr -p 'make it uppercase'" \
    "hello world"

demo "Get second field (natural language)" \
    "echo 'john,doe,30' | ./pystr -p 'get the second field (comma-separated)'" \
    "john,doe,30"

demo "Filter even numbers (natural language)" \
    "seq 10 | ./pystr -p -q 'only keep even numbers'" \
    "1
2
3
4
5
6
7
8
9
10"

demo "Reverse string (natural language)" \
    "echo 'hello' | ./pystr -p 'reverse it'" \
    "hello"

cat << 'EOF'
### With --show flag

Show the generated Python code before executing:

EOF

demo "Show generated code" \
    "echo 'hello' | ./pystr -p --show 'make it uppercase'" \
    "hello"

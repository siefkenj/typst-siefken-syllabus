#!/usr/bin/env bash
# Test runner: compiles every test/*.typ file. A test passes if it compiles
# without errors (tests use `assert`/`panic` to fail).
#
# Usage: ./test/run.sh [filter]
#   filter  substring of a test filename; only matching tests are run.
set -u
cd "$(dirname "$0")/.."

shopt -s nullglob

fail=0
pass=0
filter="${1:-}"

for f in test/*.typ; do
    name="$(basename "$f")"
    if [[ -n "$filter" && "$name" != *"$filter"* ]]; then
        continue
    fi
    if out="$(typst compile --root . -f pdf "$f" /dev/null 2>&1)"; then
        pass=$((pass + 1))
        echo "PASS $name"
    else
        fail=$((fail + 1))
        echo "FAIL $name"
        echo "$out" | sed 's/^/     /'
    fi
done

echo "----"
echo "$pass passed, $fail failed"

if [[ $pass -eq 0 && $fail -eq 0 ]]; then
    echo "No tests matched${filter:+ filter '$filter'}." >&2
    exit 1
fi

[[ $fail -eq 0 ]]

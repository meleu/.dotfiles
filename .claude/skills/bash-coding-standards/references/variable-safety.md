# Variable & Data Safety

Quoting, conditionals, arrays, and command substitution — the everyday
correctness rules.

## Quote everything

Always quote expansions to prevent word splitting and globbing.

```bash
# Wrong - unsafe
cp $source $dest

# Correct - safe
cp "$source" "$dest"
```

In the rare case you *must* leave an expansion unquoted (intentional word
splitting), document why and silence the linter locally:

```bash
# NOTE: ${MAVEN_CLI_OPTS} must stay unquoted to split into separate args
# shellcheck disable=2086
mvn -U ${MAVEN_CLI_OPTS}
```

## Conditionals

Use `[[ ]]` for tests.

```bash
# Good - safer
if [[ -f "$file" && -r "$file" ]]; then
    content=$(<"$file")
fi

# Bad - portable
if [ -f "$file" ] && [ -r "$file" ]; then
    content=$(cat "$file")
fi

# Test for unset/empty safely under `set -u`
if [[ -z "${VAR:-}" ]]; then
    printf 'VAR is not set or is empty\n'
fi
```

## Arrays

Use arrays for lists; always expand with `"${arr[@]}"`.

```bash
declare -a items=("item 1" "item 2" "item 3")

for item in "${items[@]}"; do
    printf 'Processing: %s\n' "$item"
done

# Read command output into an array safely
mapfile -t lines < <(some_command)
readarray -t numbers < <(seq 1 10)
```

## Command substitution

Use `$()` (never backticks), and check for failure where it matters.

```bash
name=$(<"$file")              # Read file into variable
output=$(command -v python3)  # Locate a command

result=$(command -v node) || {
    log_error "node command not found"
    return 1
}

# Line-oriented capture
mapfile -t lines < <(grep "pattern" "$file")

# NUL-safe iteration over filenames
while IFS= read -r -d '' file; do
    printf 'Processing: %s\n' "$file"
done < <(find /path -type f -print0)
```

## Pipes create subshells

A pipeline runs each stage in a subshell, so variables assigned inside `cmd |
while ...` are lost. Feed the loop with process substitution instead.

```bash
# Bad - count is always 0 (the while runs in a subshell)
count=0
grep "pattern" file.txt | while IFS= read -r line; do
    count=$((count + 1))
done
printf '%s\n' "$count"   # 0

# Good - no subshell, count survives
count=0
while IFS= read -r line; do
    count=$((count + 1))
done < <(grep "pattern" file.txt)
printf '%s\n' "$count"   # correct
```

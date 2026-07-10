# File Operations

Safe, non-destructive file handling: guarded moves/removes, atomic writes, and
temp files.

## Temporary files

Create temp files/dirs with `mktemp` and remove them via an EXIT trap (see
`error-handling.md`).

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

trap 'rm -rf -- "$TMPDIR"' EXIT

TMPDIR=$(mktemp -d)

TMPFILE1="$TMPDIR/temp1.txt"
TMPFILE2="$TMPDIR/temp2.txt"
touch "$TMPFILE1" "$TMPFILE2"

# Named temp file inside the dir; always use a 6-X suffix for portability
tmpfile=$(mktemp "${TMPDIR%/}/tmpfile.XXXXXX")
```

Never hardcode temp paths (`/tmp/myfile`) — they race and clobber. Always use
`mktemp`, and give templates at least six trailing `X`s.

## Guarded move and remove

```bash
# Move without clobbering an existing destination
safe_move() {
    local -r source="$1"
    local -r dest="$2"

    if [[ ! -e "$source" ]]; then
        printf 'ERROR: Source does not exist: %s\n' "$source" >&2
        return 1
    fi
    if [[ -e "$dest" ]]; then
        printf 'ERROR: Destination already exists: %s\n' "$dest" >&2
        return 1
    fi
    mv "$source" "$dest"
}

# Remove a directory with a confirmation prompt
safe_rmdir() {
    local -r dir="$1"

    if [[ ! -d "$dir" ]]; then
        printf 'ERROR: Not a directory: %s\n' "$dir" >&2
        return 1
    fi
    rm -rI -- "$dir"   # -I prompts once for recursive removal (BSD/GNU compatible)
}
```

## Atomic writes

Write to a temp file, then rename — readers never see a partial file.

```bash
atomic_write() {
    local -r target="$1"
    local tmpfile
    tmpfile=$(mktemp "${TMPDIR%/}/tmpfile.XXXXXX")

    cat > "$tmpfile"        # write to temp file first
    mv "$tmpfile" "$target" # atomic rename
}
```

## Iterating over files — never parse `ls`

`ls` output breaks on whitespace and special characters. Use a glob, or `find`
with a NUL delimiter.

```bash
# Bad - word-splits on spaces, mangles special chars
for f in $(ls *.txt); do process "$f"; done

# Good - glob (guard against the no-match case)
for f in *.txt; do
    [[ -e "$f" ]] || continue
    process "$f"
done

# Good - find with NUL delimiter (recursion, filters)
while IFS= read -r -d '' file; do
    process "$file"
done < <(find . -name '*.txt' -print0)
```

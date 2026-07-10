# Function Design

Conventions for readable, reusable, self-defending functions.

## Conventions

- **Naming prefixes** signal intent: `handle_*`, `process_*`, `check_*`,
  `validate_*`, `ensure_*`, `log_*`, `safe_*`.
- **Declare locals** with `local`; use `local -r` for read-only parameters.
- **Validate inputs** at the top and `return 1` (not `exit`) on failure so
  callers stay in control.
- **Send errors to stderr** (`>&2`).
- **Return meaningful status codes**; reserve stdout for real output.

## Function template

```bash
validate_file() {
    local -r file="$1"
    local -r message="${2:-File not found: $file}"

    if [[ ! -f "$file" ]]; then
        printf 'ERROR: %s\n' "$message" >&2
        return 1
    fi
    return 0
}

process_files() {
    local -r input_dir="$1"
    local -r output_dir="$2"

    # Validate inputs
    [[ -d "$input_dir" ]] || { printf 'ERROR: input_dir not a directory\n' >&2; return 1; }

    # Create output directory if needed
    mkdir -p "$output_dir"

    # Process files safely (NUL-delimited)
    while IFS= read -r -d '' file; do
        printf 'Processing: %s\n' "$file"
        # Do work
    done < <(find "$input_dir" -maxdepth 1 -type f -print0)

    return 0
}
```

## The `main` function pattern

For any non-trivial script, put logic in functions and drive them from a `main`
function called last with `"$@"`. This keeps top-level scope clean and makes the
entry point obvious.

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

main() {
    # argument parsing
    # input validation...
    # ... main logic ...
}

# other functions here...

main "$@"
```

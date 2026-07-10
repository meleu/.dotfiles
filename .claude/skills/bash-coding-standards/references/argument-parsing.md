# Argument Parsing

Robust CLI flag parsing, a usage/help function, and a named-parameter pattern
for functions.

## Script-level argument parsing

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

# Default values
VERBOSE=false
DRY_RUN=false
OUTPUT_FILE=""
THREADS=4

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Options:
    -v, --verbose       Enable verbose output
    -d, --dry-run       Run without making changes
    -o, --output FILE   Output file path
    -j, --jobs NUM      Number of parallel jobs
    -h, --help          Show this help message
EOF
    exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--verbose)  VERBOSE=true; shift ;;
        -d|--dry-run)  DRY_RUN=true; shift ;;
        -o|--output)   OUTPUT_FILE="$2"; shift 2 ;;
        -j|--jobs)     THREADS="$2"; shift 2 ;;
        -h|--help)     usage 0 ;;
        --)            shift; break ;;
        *)             printf 'ERROR: Unknown option: %s\n' "$1" >&2; usage 1 ;;
    esac
done

# Validate required arguments
[[ -n "$OUTPUT_FILE" ]] || { printf 'ERROR: -o/--output is required\n' >&2; usage 1; }
```

**Conventions:**

- Provide both short and long forms; support `--` to end option parsing.
- Always ship a `usage()` and a `-h/--help`.
- Validate required arguments *after* parsing and call `usage 1` on error.

## Named parameters for functions

For functions with many optional inputs, accept `--key=value` arguments.

```bash
process_data() {
    local input_file=""
    local output_dir=""
    local format="json"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --input=*)   input_file="${1#*=}" ;;
            --output=*)  output_dir="${1#*=}" ;;
            --format=*)  format="${1#*=}" ;;
            *)           printf 'ERROR: Unknown parameter: %s\n' "$1" >&2; return 1 ;;
        esac
        shift
    done

    [[ -n "$input_file" ]] || { printf 'ERROR: --input is required\n' >&2; return 1; }
    [[ -n "$output_dir" ]] || { printf 'ERROR: --output is required\n' >&2; return 1; }
}
```

## Positional arguments

For a small, fixed set of required positional arguments, validate them right at
capture with `${n:?message}` rather than a parsing loop.

```bash
readonly USAGE="Usage: $0 <source> <dest>"

main() {
    local src="${1:?$USAGE}"
    local dest="${2:?$USAGE}"
    local dest_dir
    dest_dir="$(dirname -- "$dest")"

    [[ -f "$src" ]]      || die "Source file not found: $src"
    [[ -d "$dest_dir" ]] || die "Dest directory does not exist: $dest_dir"
}
```

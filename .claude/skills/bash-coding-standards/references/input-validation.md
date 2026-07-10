# Input Validation

Validate everything a script consumes: file/directory existence and
permissions, required variables, and external command dependencies.

## Required variables

Fail fast with a clear message when a required variable is unset.

```bash
# Fail with a message if REQUIRED_VAR is unset or empty
: "${REQUIRED_VAR:?REQUIRED_VAR is not set}"
```

Related parameter-expansion forms:

```bash
name="${1:-anonymous}"                       # use default if unset/empty
config="${CONFIG_FILE:?CONFIG_FILE must be set}"  # abort with message if unset/empty
: "${LOG_LEVEL:=info}"                        # assign default in place if unset/empty
```

## Validate files and directories

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

# Inline directory check
[[ -d "$input_dir" ]] || { printf 'ERROR: not a directory: %s\n' "$input_dir" >&2; return 1; }
```

Test existence and permissions before operating.

## Dependency checking

Verify all external commands up front and report every missing one at once.

```bash
check_dependencies() {
    local -a missing_deps=()
    local -a required=("jq" "curl" "git")

    for cmd in "${required[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        printf 'ERROR: Missing required commands: %s\n' "${missing_deps[*]}" >&2
        return 1
    fi
}

check_dependencies
```

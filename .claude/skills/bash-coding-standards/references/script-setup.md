# Script Setup

Baseline every script starts from: strict mode, shebang, and reliable
self-location.

## Strict mode

Enable strict mode at the top of every script to catch errors early.

```bash
#!/usr/bin/env bash
set -Eeuo pipefail  # Exit on error, unset variables, pipe failures
```

**Key flags:**

- `set -E`: inherit the ERR trap in functions, subshells, and command substitutions
- `set -e`: exit on any command returning non-zero
- `set -u`: exit on reference to an undefined variable
- `set -o pipefail`: a pipeline fails if *any* stage fails, not just the last

### Living with strict mode

`set -e` aborts on the first non-zero exit. When a non-zero result is *expected*,
handle it explicitly instead of letting the script die:

```bash
# Bad - script dies if grep matches nothing
count=$(grep -c "pattern" file.txt)

# Good - tolerate the expected non-zero exit
count=$(grep -c "pattern" file.txt || true)
```

`set -u` aborts on any unset variable. Guard optional variables with a default:

```bash
printf '%s\n' "${OPTIONAL_VAR:-}"   # empty if unset, no abort
```

## Constants

Declare top-level constants `readonly` so a later reassignment aborts the script
under strict mode.

```bash
readonly VERSION="1.2.3"
readonly CONFIG_DIR="/etc/myapp"
readonly -a VALID_ENVS=(production staging development)
```

## Script directory and name detection

Resolve the script's own location robustly (handles symlinks and being called
from any working directory).

```bash
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
SCRIPT_NAME="$(basename -- "${BASH_SOURCE[0]}")"

printf 'Script location: %s/%s\n' "$SCRIPT_DIR" "$SCRIPT_NAME"
```

## Portability notes

- Prefer `printf` over `echo` — behavior of `echo` with flags/escapes varies
  across shells and platforms.
- Document required dependencies and the minimum Bash version (this standard
  assumes Bash 4+).

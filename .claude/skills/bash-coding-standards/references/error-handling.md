# Error Handling

Trap errors and exits, and always clean up resources — regardless of how the
script terminates.

## ERR and EXIT traps

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

trap 'printf "Error on line %s\n" "$LINENO" >&2' ERR
trap 'printf "Cleaning up...\n"; rm -rf -- "$TMPDIR"' EXIT

TMPDIR=$(mktemp -d)
# Script code here
```

- The ERR trap fires on any failing command (works well with `set -E` so it
  propagates into functions).
- The EXIT trap runs on *every* exit path — normal, error, or signal — making
  it the right place for cleanup.

For a more useful ERR trap, report the location and captured exit code:

```bash
on_error() {
    local exit_code=$?
    printf 'ERROR: %s:%s (exit code: %s)\n' \
        "${BASH_SOURCE[1]}" "${BASH_LINENO[0]}" "$exit_code" >&2
}
trap on_error ERR
```

## Signal traps

Handle interrupts explicitly; exit `130` is the convention for SIGINT.

```bash
trap 'printf "Interrupted\n" >&2; exit 130' INT TERM
```

See `process-orchestration.md` when signals must also tear down background jobs.

## Cleanup with temp resources

Create the trap before (or immediately after) creating the resource so an early
failure still triggers cleanup.

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

trap 'rm -rf -- "$TMPDIR"' EXIT

TMPDIR=$(mktemp -d) || { printf 'ERROR: Failed to create temp directory\n' >&2; exit 1; }
```

## Reporting errors

- Send all error and diagnostic output to stderr (`>&2`).
- Return non-zero from functions on failure; let `set -e` and traps propagate.
- Prefer explicit messages: `{ printf 'ERROR: ...\n' >&2; return 1; }`.

A `die()` helper keeps fatal-error handling terse and consistent:

```bash
die() {
    printf 'ERROR: %s\n' "$1" >&2
    exit "${2:-1}"
}

[[ -f "$src" ]] || die "Source file not found: $src"
```

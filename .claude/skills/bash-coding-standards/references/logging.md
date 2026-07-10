# Logging

Structured, leveled logging with timestamps. Log to stderr so stdout stays
reserved for real output/data.

```bash
log_info() {
    printf '[%s] INFO: %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >&2
}

log_warn() {
    printf '[%s] WARN: %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >&2
}

log_error() {
    printf '[%s] ERROR: %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >&2
}

log_debug() {
    if [[ "${DEBUG:-0}" == "1" ]]; then
        printf '[%s] DEBUG: %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >&2
    fi
}

# Usage
log_info "Starting script"
log_debug "Debug information"
log_warn "Warning message"
log_error "Error occurred"
```

**Conventions:**

- Everything goes to stderr (`>&2`), including info — stdout is for data and must be pipeable.
- Gate `log_debug` behind an environment flag (`DEBUG=1`) so it's opt-in.
- The timestamp prefix is optional.

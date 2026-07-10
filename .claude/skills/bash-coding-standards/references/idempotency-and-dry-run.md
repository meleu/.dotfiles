# Idempotency & Dry-Run

Scripts should be safe to rerun and able to preview destructive actions.

## Idempotent design

Check whether the desired state already exists before acting; re-running should
be a no-op, not an error.

```bash
ensure_directory() {
    local -r dir="$1"

    if [[ -d "$dir" ]]; then
        log_info "Directory already exists: $dir"
        return 0
    fi

    mkdir -p "$dir" || { log_error "Failed to create directory: $dir"; return 1; }
    log_info "Created directory: $dir"
}

ensure_config() {
    local -r config_file="$1"
    local -r default_value="$2"

    if [[ ! -f "$config_file" ]]; then
        printf '%s\n' "$default_value" > "$config_file"
        log_info "Created config: $config_file"
    fi
}

# Rerunning these is safe
ensure_directory "/var/cache/myapp"
ensure_config "/etc/myapp/config" "DEBUG=false"
```

## Dry-run support

Wrap side-effecting commands so users can preview them.

```bash
DRY_RUN="${DRY_RUN:-false}"

run_cmd() {
    if [[ "$DRY_RUN" == "true" ]]; then
        printf '[DRY RUN] Would execute: %s\n' "$*"
        return 0
    fi
    "$@"
}

# Usage
run_cmd cp "$source" "$dest"
run_cmd rm "$file"
run_cmd chown "$owner" "$target"
```

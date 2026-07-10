# Process Orchestration

Manage background jobs and shut them down cleanly on signals.

## Track and clean up background processes

```bash
# Track background process IDs
PIDS=()

cleanup() {
    log_info "Shutting down..."

    # Signal all background processes
    for pid in "${PIDS[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            kill -TERM "$pid" 2>/dev/null || true
        fi
    done

    # Wait for graceful shutdown
    for pid in "${PIDS[@]}"; do
        wait "$pid" 2>/dev/null || true
    done
}
trap cleanup SIGTERM SIGINT

# Start background tasks, recording each PID
background_task &
PIDS+=($!)

another_task &
PIDS+=($!)

# Wait for all background processes
wait
```

**Conventions:**

- Record every background PID (`PIDS+=($!)`) so cleanup can reach it.
- Use `kill -0` to test liveness before signaling; `|| true` keeps cleanup from
  aborting under `set -e`.
- Send `SIGTERM` first for graceful shutdown, then `wait`.

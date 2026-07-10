---
name: bash-coding-standards
description: Bash coding standards for production-grade scripts. Use whenever writing, reviewing, or refactoring Bash scripts/functions; whenever conducting a Bash code review; or whenever bash coding standards are referenced.
---

# Bash Coding Standards

Production-grade standards for Bash 4+ scripts, split into concern-specific
reference documents. Load the reference(s) relevant to the task instead of
reading everything.

## How to use this skill

- **Implementing Bash** — start with `references/script-setup.md`, then pull the
  reference matching what you're building (parsing args → `argument-parsing.md`,
  etc.).
- **Reviewing Bash** — walk the [Review checklist](#review-checklist) below and
  open the reference for any category that has issues.
- **Referencing the standards** — cite the relevant bucket below.

## Reference map

- [script-setup.md](references/script-setup.md) - Starting any script; strict mode, shebang, script-dir detection
- [variable-safety.md](references/variable-safety.md) - Quoting, arrays, `[[ ]]`, command substitution
- [input-validation.md](references/input-validation.md) - Checking files, dirs, required vars, dependencies
- [error-handling.md](references/error-handling.md) - Traps, cleanup, exit safety
- [logging.md](references/logging.md) - Structured, leveled log output
- [argument-parsing.md](references/argument-parsing.md) - CLI flags, usage text, named parameters
- [file-operations.md](references/file-operations.md) - Safe move/remove, atomic writes, temp files
- [function-design.md](references/function-design.md) - Function templates
- [idempotency-and-dry-run.md](references/idempotency-and-dry-run.md) - Safe-to-rerun scripts, preview mode
- [process-orchestration.md](references/process-orchestration.md) - Background jobs, signal handling
- [linting.md](references/linting.md) - Running shellcheck; justifying disables

## Review checklist

- [ ] Strict mode `set -Eeuo pipefail` present; expected non-zero exits handled (`|| true`) — `script-setup.md`
- [ ] Top-level constants are `readonly` — `script-setup.md`
- [ ] All variable expansions quoted; `[[ ]]` used; no `cmd | while` var loss — `variable-safety.md`
- [ ] Inputs validated (existence, permissions, required vars, deps) — `input-validation.md`
- [ ] ERR/EXIT traps with cleanup — `error-handling.md`
- [ ] Logging is structured and goes to stderr — `logging.md`
- [ ] Args parsed robustly with usage/help — `argument-parsing.md`
- [ ] File ops are safe/atomic; temp files use `mktemp`; no parsing `ls` — `file-operations.md`
- [ ] Functions use meaningful prefixes, `local -r`, and a `main` entry point — `function-design.md`
- [ ] Script is idempotent; supports dry-run where destructive — `idempotency-and-dry-run.md`
- [ ] Passes `shellcheck` — `linting.md`

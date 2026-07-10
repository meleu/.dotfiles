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

| Concern | Read when | File |
|---|---|---|
| Script setup | Starting any script; strict mode, shebang, script-dir detection | `references/script-setup.md` |
| Variable & data safety | Quoting, arrays, `[[ ]]`, command substitution | `references/variable-safety.md` |
| Input validation | Checking files, dirs, required vars, dependencies | `references/input-validation.md` |
| Error handling | Traps, cleanup, exit safety | `references/error-handling.md` |
| Logging | Structured, leveled log output | `references/logging.md` |
| Argument parsing | CLI flags, usage text, named parameters | `references/argument-parsing.md` |
| File operations | Safe move/remove, atomic writes, temp files | `references/file-operations.md` |
| Function design | Function templates | `references/function-design.md` |
| Idempotency & dry-run | Safe-to-rerun scripts, preview mode | `references/idempotency-and-dry-run.md` |
| Process orchestration | Background jobs, signal handling | `references/process-orchestration.md` |
| Linting | Running shellcheck; justifying disables | `references/linting.md` |

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

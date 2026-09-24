---
name: conftest-rego
description: Write, edit, review, and maintain Rego policies and their unit tests for Conftest, following the OPA Rego Style Guide. Use when creating or modifying .rego files, conftest policies or tests, when the user mentions conftest, OPA, Rego, Regal, or policy-as-code.
---

# Conftest Rego

Readable, tested, lint-clean Conftest policies.
Target **Rego v1**: `if`/`contains`/`in`/`every` are keywords;
never add `import rego.v1` or `import future.keywords...`.

## Canonical example

```rego
# policy/kubernetes/deployment.rego
# METADATA
# title: Kubernetes Deployment policies
package kubernetes

# METADATA
# title: K8S001 - Deny containers running as root
# description: Containers must run as non-root.
deny_root_containers contains msg if {
	_is_deployment
	some container in input.spec.template.spec.containers
	not _runs_as_non_root(container) # negation also catches a missing field
	msg := sprintf(
		"%s: container %q must set runAsNonRoot",
		[rego.metadata.rule().custom.id, container.name]
	)
}

_is_deployment if input.kind == "Deployment"

_runs_as_non_root(container) if container.securityContext.runAsNonRoot == true
```

```rego
# policy/kubernetes/deployment_test.rego
package kubernetes_test

import data.kubernetes

test_deny_missing_run_as_non_root if {
	deployment := parse_config("yaml", `
kind: Deployment
spec:
  template:
    spec:
      containers:
        - name: web
`)
	some msg in kubernetes.deny_root_containers with input as deployment
	contains(msg, "K8S001")
}

test_allow_run_as_non_root if {
	deployment := parse_config("yaml", `
kind: Deployment
spec:
  template:
    spec:
      containers:
        - name: web
          securityContext:
            runAsNonRoot: true
`)
	count(kubernetes.deny_root_containers) == 0 with input as deployment
}
```

## General style rules

- Readability over cleverness.
- Built-ins before hand-rolled logic (`opa capabilities --current` lists them); set ops `&`, `|`, `-`.
- `# METADATA` annotations on packages and public rules; plain comments in bodies and on `_helpers`.
  Links in `related_resources:`, read via `rego.metadata.rule()`, never hardcode (Canonical example).

## Workflow

- **Input shape**: `conftest parse <file>` (plus `--parser`/`--combine` if used). Never guess paths.
- **Existing conventions**: `conftest.toml`, `.regal/config.yaml`, policy dir, namespaces.
  Config file missing? Ask user whether to create it (templates in CONFTEST.md); wait for answer before continuing.
- **Write rule** per [STYLE.md](STYLE.md) and Conftest semantics in [CONFTEST.md](CONFTEST.md).
- **Tests** in `*_test.rego`: cases per CONFTEST.md, "Testing".
- **Checks**: `scripts/check.sh [policy-dir] [data-dir]` (`opa fmt`, `opa check --strict`, `regal lint`, `conftest verify`).
- **Smoke test**: `conftest test -p policy <file>` (`--all-namespaces` or `-n <ns>` if not `main`).

Legacy v0 policies: migrate, don't mix styles (CONFTEST.md, "Migrating v0 policies").

## Rules linters won't catch

1. Undefined silently passes `deny`: use `not <helper>` so missing field *fails*. `not f(input.missing)` never fires.
2. `:=` assign, `==` compare; `=` only for array destructuring.
3. Split long bodies into named helper rules/functions (`_` prefix if package-internal); functions take args, not `input`/`data`.
4. `# METADATA` annotations on packages and public rules.
5. Silent no-ops (CONFTEST.md): policy outside tested namespace; exceptions on plain `deny`/`warn` (need `deny_<name>`).

## Report

List checks run + results; flag rules whose missing-input behavior wasn't tested.

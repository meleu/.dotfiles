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
		[rego.metadata.rule().title, container.name],
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

test_deny_run_as_non_root_false if {
	deployment := parse_config("yaml", `
kind: Deployment
spec:
  template:
    spec:
      containers:
        - name: web
          securityContext:
            runAsNonRoot: false
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

test_ignore_other_kinds if {
	count(kubernetes.deny_root_containers) == 0 with input as {"kind": "Service"}
}
```


## Readability

- Rule body order: filter (scope) → iterate → condition → message.
- One condition per line; helpers named as predicates (`_runs_as_non_root`).
- Split long bodies into helper rules/functions (`_` prefix if package-internal).
- No nested comprehensions; extract partial helper rules (STYLE.md).
- Built-ins and set ops (`&`, `|`, `-`) before hand-rolled logic.
- Comment only Rego-specific semantics (undefined, negation), not the obvious.
- `# METADATA` annotations on packages and public rules:
    - public rule `title:` is `<ID> - <summary>` (e.g. `K8S001 - Deny containers running as root`);

## Workflow

- **Input shape**: `conftest parse <file>` (plus `--parser`/`--combine` if used). Never guess paths.
- **Existing conventions**: `conftest.toml`, `.regal/config.yaml`, policy dir, namespaces.
  Config file missing? Ask user whether to create it (templates in CONFTEST.md); wait for answer before continuing.
- **Write rule** per [STYLE.md](STYLE.md) and Conftest semantics in [CONFTEST.md](CONFTEST.md).
    - **Verify, don't guess.** Unsure a built-in exists or how a construct behaves? Check with
      `opa eval` or `opa capabilities --current | jq -r '.builtins[].name'`. Never invent built-ins.
- **Tests** in `*_test.rego`: violating, compliant, checked field missing, out-of-scope input (e.g. another kind or file type).
- **Checks**: `scripts/check.sh [policy-dir] [data-dir]` (`opa fmt`, `opa check --strict`, `regal lint`, `conftest verify`).
  Without a Regal config it uses the bundled `regal.yaml`. Fix the policy, not the lint config.
- **Smoke test**: `conftest test -p policy <file>` (`--all-namespaces` or `-n <ns>` if not `main`).

Legacy v0 policies: migrate, don't mix styles (CONFTEST.md, "Migrating v0 policies").

## Gotchas linters won't catch

1. Undefined silently passes `deny`: use `not <helper>` so a missing field *fails*. `not f(input.missing)` never fires.
2. Policy outside the tested namespace never runs (CONFTEST.md, "Namespaces").
3. `exception` only applies to `deny_<name>`/`warn_<name>`/`violation_<name>`, never plain `deny`/`warn`.

## v0 habits to avoid

Most Rego seen in training is v0. Check every line against this table.

| Don't (v0) | Do (v1) |
|---|---|
| `deny[msg] { ... }` | `deny contains msg if { ... }` |
| `c := xs[_]` / `xs[_] == v` | `some c in xs` / `v in xs` |
| `x = 1`, `default allow = false` | `x := 1`, `default allow := false` |
| `count([x \| ...]) == count(xs)` | `every x in xs { ... }` |
| `import future.keywords...`, `import rego.v1` | *(nothing)* |

## Report

List checks run + results; flag rules whose missing-input behavior wasn't tested.


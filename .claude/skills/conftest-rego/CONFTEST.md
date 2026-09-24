# Conftest specifics

Flags/options: check `conftest <cmd> --help` rather than guessing.

## Rule types

Queried per namespace; everything else is a helper.

| Rule | Result |
|---|---|
| `deny`, `deny_<name>` | FAIL (non-zero exit) |
| `violation`, `violation_<name>` | FAIL; may return objects |
| `warn`, `warn_<name>` | WARN (exit 0 unless `--fail-on-warn`) |

Always partial set rules: `deny contains msg if { ... }`. Prefer descriptive `deny_<name>` names (also required for exceptions).

## Messages

- `msg` is a string: *what* is wrong, *where* (resource/container name), *how* to fix. `%q` for names, `%v` for values.
- `violation` may return an object; `msg` shown, other keys land in structured output (`conftest test -o json`):

```rego
violation contains {"msg": msg, "details": {"id": "K8S003"}} if {
	not input.metadata.labels.app
	msg := "Deployment must have an app label"
}
```

## Exceptions

`exception` returns rule-name suffixes to skip for current input. Only applies to `deny_<name>`, `violation_<name>`, `warn_<name>`; plain `deny`/`warn` can't be excepted. Group all `exception` definitions (Regal `messy-rule`).

```rego
deny_latest_tag contains msg if {
	some container in input.spec.template.spec.containers
	endswith(container.image, ":latest")
	msg := sprintf("container %q must pin its image tag", [container.name])
}

exception contains rules if {
	input.metadata.name in {"legacy-app", "sandbox"}
	rules := ["latest_tag"]
}
```

## Namespaces and layout

- Default namespace `main`. Others only run with `-n <ns>` or `--all-namespaces`; wrong namespace = policy silently never runs.
- Default policy dir `./policy`. Package mirrors directory **relative to it** (Regal default); file name not part of package:

```text
policy/
├── kubernetes/
│   ├── deployment.rego        # package kubernetes
│   ├── deployment_test.rego   # package kubernetes_test
│   └── service.rego           # package kubernetes
└── lib/
    └── k8s.rego               # package lib.k8s  -> import data.lib.k8s
```

- Shared helpers in `lib/`, as functions taking args. Tiny projects: flat `policy/main.rego`, `package main`.

## Inputs

- `conftest parse <file>` shows `input`. Always inspect; shapes vary by parser (e.g. Dockerfile, XML).
- Parser picked by extension; override with `--parser` (list in `--help`).
- Multi-document YAML: `parse` prints an array, but `test` evaluates each document as its own `input`.
- `--combine`: **one** input, array of `{"path": ..., "contents": ...}`, for cross-file checks:

```rego
deny contains msg if {
	some file in input
	file.contents.kind == "Service"
	not _has_matching_deployment(file.contents, input)
	msg := sprintf("%s: Service %q selects no Deployment", [file.path, file.contents.metadata.name])
}
```

- `--data <dir>`: JSON/YAML files loaded under `data`, keyed by path within dir. Allow-lists/thresholds go there, not in Rego.

## Testing

- `test_*` rules in `*_test.rego`, package `<pkg>_test`, importing package under test.
- Input fixtures: `parse_config("<parser>", <raw string>)` inline, so they read like the real file.
  Object literals only for tiny/synthetic inputs and `with data.x as {...}`.
  `parse_config_file(path)` exists but resolves relative to the working directory; prefer inline.
- `parse_config*` are Conftest-only builtins: run tests with `conftest verify`, not `opa test`.
- Assert **which** rule fired: `some msg in pkg.deny` + `contains(msg, "K8S001")`. Pass case: `count(pkg.deny) == 0`.
- Per rule: violating, compliant, checked field missing, out-of-scope input (e.g. another kind or file type).
- Debug: `conftest verify --trace` / `--report`, `conftest test --trace ... 2>trace.log`; temporary `print()`, then remove.
- Policies using data: `conftest verify -p policy -d data`.

## Config files

Respect if present.

`conftest.toml`: keys mirror CLI flags.

```toml
policy = "policy"
all-namespaces = true
```

`.regal/config.yaml`: Conftest entrypoints are implicit → ignore `no-defined-entrypoint`. Regal can't see `--data` contents → allow-list those refs in `unresolved-reference`:

```yaml
rules:
  idiomatic:
    no-defined-entrypoint:
      level: ignore
  imports:
    unresolved-reference:
      level: error
      except-paths:
        - data.registries
```

## Migrating v0 policies

v0 signs: `deny[msg] { ... }`, no `if`, `import future.keywords`, `import rego.v1`.

1. Pure v0 files (no `if`): `opa fmt --write --v0-compatible --v0-v1 <dir>` (adds `if`/`contains` + `import rego.v1`).
2. `opa fmt --write --drop-v0-imports <dir>` (removes `rego.v1`/`future.keywords` imports).
3. By hand: `=` → `:=`/`==`, `x[_]` → `some ... in`, apply [STYLE.md](STYLE.md).
4. `scripts/check.sh`; existing tests must pass **without changing assertions**.

v0 parsing mode (`conftest test --help`) only as temporary bridge.


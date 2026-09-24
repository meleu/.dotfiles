# Rego style (condensed OPA Rego Style Guide, v1)

Most items are enforced by Regal; its output names the rule and links docs.

## Naming and layout

- `snake_case` everywhere. `_` prefix for package-internal helpers.
- No `get_`/`list_` prefixes; `is_`/`has_` fine for booleans.
- Long lines: break comprehensions and `sprintf` arg arrays across lines.
- Keep all definitions of one incremental rule (`deny`, `exception`, ...) adjacent.

## Rules

**Negation handles undefined.** Comparison on a missing field is undefined, so `deny` silently passes.

```rego
# Avoid: nothing denied when securityContext missing
deny contains msg if {
	input.spec.securityContext.runAsNonRoot == false
	msg := "must run as non-root"
}

# Prefer: denied when false AND when missing
deny contains msg if {
	not _runs_as_non_root
	msg := "must run as non-root"
}

_runs_as_non_root if input.spec.securityContext.runAsNonRoot == true
```

Gotcha: `not` over a call/`in` with an undefined *argument* does NOT fire (`not "NET_RAW" in input.missing` is
undefined, not true). Negate a helper rule, or default the arg: `object.get(obj, path, default)`.

**Helper rules** for repeated/multi-step conditions: `_is_workload if input.kind in {...}`, then `_is_workload` in bodies.

**Partial helper rules over comprehensions in bodies** (queryable, testable). Array comprehension only when order/duplicates matter.

```rego
# Avoid
deny contains msg if {
	privileged := {c.name | some c in input.spec.containers; c.securityContext.privileged}
	count(privileged) > 0
	msg := sprintf("privileged containers: %v", [privileged])
}

# Prefer
deny contains msg if {
	some name in _privileged_containers
	msg := sprintf("container %q must not be privileged", [name])
}

_privileged_containers contains container.name if {
	some container in input.spec.containers
	container.securityContext.privileged == true
}
```

**Unconditional values in head:** `image_name := split(input.image, ":")[0]`, not `image_name := x if { x := ... }`.

## Variables and data types

- **`in` for membership:** `"NET_RAW" in drops`, not `drops[_] == "NET_RAW"`.
  Negated: `not "NET_RAW" in object.get(input, ["capabilities", "drop"], [])` (see gotcha above).
- **`some .. in` for iteration:** `some c in xs`, `some k, v in obj`; not `c := xs[_]`.
  Exception: deep paths read better as `input.a[_].b[_].c`.
- **`:=` assign, `==` compare, never `=`.** Exception: array destructuring,
  `["apps", version] = split(input.apiVersion, "/")`.
- **Declare every variable** with `some`/`:=`, or use `_`.
- **Sets over arrays** for unordered unique values; use set ops.

```rego
required_labels := {"app", "team", "env"}

deny contains msg if {
	missing := required_labels - object.keys(object.get(input.metadata, "labels", {}))
	count(missing) > 0
	msg := sprintf("missing labels: %v", [missing])
}
```

**`every` for FOR ALL**, not count comparisons:

```rego
all_pinned if {
	every container in input.spec.containers {
		contains(container.image, "@sha256:")
	}
}
```

## Functions

- Take arguments; don't read `input`/`data`/rules inside (reusable, testable):
  `_is_trusted(image, registries) if strings.any_prefix_match(image, registries)`.
- Return via head (`parts := split(s, ":")`), never via last arg (`split(s, ":", parts)`).

## Regex, packages, imports

- Raw strings for regex: `` regex.match(`^[a-z0-9-]+$`, name) ``.
- Package mirrors directory relative to policy root (see CONFTEST.md).
- Import packages, reference rules through them: `import data.lib.k8s` → `k8s.is_workload`.
- Don't import `input` (whole-input alias OK: `import input as manifest`).

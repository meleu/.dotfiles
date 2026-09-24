#!/usr/bin/env bash
# Run formatting, strict compile, lint, and unit test checks on Conftest Rego policies.
#
# Usage: check.sh [policy-dir] [data-dir]
#   policy-dir  directory with .rego files (default: policy)
#   data-dir    optional data directory passed to conftest verify

set -Eeuo pipefail

readonly POLICY_DIR="${1:-policy}"
readonly DATA_DIR="${2:-}"

failures=0

# Print OPA capabilities extended with Conftest-only builtins, so that
# `opa check --strict` accepts tests using parse_config() & co.
conftest_capabilities() {
  local -r conftest_builtins='[
    {"name": "parse_config", "decl": {"type": "function",
      "args": [{"type": "string"}, {"type": "string"}], "result": {"type": "any"}}},
    {"name": "parse_config_file", "decl": {"type": "function",
      "args": [{"type": "string"}], "result": {"type": "any"}}},
    {"name": "parse_combined_config_files", "decl": {"type": "function",
      "args": [{"type": "array", "dynamic": {"type": "string"}}], "result": {"type": "any"}}}
  ]'

  opa capabilities --current \
    | opa eval --stdin-input --format raw \
      "json.marshal(object.union(input, {\"builtins\": array.concat(input.builtins, ${conftest_builtins})}))"
}

main() {
  if [[ ! -d "${POLICY_DIR}" ]]; then
    printf 'ERROR: policy directory "%s" not found\n' "${POLICY_DIR}" >&2
    exit 2
  fi

  local cmd
  local missing=0
  for cmd in conftest opa regal; do
    require_command "${cmd}" || missing=1
  done
  ((missing == 0)) || exit 2

  local -a verify_args=(--policy "${POLICY_DIR}" --no-color)
  [[ -n "${DATA_DIR}" ]] && verify_args+=(--data "${DATA_DIR}")

  run_step "opa fmt (run 'opa fmt --write ${POLICY_DIR}' to fix)" \
    opa fmt --list --fail "${POLICY_DIR}"
  # global: the EXIT trap runs after main returns
  capabilities_file="$(mktemp)"
  trap 'rm -f "${capabilities_file}"' EXIT
  conftest_capabilities > "${capabilities_file}"

  run_step "opa check --strict" \
    opa check --strict --capabilities "${capabilities_file}" "${POLICY_DIR}"
  run_step "regal lint" regal lint --no-color "${POLICY_DIR}"

  run_step "conftest verify" conftest verify "${verify_args[@]}"

  printf '\n%d check(s) failed\n' "${failures}"
  ((failures == 0))
}

run_step() {
  local name="$1"
  shift

  printf '\n==> %s\n' "${name}"
  if "$@"; then
    printf 'OK: %s\n' "${name}"
  else
    printf 'FAILED: %s\n' "${name}" >&2
    failures=$((failures + 1))
  fi
}

require_command() {
  local cmd="$1"

  if ! command -v "${cmd}" > /dev/null; then
    printf 'ERROR: "%s" not found in PATH\n' "${cmd}" >&2
    return 1
  fi
}

main

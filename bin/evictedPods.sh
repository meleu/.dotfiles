#!/usr/bin/env bash
# evictedPods.sh
################
#
# List (or delete) all evicted Pods.
#
# Run 'evictedPods.sh -h' to see instructions.
#
# Dependencies:
# - xargs
# - kubectl
#
# NOTE: logic starts in the main() function!

set -Eeuo pipefail

usage() {
  local scriptName="${0##*/}"

  cat <<- EoF

Usage:

${scriptName}                     # lists all Evicted Pods (default namespace)
${scriptName} -n NAMESPACE        # lists Evicted Pods in NAMESPACE
${scriptName} delete              # delete the Evicted Pods
${scriptName} delete -n NAMESPACE # delete the Evicted Pods in NAMESPACE
${scriptName} -h                  # shows this message

EoF
}

listEvictedPods() {
  kubectl get pods "$@" \
    -o jsonpath='{.items[?(@.status.reason == "Evicted")].metadata.name}'
}

###############################################################################
# logic starts here!
###############################################################################
main() {
  local deleteFlag=
  local args=()
  local evictedPods=()

  if [[ ${1:-} =~ ^(-h|--help|help)$ ]]; then
    usage
    return
  fi

  if [[ "${1:-}" == delete ]]; then
    deleteFlag='true'
    shift
  fi

  args=("$@")

  # why using 'read -r -a ...'
  # https://github.com/koalaman/shellcheck/wiki/SC2207
  IFS=' ' read -r -a evictedPods <<< "$(listEvictedPods "${args[@]}")"

  if [[ -z "${evictedPods:-}" ]]; then
    echo "No Evicted Pods"
    return
  fi

  if [[ "${deleteFlag}" == true ]]; then
    echo "Deleting Evicted pods..."
    kubectl delete pod "${args[@]}" "${evictedPods[@]}"
  fi
}

main "$@"

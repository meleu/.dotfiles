#!/usr/bin/env bash
# gitignore.io
##############
# Automatically generate a .gitignore file using the
# https://gitignore.io/ service.
#
# Dependency: curl

export GITIGNORE_TOOLS="vim,emacs,visualstudiocode,linux,windows,macos"

main() {
  if [[ ${1,,} =~ ^(-h|--help|help)$ ]]; then
    usage
    return
  fi

  gitignoreio "$@"
  echo
}

gitignoreio() {
  local url="https://gitignore.io/api"
  local tools="${1:-${GITIGNORE_TOOLS}}"
  curl --location --silent "${url}/${tools}"
}

usage() {
  local scriptName="${0##*/}"
  cat <<- EoF

Usage:

${scriptName} [tool1,tool2,toolN] # generate a .gitignore for specified tools
${scriptName} list                # shows a list of available tools
${scriptName} -h                  # shows this message

When used without any arguments, generates a .gitignore for the default tools.

List of default tools:
${GITIGNORE_TOOLS}

EoF
}

main "$@"

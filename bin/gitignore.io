#!/usr/bin/env bash
# gitignore.io
##############
# Automatically generate a .gitignore file using the https://gitignore.io/ service.
#
# Dependency: curl

export GITIGNORE_TOOLS="${GITIGNORE_TOOLS:-vim,emacs,visualstudiocode,linux,windows,macos}"

usage() {
  local cmd="${0##*/}"

  echo "Usage:"
  echo "${cmd} list              # show all valid options for tools"
  echo "${cmd}                   # generate a gitignore for the default tools"
  echo "${cmd} tool1,tool2,toolN # generate a gitignore for specific tools"
  echo "${cmd} help              # show this message"
}

gitignoreio() {
  local url="https://gitignore.io/api"
  local tools="${1:-${GITIGNORE_TOOLS}}"
  curl --location --silent "${url}/${tools}"
}

main() {
  [[ $1 =~ ^(--help|-h|help)$ ]] && {
    usage
    return 0
  }

  gitignoreio "$@"
  echo
}

main "$@"

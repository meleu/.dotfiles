#!/usr/bin/env bash

readonly DEFAULT_TOOLS="vim,emacs,visualstudiocode,linux,windows,macos"

gitignoreio() {
  local url="https://gitignore.io/api"
  local uri="${1:-${DEFAULT_TOOLS}}"

  curl --location --silent "${url}/${uri}"
  echo
}

gitignoreio "$@"

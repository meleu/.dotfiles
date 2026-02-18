#!/usr/bin/env bash
# meleu's .bash_function
########################
# shellcheck disable=1091

# private stuff
if [ -f "${HOME}/.bash_functions_private" ]; then
  source "${HOME}/.bash_functions_private"
fi

# functions for colorized output
###############################################################################
# ANSI escape color codes
if [[ -z "${ansiRed}" ]]; then
  readonly ansiRed='\e[1;31m'
  readonly ansiGreen='\e[1;32m'
  readonly ansiYellow='\e[1;33m'
  readonly ansiNoColor='\e[0m'
fi

echoRed() {
  echo -e "${ansiRed}$*${ansiNoColor}"
}

echoGreen() {
  echo -e "${ansiGreen}$*${ansiNoColor}"
}

echoYellow() {
  echo -e "${ansiYellow}$*${ansiNoColor}"
}

err() {
  echoRed "$*" >&2
}

warn() {
  echoYellow "$*" >&2
}
###############################################################################

# .files(): update the dotfiles repo
# NOTE: the use of (parentheses) rather than {curly-brackets} is to prevent
#       the need to cd back.
.files() (
  local dotfilesDir="${HOME}/dotfiles"
  local gitStatus

  cd "${dotfilesDir}" || return 1

  gitStatus="$(git status --porcelain)"

  if [[ -z "${gitStatus}" ]]; then
    warn "dotfiles: nothing to update"
    return 0
  fi

  git add --all \
    && git status \
    && git commit -m "update $(date +'%Y-%m-%d %R'): ${gitStatus}" \
    && git pull --rebase \
    && git push
)

# launch(): Open the file/URL with the default application.
launch() {
  case "$OSTYPE" in
    "cygwin"*)
      cygstart "$@"
      ;;
    "darwin"*) # MacOS
      open "$@"
      ;;
    *)
      xdg-open "$@"
      ;;
  esac
}

# google(): Open google.com in the default browser, arguments are used as search terms.
google() {
  local terms
  terms="$(urlencode "$@")"
  launch "https://www.google.com/search?q=${terms}"
}

# 0x0(): Upload file or URL shortener. See more info at https://0x0.st/
0x0() {
  local arg="$1"
  local curlArg

  if [[ -f "${arg}" ]]; then
    curlArg="file=@${arg}"
  elif [[ ${arg} =~ ^https?://.* ]]; then
    curlArg="shorten=${arg}"
  else
    echo "error: '${arg}': invalid argument (not a file neither a URL)" >&2
    return 1
  fi

  curl -F"${curlArg}" https://0x0.st
}

# dud(): get the disk usage of a directory and its subdirs
dud() {
  du --max-depth 1 --human-readable "${@:-.}" \
    | sort --human-numeric-sort
}

getGithubLatestVersion() {
  local repo="$1"
  local regexUserSlashRepo='^[^/]+/[^/]+$'

  if [[ ! "${repo}" =~ $regexUserSlashRepo ]]; then
    err "ERROR: invalid argument '${repo}'"
    echo "Usage: ${FUNCNAME[0]} user/repo" >&2
    return 1
  fi

  curl \
    --silent \
    --location \
    "https://api.github.com/repos/${repo}/releases/latest" \
    | jq -e --raw-output '.tag_name'
}

# a find that ignores the '.git/' directory
gfind() {
  find "$@" -not -iwholename '*/\.git/*'
}

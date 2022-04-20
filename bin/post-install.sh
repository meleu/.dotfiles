#!/usr/bin/env bash
# post-install.sh
#################
#
# Script to run right after a fresh Ubuntu-based distro install.
# Note: I only tested with LinuxMint and Pop!_OS
#
# meleu - https://meleu.dev/
# shellcheck disable=2155,2164,1091
#
# TODO: detect if I'm in "terminal only" interface

MINIMUM_PACKAGES=(
  vim
  htop
  jq
  wget
  curl
  git
  tmux
)

PACKAGES=(
  bat
  figlet
  vim-gtk
  xclip
  virtualbox
  virtualbox-guest-additions-iso
  peek
)

FLATPAK_PACKAGES=(
  md.obsidian.Obsidian
  org.telegram.desktop
  com.slack.Slack
  com.discordapp.Discord
  com.spotify.Client
  rest.insomnia.Insomnia
  org.flameshot.Flameshot
  com.bitwarden.desktop
)

readonly SRC_DIR="${HOME}/src"

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# functions for colorized output
###############################################################################

# ANSI escape color codes
readonly ansiRed='\e[1;31m'
readonly ansiGreen='\e[1;32m'
readonly ansiYellow='\e[1;33m'
readonly ansiNoColor='\e[0m'

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

# helper functions
###############################################################################

installPkg() {
  sudo apt-get update && sudo apt-get install -y "$@"
}

flatpakInstall() {
  flatpak install --noninteractive flathub "$@"
}

# returns success if "$1" is installed
isInstalled() {
  local command="$1"
  command -v "${command}" || return 1
  warn "Skipping: '${command}' seems to be already installed."
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

# functions to install software
###############################################################################
installAsdfvm() {
  isInstalled asdf && return
  echoGreen "\n--> installing asdf version manager..."

  local asdfDir="${HOME}/.asdf"
  local latestVersion

  if [[ -d "${HOME}/.asdf/" ]]; then
    warn "WARNING: '${asdfDir}': directory exists but you don't have 'asdf' in you PATH.\nCheck instructions: https://asdf-vm.com/guide/getting-started.html"
  fi

  latestVersion="$(getGithubLatestVersion asdf-vm/asdf)"

  git clone https://github.com/asdf-vm/asdf.git "${asdfDir}" --branch "${latestVersion}"
  echo 'source "${HOME}/.asdf/asdf.sh"' >> ~/.bashrc
  echo 'source "${HOME}/.asdf/completions/asdf.bash"' >> ~/.bashrc
}

installHyperfine() {
  isInstalled hyperfine && return
  echoGreen "\n--> installing hyperfine version manager..."
  
  local repo='sharkdp/hyperfine'
  local latestVersion="$(getGithubLatestVersion "${repo}")"
  local debFile="hyperfine_${latestVersion#v}_${ARCHITECTURE}.deb"
  
  # https://github.com/sharkdp/hyperfine/releases
  curl -LO "https://github.com/${repo}/releases/download/${latestVersion}/${debFile}"
  sudo dpkg -i "${debFile}"
  rm -f "${debFile}"
}

installVSCode() {
  isInstalled code && return
  echoGreen "\n--> installing Visual Studio Code..."

  # https://code.visualstudio.com/docs/setup/linux#_debian-and-ubuntu-based-distributions
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor > packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
  rm -f packages.microsoft.gpg

  echo \
    "deb [arch=${ARCHITECTURE} signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
    | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

  installPkg apt-transport-https
  installPkg code
}

installDocker() {
  isInstalled docker && return
  echoGreen "\n--> installing docker..."

  # https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
  installPkg ca-certificates gnupg

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

  echo \
    "deb [arch=${ARCHITECTURE} signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  installPkg docker-ce docker-ce-cli containerd.io

  sudo groupadd docker || true
  sudo usermod -aG docker "${USER}"
  newgrp docker
  docker version
}

installKubectl() {
  isInstalled kubectl && return
  echoGreen "\n--> installing kubectl..."

  # https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management
  installPkg apt-transport-https ca-certificates curl

  sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg \
    https://packages.cloud.google.com/apt/doc/apt-key.gpg

  echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" \
    | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

  installPkg kubectl
}

installMinikube() {
  isInstalled minikube && return
  echoGreen "\n--> installing minikube..."

  local debFile='minikube_latest_amd64.deb'

  # https://minikube.sigs.k8s.io/docs/start/
  curl -LO "https://storage.googleapis.com/minikube/releases/latest/${debFile}"
  sudo dpkg -i "${debFile}"
  rm -f "${debFile}"
}

installYtdl() {
  isInstalled youtube-dl && return
  echoGreen "\n--> installing youtube-dl..."

  # https://github.com/ytdl-org/youtube-dl#installation
  sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
  sudo chmod a+rx /usr/local/bin/youtube-dl
}

installGcloud() {
  isInstalled gcloud && return
  echoGreen "\n--> installing gcloud..."

  # https://cloud.google.com/sdk/docs/install#deb
  installPkg apt-transport-https ca-certificates gnupg

  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
    | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

  installPkg google-cloud-cli
}

installBraveBrowser() {
  isInstalled brave-browser && return
  echoGreen "\n--> installing brave-browser..."

  # https://brave.com/linux/#release-channel-installation
  sudo apt install apt-transport-https curl

  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
    https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
    | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

  installPkg brave-browser
}

installSyncthing() {
  isInstalled syncthing && return
  echoGreen "\n--> installing syncthing..."

  # https://apt.syncthing.net/
  sudo curl \
    --silent \
    --output /usr/share/keyrings/syncthing-archive-keyring.gpg \
    https://syncthing.net/release-key.gpg

  echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" \
    | sudo tee /etc/apt/sources.list.d/syncthing.list

  installPkg syncthing
}

###############################################################################
# main
###############################################################################

main() {
  cd "${HOME}" || return 1

  export ARCHITECTURE="$(dpkg --print-architecture)"

  # get the ubuntu codename
  source /etc/os-release
  if [[ -z "${UBUNTU_CODENAME}" ]]; then
    warn "WARNING: failed to detect UBUNTU_CODENAME while installing docker. Skipping..."
  fi
  export UBUNTU_CODENAME

  installPkg "${MINIMUM_PACKAGES[@]}" "${PACKAGES[@]}"
  flatpakInstall "${FLATPAK_PACKAGES[@]}"

  # DevOps tools
  installVSCode
  installDocker
  installKubectl
  installMinikube
  installGcloud
  installAsdfvm
  installHyperfine

  # "regular user" stuff
  installSyncthing
  installBraveBrowser
  installYtdl
}

[[ "$0" == "${BASH_SOURCE[0]}" ]] && main "$@"

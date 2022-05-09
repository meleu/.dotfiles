# meleu's bash aliases
######################
# shellcheck disable=1091

# private stuff
if [ -f "${HOME}/.bash_aliases_private" ]; then
  source "${HOME}/.bash_aliases_private"
fi

# reload ~/.bashrc
alias bashrc='. ~/.bashrc'

# allow aliases to be sudoed
alias sudo='sudo '

# get/set data from/to X clipboard
###############################################################################
# getclip - spits the clipboard on stdout
alias getclip='xclip -selection clipboard -o'

# setclip ${file} - puts file contents in the clipboard
# command | setclip - puts command's output in the clipboard
alias setclip='xclip -selection c'

# easier navigation
alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'
alias cdgh='cd ~/src/github/'
alias cdgl='cd ~/src/gitlab/'

# Interactive operation...
alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# "disk usage here": disk usage of current directory
alias duh='du -cksh'

# Misc :)
alias less='less -r'   # raw control characters
alias whence='type -a' # where, of a sort
alias grep='grep --color'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'
###############################################################################

# I'd like to say:
# launch='xdg-open'
# But I'm declaring it as a function in order to assure
# "portability" between Cygwin/macOs/Linux.
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

# links
alias gmail="launch 'https://gmail.com/'"
alias gist="launch 'https://gist.github.com/'"
alias gh="launch 'https://github.com/'"

# misc
###############################################################################
alias bat='batcat'

alias vim='nvim'

# exa - https://the.exa.website/
alias l='exa -F'
alias ll='exa --long --group-directories-first'
alias lla='exa -la'
alias lsd='exa -D' # list directories only

# show my IP address that is going to the internet
alias myip='curl -4 icanhazip.com'
alias myip6='curl -6 icanhazip.com'

# print each dir in PATH on a separate line
alias path='echo -e "${PATH//:/\\n}"'

# GCP stuff
###############################################################################
alias gcpProject='gcloud config get-value project'

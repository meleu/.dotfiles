#!/bin/bash
# meleu's .bashrc
#################
# shellcheck disable=1090,1091,2155

export PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}"

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# using neovim
export EDITOR='nvim'
export VISUAL="$EDITOR"

# export PATH="$(echo -e "${PATH//:/\\n}" | sort -u | xargs | tr ' ' :)"

# Shell Options
###############################################################################

# Don't wait for job termination notification
# set -o notify

# Use case-insensitive filename globbing
# shopt -s nocaseglob

# check the window size after each command and update the values
# of LINES and COLUMNS
shopt -s checkwinsize

# History Options
###############################################################################
# https://meleu.sh/bash-history/

# HISTCONTROL options
# ignorespace - eliminates commands that begin with a space history list.
# ignoredups - eliminate duplicate commands (from the current session)
# ignoreboth - Enable both ignoredups and ignorespace
# erasedups - eliminate duplicates from the whole list (I don't use it)
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoreboth

# ignore the following commands
export HISTIGNORE='ls:ls -lah:ll:history:pwd:htop:bg:fg:clear'

# show a timestamp in the history command output
export HISTTIMEFORMAT="%F %T$ "

# append last command to the history right before next prompt
[[ "${PROMPT_COMMAND[*]}" != *'history -a'* ]] &&
	export PROMPT_COMMAND+=('history -a')

# history length - see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=10000
export HISTFILESIZE=20000

# make bash append rather than overwrite the history on disk
shopt -s histappend

# save all lines of a mult-line command in the same entry
shopt -s cmdhist

# Aliases
###############################################################################
if [ -f "${HOME}/.aliases" ]; then
	source "${HOME}/.aliases"
fi

# Functions
###############################################################################
if [ -f "${HOME}/.bash_functions" ]; then
	source "${HOME}/.bash_functions"
fi

# Umask
###############################################################################
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# Prompt
###############################################################################
# if in a git repository, shows the current branch
gitBranch() {
	ret="$?"
	branch="$(git branch --show-current 2>/dev/null)" &&
		echo -n " [${branch}]"
	return "${ret}"
}

# PS1 "minimalistic" version:
# /current/directory [branch]
# $
PS1=
PS1+='\[\033[01;34m\]'                        # blue
PS1+='\w'                                     # working dir
PS1+='\[\033[00m\]'                           # no color
PS1+='$(gitBranch || echo "\[\033[01;31m\]")' # red if last command failed
PS1+='\n\$ '
PS1+='\[\033[00m\]' # no color

# user@host:[/directory (git-branch)]
# $
#PS1=
#PS1='\[\033[01;32m\]'   # green
#PS1+='\u@\h'            # user@host
#PS1+='\[\033[00m\]'     # no color
#PS1+=':['
#PS1+='\[\033[01;34m\]'  # blue
#PS1+='\w'               # working directory
#PS1+='\[\033[00m\]'     # no color
#PS1+='$(gitBranch)'
#PS1+=']\n\$ '

# exercism.io
###############################################################################
# bash completion
completionFile="${HOME}/.config/exercism/exercism_completion.bash"
[[ -f "${completionFile}" ]] && source "${completionFile}"

# always run all tests
export BATS_RUN_SKIPPED=true

# # asdf version manager - https://asdf-vm.com
# # I'm replacing this with 'mise en place' https://mise.jdx.dev
# ###############################################################################
# source "${HOME}/.asdf/asdf.sh"
# source "${HOME}/.asdf/completions/asdf.bash"

# glab autocompletion
# https://glab.readthedocs.io/
###############################################################################
# source "${HOME}/.config/glab-cli/glab-completion.bash"

# kubectl autocompletion
###############################################################################
# if 'kubectl' is present, enable autocompletion for bash
command -v kubectl >/dev/null &&
	source <(kubectl completion bash)

case "$OSTYPE" in
"darwin"*) # MacOS
	# TODO: adicionar path pro Homebrew
	;;
*) # Linux (hopefully)
	# Homebrew config
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	# using mise en place
	eval "$(/home/linuxbrew/.linuxbrew/bin/mise activate bash)"
	;;
esac

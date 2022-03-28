#!/bin/bash
# meleu's .bashrc
#################

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

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
# inspiration:
# - https://gist.github.com/ckabalan/7d374ceea8c2d9dd237d763d385cf2aa
# - https://linuxhint.com/bash_command_history_usage/

# HISTCONTROL options
# ignorespace - eliminates commands that begin with a space history list.
# ignoredups - eliminate duplicate commands (from the current session)
# ignoreboth - Enable both ignoredups and ignorespace
# erasedups - eliminate duplicates from the whole list (I don't use it)
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoreboth

# ignore the following commands
export HISTIGNORE='ls:ls -lah:history:pwd:htop:bg:fg:clear'

# show a timestamp in the history command output
export HISTTIMEFORMAT="%F %T$ "

# append last command to the history right before next prompt
export PROMPT_COMMAND+=( 'history -a' )

# history length - see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=10000
export HISTFILESIZE=20000

# make bash append rather than overwrite the history on disk
shopt -s histappend

# save all lines of a mult-line command in the same entry
shopt -s cmdhist


# Aliases
###############################################################################
if [ -f "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
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
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:[\[\033[01;34m\]\w\[\033[00m\]$(
  [[ $(git rev-parse --git-dir 2>/dev/null) != ${HOME}/.git ]] \
    && branch="$(git branch --show-current 2> /dev/null)" \
    && echo " ($branch)"
)]\n\$ '


# exercism.io
###############################################################################
# bash completion
completionFile="${HOME}/.config/exercism/exercism_completion.bash"
[[ -f "${completionFile}" ]] && source "${completionFile}"

# always run all tests
export BATS_RUN_SKIPPED=true


# Instalacao das Funcoes ZZ (www.funcoeszz.net)
###############################################################################
#export ZZOFF=""  # desligue funcoes indesejadas
#export ZZPATH="/home/meleu/src/funcoeszz/funcoeszz"  # script
#export ZZDIR="/home/meleu/src/funcoeszz/zz"    # pasta zz/
#source "$ZZPATH"


# asdf version manager - https://asdf-vm.com
###############################################################################
source "${HOME}/.asdf/asdf.sh"
source "${HOME}/.asdf/completions/asdf.bash"


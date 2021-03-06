# meleu's .bashrc
#################

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

###############################################################################
# Shell Options
###############################################################################

# Don't wait for job termination notification
# set -o notify

# Use case-insensitive filename globbing
# shopt -s nocaseglob

# check the window size after each command and update the values
# of LINES and COLUMNS
shopt -s checkwinsize

# Make bash append rather than overwrite the history on disk
shopt -s histappend

###############################################################################
# History Options
###############################################################################
# Don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoreboth

# history length - see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000



###############################################################################
# Aliases
###############################################################################
if [ -f "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi

###############################################################################
# Functions
###############################################################################
if [ -f "${HOME}/.bash_functions" ]; then
  source "${HOME}/.bash_functions"
fi

###############################################################################
# Umask
###############################################################################
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
umask 027
# Paranoid: neither group nor others have any perms:
# umask 077


###############################################################################
# Prompt
###############################################################################
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '


###############################################################################
# Node Version Manager
###############################################################################
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


###############################################################################
# Install ruby gems as non-root
###############################################################################
export GEM_HOME="$HOME/.gems"
export PATH="$HOME/.gems/bin:$PATH"


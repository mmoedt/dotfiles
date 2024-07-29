# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=200100

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
# if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
#     debian_chroot=$(cat /etc/debian_chroot)
# fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

CHROOT_PREFIX="${debian_chroot:+($debian_chroot) }"
if [ "$color_prompt" = yes ]; then
    C1='\[\033[01;32m\]' # for user@host
    C2='\[\033[00m\]' # reset after user@host
    C3='\[\033[01;34m\]' # for current directory
    C4='\[\033[00m\]' # reset after current dir
    #PS1="${CHROOT_PREFIX}${C1}\u@\h${C2}:${C3}\w${C4}\$ "
else
    :
    #C1=""; C2=""; C3=""; C4=""
    #PS1='[${CHROOT_PREFIX}\u@\h:\w]\$ '
fi

HOSTPART="\h"
HOSTPART="mmmac" # override; we don't like the hostname we have

PS1="[\D{%F %T} ${CHROOT_PREFIX}${C1}\u@${HOSTPART}${C2}:${C3}\w${C4}]\$ "
unset C1 C2 C3 C4 CHROOT_PREFIX
unset color_prompt force_color_prompt

# Add the date and time to the prompt, which is most useful for logging and scrollback forensics
#  - moved to PS1 defn above
PS1="\D{%F %T} ${PS1}"

## DISABLED: Leave alone, so that screen can set the window title..
## If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#    ;;
#*)
#    ;;
#esac

## enable color support of ls and also add handy aliases
#if [ -x /usr/bin/dircolors ]; then
#    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export CLICOLOR="y"  # mac specific?
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    # Mike W M, 20180725:
    alias grepie='grep --color=auto -irE'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
#fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ltr='ls -ltr'
alias lld='ls -ld'

# md from my DOS days..
alias md='mkdir'
alias rd='rmdir'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Get rid of bash completion ..
# method 1:
#unset BASH_COMPLETION_VERSINFO
#unset -f __load_completion
#unset -f _completion_loader
#unset -f _init_completion
# method 2:
#complete -r
# method 3:
shopt -u progcomp

## # enable programmable completion features (you don't need to enable
## # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
## # sources /etc/bash.bashrc).
## if ! shopt -oq posix; then
##   if [ -f /usr/share/bash-completion/bash_completion ]; then
##     . /usr/share/bash-completion/bash_completion
##   elif [ -f /etc/bash_completion ]; then
##     . /etc/bash_completion
##   fi
## fi
##

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# export EDITOR="/usr/bin/emacs-nox"  # either that, or vim!
export EDITOR="/usr/bin/vim"

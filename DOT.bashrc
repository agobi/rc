# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
# For FreeBSD
[ -x /usr/local/bin/lesspipe.sh ] && eval "$(SHELL=/bin/sh /usr/local/bin/lesspipe.sh)"
export PAGER=less

# VIM
if which vim > /dev/null; then
  export EDITOR=vim
fi;

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_COLORHINTS=1

GIT_PROMPT='$(__git_ps1 "[%s]")'

# set a fancy prompt (non-color, unless we know we "want" color)

# Terminal 
case "$TERM" in
xterm*)
	# debian chroot???
	PS1='${debian_chroot:+($debian_chroot)}'$GIT_PROMPT'\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
	LANG=en_US.UTF-8
	;;
rxvt*)
	PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
	LANG=en_US.UTF-8
	;;
*)
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
	LANG=C
	;;
esac
export PS1 LANG PROMPT_COMMAND

# OS dependent files
case `uname` in
	"Darwin"|"FreeBSD") 
		COLOR="-G"
		LL='-laFo'
		;;
	"Linux")
		eval "`dircolors -b`"
		COLOR="--color"
		LL='-laF'
		;;
esac;

# We don't want colors on dump terminal
if [ "$TERM" == "dumb" ]; then
	COLOR=''
fi

# Common aliases
alias ll="ls $LL $COLOR"
alias l="ls -l $COLOR"
alias l2="env LANG=hu_HU.ISO8859-2 luit"


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /usr/local/etc/bash_completion ]; then
	. /usr/local/etc/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi;

if [ -f ~/.bashrc.local ]; then
	source ~/.bashrc.local
fi

if [ -d ~/.local/bin ]; then
  PATH=~/.local/bin:$PATH
fi

if [ -d ~/bin ]; then
  PATH=~/bin:$PATH
fi

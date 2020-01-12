# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi


# Put your fun stuff here.
PATH="~/bin/:$PATH"
EDITOR="vim"
ANDROID_JAVA_HOME="/etc/java-config-2/current-system-vm"
alias ls='ls -G'


export ANDROID_JAVA_HOME
export TERM='xterm-256color'
export LANG=en_US.UTF-8
export BROWSER=google-chrome
export XAUTHORITY=$HOME/.Xauthority

#tcsh style history completion
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

if [ -n "$SSH_CLIENT" ];
then PS1="(ssh) \[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] "
else
    . ~/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh
fi

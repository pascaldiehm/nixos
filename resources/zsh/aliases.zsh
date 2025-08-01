#!/usr/bin/env zsh

alias grep="grep --color=auto"
alias l="ls -alh"
alias ls="ls --color=auto"
alias lsblk="lsblk -o NAME,TYPE,SIZE,PARTLABEL,LABEL,FSTYPE,MOUNTPOINTS"
alias which="which -s"

if [ "$NIXOS_MACHINE_TYPE" = desktop ]; then
  alias open="xdg-open"
  alias py="python3"
fi

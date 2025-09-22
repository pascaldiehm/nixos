#!/usr/bin/env zsh

alias l="ls -al"
alias lsblk="lsblk -o NAME,TYPE,SIZE,PARTLABEL,LABEL,FSTYPE,MOUNTPOINTS"
alias which="which -as"

if [ "$NIXOS_MACHINE_TYPE" = "desktop" ]; then
  alias ls="eza"
  alias open="xdg-open"
  alias py="python3"
elif [ "$NIXOS_MACHINE_TYPE" = "server" ]; then
  alias grep="grep --color=auto"
  alias ls="ls --color=auto"
fi

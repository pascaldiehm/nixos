#!/usr/bin/env zsh

alias fd="fd --hidden"
alias l="ls --all --long --group"
alias ls="eza"
alias lsblk="lsblk --output NAME,TYPE,SIZE,PARTLABEL,LABEL,FSTYPE,MOUNTPOINTS"
alias rg="rg --hidden --smart-case"
alias which="which -as"

if [ "$NIXOS_MACHINE_TYPE" = "desktop" ]; then
  alias open="xdg-open"
  alias py="python3"
  alias tl="tldr"
fi

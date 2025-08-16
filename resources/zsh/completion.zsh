#!/usr/bin/env zsh

compdef _nothing ntfy

if [ "$NIXOS_MACHINE_TYPE" = "desktop" ]; then
  function _repo() {
    if [ "$CURRENT" = 2 ]; then
      _values command help list status clone update edit shell exec remove
    elif [ "$CURRENT" = 3 ]; then
      if [ "${words[2]}" = "status" ]; then
        _values name "${(f)$(ls ~/Repos)}"
      elif [ "${words[2]}" = "update" ]; then
        _values name "${(f)$(ls ~/Repos)}"
      elif [ "${words[2]}" = "edit" ]; then
        _values name "${(f)$(ls ~/Repos)}"
      elif [ "${words[2]}" = "shell" ]; then
        _values name "${(f)$(ls ~/Repos)}"
      elif [ "${words[2]}" = "exec" ]; then
        _values name "${(f)$(ls ~/Repos)}"
      elif [ "${words[2]}" = "remove" ]; then
        _values name "${(f)$(ls ~/Repos)}"
      else
        _nothing
      fi
    elif [ "$CURRENT" = 4 ]; then
      if [ "${words[2]}" = "edit" ]; then
        _files -W "/home/pascal/Repos/${words[3]}"
      elif [ "${words[2]}" = "shell" ]; then
        _files -/ -W "/home/pascal/Repos/${words[3]}"
      else
        _nothing
      fi
    else
      _nothing
    fi
  }

  compdef '_arguments ":mode:(boot switch test)"' nixos-test
  compdef '_arguments ":mode:(boot switch test)"' nixos-upgrade
  compdef '_arguments ":type:($(ls ~/.config/nixos/resources/secrets))"' nixos-secrets
  compdef _nothing ha
  compdef _nothing mkletter
  compdef _nothing nixos-diff
  compdef _nothing nixos-iso
  compdef _repo repo
elif [ "$NIXOS_MACHINE_TYPE" = "server" ]; then
  compdef '_arguments ":service:($(ls ~/docker/$NIXOS_MACHINE_NAME))"' service
  compdef _nothing nixos-upgrade
fi

#!/usr/bin/env zsh

if [ "$NIXOS_MACHINE_TYPE" = "desktop" ]; then
  function _repo() {
    if ((CURRENT == 2)); then
      _arguments ":command:(list status clone update edit remove exec)"
    elif ((CURRENT == 3)) && [ "${words[2]}" = "status" ]; then
      _arguments '2:name:($(ls ~/Repos))'
    elif ((CURRENT == 3)) && [ "${words[2]}" = "update" ]; then
      _arguments '2:name:($(ls ~/Repos))'
    elif ((CURRENT == 3)) && [ "${words[2]}" = "edit" ]; then
      _arguments '2:name:($(ls ~/Repos))'
    elif ((CURRENT == 3)) && [ "${words[2]}" = "remove" ]; then
      _arguments '2:name:($(ls ~/Repos))'
    elif ((CURRENT == 3)) && [ "${words[2]}" = "exec" ]; then
      _arguments '2:name:($(ls ~/Repos))'
    else
      _nothing
    fi
  }

  compdef '_arguments ":mode:(boot switch test)"' nixos-test
  compdef '_arguments ":mode:(boot switch test)"' nixos-upgrade
  compdef '_arguments ":type:($(ls ~/.config/nixos/resources/secrets))"' nixos-secrets
  compdef _nothing letter
  compdef _nothing nixos-diff
  compdef _nothing nixos-iso
  compdef _repo repo
elif [ "$NIXOS_MACHINE_TYPE" = "server" ]; then
  compdef '_arguments ":service:($(ls ~/docker/$NIXOS_MACHINE_NAME))"' service
  compdef _nothing nixos-upgrade
fi

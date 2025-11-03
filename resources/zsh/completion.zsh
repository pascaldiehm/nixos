#!/usr/bin/env zsh

compdef '_arguments ":action:(collection-status list-current-files restore)"' backup
compdef '_arguments ":cmd:_command_names" "*::args:_normal"' watch
compdef _nothing ntfy

if [ "$NIXOS_MACHINE_TYPE" = "desktop" ]; then
  function _repo() {
    if [ "$CURRENT" = 2 ]; then
      _values command help list status clone update edit shell exec remove
    elif [ "$CURRENT" = 3 ]; then
      if [[ "${words[2]}" == (status|update|edit|shell|exec|remove) ]]; then
        _values name "${(f)$(ls /home/pascal/Repos)}"
      fi
    elif [ "$CURRENT" = 4 ]; then
      if [ "${words[2]}" = "edit" ]; then
        _files -W "/home/pascal/Repos/${words[3]}"
      elif [ "${words[2]}" = "shell" ]; then
        _files -/ -W "/home/pascal/Repos/${words[3]}"
      elif [ "${words[2]}" = "exec" ]; then
        _command_names -e
      fi
    elif [ "${words[2]}" = "exec" ]; then
      words=("${words[4]}" "${words[5,-1]}")
      CURRENT="$((CURRENT - 3))"
      _normal
    fi
  }

  compdef '_arguments ":mode:(boot switch test)"' nixos-upgrade
  compdef '_arguments ":mode:(build boot switch test)"' nixos-test
  compdef '_arguments ":type:($(ls /home/pascal/.config/nixos/resources/secrets))"' nixos-secrets
  compdef _nothing ha
  compdef _nothing mkletter
  compdef _nothing nixos-diff
  compdef _nothing nixos-iso
  compdef _nothing wp-toggle
  compdef _repo repo
elif [ "$NIXOS_MACHINE_TYPE" = "server" ]; then
  function _service() {
    if [ "$CURRENT" = 2 ]; then
      _values service "${(f)$(ls /home/pascal/docker/$NIXOS_MACHINE_NAME)}"
    elif [ -f "/home/pascal/docker/$NIXOS_MACHINE_NAME/${words[2]}/compose.yaml" ]; then
      words=("docker" "compose" "--file" "/home/pascal/docker/$NIXOS_MACHINE_NAME/${words[2]}/compose.yaml" "${words[3,-1]}")
      CURRENT="$((CURRENT + 2))"
      _docker
    fi
  }

  compdef _service service
fi

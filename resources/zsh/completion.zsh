#!/usr/bin/env zsh

function _backup() {
  if [ "$CURRENT" = 2 ]; then
    _values command help status list restore clone
  elif [ "$CURRENT" = 3 ]; then
    if [[ "${words[2]}" == (status|list|clone) ]]; then
      _values machine "${(f)$(ls /home/pascal/.config/nixos/machines)}"
    elif [ "${words[2]}" = "restore" ]; then
      _files
    fi
  fi
}

function _nx() {
  if [ "$CURRENT" = 2 ]; then
    _values command help sync diff version edit test upgrade list reset repl secrets iso
  elif [ "$CURRENT" = 3 ]; then
    if [ "${words[2]}" = "upgrade" ]; then
      _values mode boot switch
    elif [ "${words[2]}" = "repl" ]; then
      _values host "${(f)$(ls /home/pascal/.config/nixos/machines)}"
    elif [ "${words[2]}" = "secrets" ]; then
      _values type "${(f)$(ls /home/pascal/.config/nixos/resources/secrets)}"
    fi
  elif [ "$CURRENT" = 4 ]; then
    if [ "${words[2]}" = "reset" ]; then
      _values mode test boot switch
    fi
  fi
}

compdef _backup backup
compdef _files ed
compdef _files mkcd
compdef _nothing ntfy
compdef _nx nx
compdef '_arguments ":cmd:_command_names" "*::args:_normal"' watch
compdef _xh xhs

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

  compdef _nothing ha
  compdef '_arguments ":what:($(mk))" ":where:_files"' mk
  compdef _files mktex
  compdef _files mnt
  compdef _repo repo
  compdef _nothing wp-toggle
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

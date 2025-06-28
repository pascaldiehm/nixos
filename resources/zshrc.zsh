#!/usr/bin/env zsh

setopt PROMPT_SUBST
setopt PUSHDSILENT

function _prompt_char() {
  if expr "$TTY" : /dev/tty >/dev/null; then
    echo -n ">"
  else
    echo -n $'\U276F'
  fi
}

function _prompt_git() {
  git rev-parse HEAD &>/dev/null || return

  local BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  if [ "$BRANCH" = "HEAD" ]; then
    echo -n " %F{3}$(git rev-parse --short HEAD)%f"
  else
    echo -n " %F{8}$BRANCH%f"
  fi

  local STATUS="$(timeout 0.1s git status --porcelain)"
  local CHANGED="$(grep -Ec "^.(\w|\?)" <<<"$STATUS")"
  local STAGED="$(grep -Ec "^\w." <<<"$STATUS")"

  if [ "$CHANGED" -gt "0" ] && [ "$STAGED" -gt "0" ]; then
    echo -n "%F{6}\U203D%f"
  elif [ "$CHANGED" -gt "0" ]; then
    echo -n "%F{6}?%f"
  elif [ "$STAGED" -gt "0" ]; then
    echo -n "%F{6}!%f"
  fi

  test -n "$(git stash list)" && echo -n " %F{6}\U2026%f"

  if [ -n "$(git remote show)" ] && [ "$BRANCH" != "HEAD" ]; then
    if git rev-parse "@{u}" &>/dev/null; then
      local AHEAD="$(git rev-list --count "@{u}..")"
      local BEHIND="$(git rev-list --count "..@{u}")"

      if [ "$AHEAD" -gt "0" ] && [ "$BEHIND" -gt "0" ]; then
        echo -n " %F{6}\U296F%f"
      elif [ "$AHEAD" -gt "0" ]; then
        echo -n " %F{6}\U2191%f"
      elif [ "$BEHIND" -gt "0" ]; then
        echo -n " %F{6}\U2193%f"
      fi
    else
      echo -n " %F{6}\U21A5%f"
    fi
  fi

  local GIT_DIR="$(git rev-parse --git-dir)"
  if [ -f "$GIT_DIR/MERGE_HEAD" ]; then
    echo -n " %F{1}(merge)%f"
  elif [ -f "$GIT_DIR/REVERT_HEAD" ]; then
    echo -n " %F{1}(revert)%f"
  elif [ -f "$GIT_DIR/BISECT_LOG" ]; then
    echo -n " %F{1}(bisect)%f"
  elif [ -f "$GIT_DIR/rebase-merge/interactive" ]; then
    local STEP="$(cat "$GIT_DIR/rebase-merge/msgnum")"
    local TOTAL="$(cat "$GIT_DIR/rebase-merge/end")"
    echo -n " %F{1}(rebase)%f %F{6}$STEP%F{8}/%F{6}$TOTAL%f"
  fi
}

function _prompt_host() {
  test -n "$SSH_TTY" && echo -n " %F{14}%n@%M%f"
}

export PROMPT='%F{4}%~%f$(_prompt_git) %F{%(?.5.1)}$(_prompt_char)%f '
export RPROMPT='$(_prompt_host)'

bindkey -rp ""
bindkey -R " "-"~" self-insert
bindkey -R "\M-^@"-"\M-^?" self-insert

bindkey "^M" accept-line                         # Enter
bindkey "^I" expand-or-complete                  # Tab
bindkey "^[[C" forward-char                      # Right
bindkey "^[[1;5C" forward-word                   # Ctrl+Right
bindkey "^[[D" backward-char                     # Left
bindkey "^[[1;5D" backward-word                  # Ctrl+Left
bindkey "^[[H" beginning-of-line                 # Home
bindkey "^[[F" end-of-line                       # End
bindkey "^[[A" up-line-or-history                # Up
bindkey "^[[B" down-line-or-history              # Down
bindkey "^?" backward-delete-char                # Backspace
bindkey "^H" backward-delete-word                # Ctrl+Backspace
bindkey "^[[3~" delete-char                      # Delete
bindkey "^[[3;5~" delete-word                    # Ctrl+Delete
bindkey "^V" quoted-insert                       # Ctrl+V
bindkey "^[[200~" bracketed-paste                # Ctrl+Shift+V
bindkey "^R" history-incremental-search-backward # Ctrl+R
bindkey "^L" clear-screen                        # Ctrl+L
bindkey "^Z" undo                                # Ctrl+Z
bindkey "^Y" redo                                # Ctrl+Y

alias grep="grep --color=auto"
alias l="ls -alh"
alias ls="ls --color=auto"
alias lsblk="lsblk -o NAME,TYPE,SIZE,PARTLABEL,LABEL,FSTYPE,MOUNTPOINTS"

function mkcd() {
  mkdir -p "$1"
  cd "$1"
}

function mkvim() {
  mkdir -p "$(dirname "$1")"

  if [ "$NIXOS_MACHINE_TYPE" = "desktop" ]; then
    nvim "$1"
  else
    vim "$1"
  fi
}

function nixos-diff() {
  git -C ~/.config/nixos fetch
  git -C ~/.config/nixos diff "${@}" "$(nixos-version --configuration-revision)"...origin
}

function nixos-test() {
  nixos-rebuild --sudo --impure --flake ~/.config/nixos "${1:-test}"
  test -h result && rm result
}

compdef '_arguments ":mode:(boot build switch test)"' nixos-test
compdef '_arguments ":mode:(boot switch test)"' nixos-upgrade
compdef _nothing nixos-diff

if [ "$NIXOS_MACHINE_TYPE" = "desktop" ]; then
  alias open="xdg-open"
  alias py="python3"

  function mktex() {
    BUILD_DIR="$PWD/build"
    mkdir -p "$BUILD_DIR"

    pushd "$(dirname "$1")"
    pdflatex -output-directory "$BUILD_DIR" "$(basename "$1")"
    popd
  }

  function nixos-iso() {
    nix build ~/.config/nixos#nixosConfigurations.installer.config.system.build.isoImage
    cp result/iso/*.iso nixos.iso
    rm result
  }

  function nixos-secrets() {
    sudo GNUPGHOME=/etc/nixos/.gnupg sops ~/.config/nixos/resources/secrets/${1:-desktop}/store.yaml
  }

  function nv() {
    if [ -z "$1" ]; then
      nvim
    elif [ -f "$1" ]; then
      nvim "$1"
    elif [ -d "$1" ]; then
      pushd "$1"
      nvim .
      popd
    else
      mkdir -p "$(dirname "$1")"
      nvim "$1"
    fi
  }

  compdef '_arguments ":type:($(ls ~/.config/nixos/resources/secrets))"' nixos-secrets
  compdef _nothing letter
  compdef _nothing nixos-iso
elif [ "$NIXOS_MACHINE_TYPE" = "server" ]; then
  function service() {
    if [ "$#" = "0" ]; then
      docker compose ls
    else
      docker compose -f "/home/pascal/docker/$1/compose.yaml" "${@:2}"
    fi
  }

  compdef '_arguments ":service:($(find ~/docker -mindepth 1 -maxdepth 1 -type d -not -name ".*" -exec basename -a "{}" +))"' service
fi

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

  local CHANGED="$(git diff --name-only && git ls-files --others --exclude-standard)"
  local STAGED="$(git diff --cached --name-only)"

  if [ -n "$CHANGED" ] && [ -n "$STAGED" ]; then
    echo -n "%F{6}\U203D%f"
  elif [ -n "$CHANGED" ]; then
    echo -n "%F{6}?%f"
  elif [ -n "$STAGED" ]; then
    echo -n "%F{6}!%f"
  fi

  test -n "$(git stash list)" && echo -n " %F{6}\U2026%f"

  if [ -n "$(git remote show)" ] && [ "$BRANCH" != "HEAD" ]; then
    if git rev-parse "@{u}" &>/dev/null; then
      local AHEAD="$(git rev-list "@{u}..")"
      local BEHIND="$(git rev-list "..@{u}")"

      if [ -n "$AHEAD" ] && [ -n "$BEHIND" ]; then
        echo -n " %F{6}\U296F%f"
      elif [ -n "$AHEAD" ]; then
        echo -n " %F{6}\U2191%f"
      elif [ -n "$BEHIND" ]; then
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

function _prompt_pyenv() {
  test -n "$VIRTUAL_ENV" && echo -n " %F{13}($(basename "$(dirname "$VIRTUAL_ENV")"))%f"
}

export VIRTUAL_ENV_DISABLE_PROMPT=1
export PROMPT='%F{4}%~%f$(_prompt_git) %F{%(?.5.1)}$(_prompt_char)%f '
export RPROMPT='$(_prompt_pyenv)$(_prompt_host)'

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
  vim "$1"
}

function nixos-test() {
  sudo nixos-rebuild --impure --flake ~/.config/nixos ${1:-test}
}

compdef '_arguments ":mode:(boot build build-vm switch test)"' nixos-test
compdef _nothing nixos-update

if [ "$NIXOS_MACHINE_TYPE" = "desktop" ]; then
  alias open="xdg-open"
  alias py="python3"

  function nixos-secrets() {
    sudo GNUPGHOME=/etc/nixos/.gnupg sops ~/.config/nixos/resources/secrets/${1:-desktop}/store.yaml
  }

  function nv() {
    if [ -z "$1" ]; then
      nvim
    elif [ -d "$1" ]; then
      pushd "$1"
      nvim .
      popd
    else
      mkdir -p "$(dirname "$1")"
      pushd "$(dirname "$1")"
      nvim "$(basename "$1")"
      popd
    fi
  }

  function pyenv() {
    test -d .venv || python3 -m venv .venv
    source .venv/bin/activate
  }

  compdef '_arguments ":type:($(ls ~/.config/nixos/resources/secrets))"' nixos-secrets
  compdef _nothing letter
  compdef _nothing pyenv
elif [ "$NIXOS_MACHINE_TYPE" = "server" ]; then
  function service() {
    docker compose -f "/home/pascal/docker/$1/compose.yaml" "${@:2}"
  }

  compdef '_arguments ":service:($(find ~/docker -mindepth 1 -maxdepth 1 -type d -not -name ".*" -exec basename -a "{}" +))"' service
fi

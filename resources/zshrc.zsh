#!/usr/bin/env zsh

setopt PROMPT_SUBST
setopt PUSHDSILENT

function _prompt_git() {
  git rev-parse HEAD &>/dev/null || return

  local branch="$(git rev-parse --abbrev-ref HEAD)"
  [ "$branch" = "HEAD" ] && echo -n " %F{3}$(git rev-parse --short HEAD)%f" || echo -n " %F{8}$branch%f"

  local changed="$(git diff --name-only && git ls-files --others --exclude-standard)"
  local staged="$(git diff --cached --name-only)"

  if [ -n "$changed" ] && [ -n "$staged" ]; then
    echo -n "%F{6}\U203D%f"
  elif [ -n "$changed" ]; then
    echo -n "%F{6}?%f"
  elif [ -n "$staged" ]; then
    echo -n "%F{6}!%f"
  fi

  [ -n "$(git stash list)" ] && echo -n " %F{6}\U2026%f"

  if [ -n "$(git remote show)" ] && [ "$branch" != "HEAD" ]; then
    if git rev-parse "@{u}" &>/dev/null; then
      local ahead="$(git rev-list "@{u}..")"
      local behind="$(git rev-list "..@{u}")"

      if [ -n "$ahead" ] && [ -n "$behind" ]; then
        echo -n " %F{6}\U296F%f"
      elif [ -n "$ahead" ]; then
        echo -n " %F{6}\U2191%f"
      elif [ -n "$behind" ]; then
        echo -n " %F{6}\U2193%f"
      fi
    else
      echo -n " %F{6}\U21A5%f"
    fi
  fi

  local git_dir="$(git rev-parse --git-dir)"

  if [ -f "$git_dir/MERGE_HEAD" ]; then
    echo -n " %F{1}(merge)%f"
  elif [ -f "$git_dir/REVERT_HEAD" ]; then
    echo -n " %F{1}(revert)%f"
  elif [ -f "$git_dir/BISECT_LOG" ]; then
    echo -n " %F{1}(bisect)%f"
  elif [ -f "$git_dir/rebase-merge/interactive" ]; then
    local step="$(cat "$git_dir/rebase-merge/msgnum")"
    local total="$(cat "$git_dir/rebase-merge/end")"
    echo -n " %F{1}(rebase)%f %F{6}$step%F{8}/%F{6}$total%f"
  fi
}

function _prompt_host() {
  [ "$NIXOS_MACHINE_TYPE" = "server" ] && echo -n " %F{14}%n@%M%f"
}

function _prompt_pyenv() {
  [ -n "$VIRTUAL_ENV" ] && echo -n " %F{13}($(basename "$(dirname "$VIRTUAL_ENV")"))%f"
}

export VIRTUAL_ENV_DISABLE_PROMPT=1
export PROMPT=$'%F{4}%~%f$(_prompt_git) %F{%(?.5.1)}\U276F%f '
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

function mkcd() { mkdir -p "$1" && cd "$1"; }
function mkvim() { mkdir -p "$(dirname "$1")" && vim "$1"; }
function nixos-test() { sudo nixos-rebuild --impure --flake ~/.config/nixos test; }
function v() { [ -d "$1" ] && l "$1" || cat "$1"; }

compdef _nothing nixos-test

if [ "$NIXOS_MACHINE_TYPE" = "desktop" ]; then
  alias open="xdg-open"
  alias py="python3"

  function _nixos-secrets() { _arguments ":type:($(ls ~/.config/nixos/resources/secrets))"; }
  function nixos-secrets() { sudo GNUPGHOME=/etc/nixos/.gnupg sops ~/.config/nixos/resources/secrets/${1:-desktop}/store.yaml; }

  function mnt() {
    local dir="$(mktemp -d)"

    if [ "$1" = "android" ]; then
      aft-mtp-mount "$dir"
    elif [ "$1" = "tmpfs" ]; then
      sudo mount -t tmpfs /dev/null "$dir"
    elif echo "$1" | grep -q "^ftp://"; then
      curlftpfs "$1" "$dir"
    elif echo "$1" | grep -q "^ssh://"; then
      sshfs "$(echo "$1" | sed -E "s|ssh://(.*)|\1|")" "$dir"
    elif [ -b "$1" ] || [ -f "$1" ]; then
      sudo mount "$1" "$dir"
    elif [ -b "/dev/$1" ]; then
      sudo mount "/dev/$1" "$dir"
    else
      echo "Cannot mount $1"
      rmdir "$dir"
      exit 1
    fi

    pushd "$dir"
    $SHELL
    popd

    echo "Syncing..."
    sync

    echo "Unmounting..."
    umount "$dir" 2>/dev/null || sudo umount "$dir"

    echo "Done."
    rmdir "$dir"
  }

  function nixos-iso() {
    nix build ~/.config/nixos#nixosConfigurations.installer.config.system.build.isoImage
    cp result/iso/*.iso nixos.iso
    rm result
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
    [ -d .venv ] || python3 -m venv .venv
    source .venv/bin/activate
  }

  compdef _nixos-secrets nixos-secrets
  compdef _nothing nixos-iso
  compdef _nothing pyenv
fi

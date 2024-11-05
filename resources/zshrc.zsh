# Prompt
function _prompt_git() {
  # Abort if not in a git repository
  git rev-parse HEAD &>/dev/null || return

  # Branch
  local branch="$(git rev-parse --abbrev-ref HEAD)"
  [ "$branch" = "HEAD" ] && echo -n " %F{3}$(git rev-parse --short HEAD)%f" || echo -n " %F{8}$branch%f"

  # Changes
  local changed="$(git diff --name-only && git ls-files --others --exclude-standard)"
  local staged="$(git diff --cached --name-only)"

  if [ -n "$changed" ] && [ -n "$staged" ]; then
    echo -n "%F{6}\U203D%f"
  elif [ -n "$changed" ]; then
    echo -n "%F{6}?%f"
  elif [ -n "$staged" ]; then
    echo -n "%F{6}!%f"
  fi

  # Stash
  [ -n "$(git stash list)" ] && echo -n " %F{4}\U2026%f"

  # Commits
  if [ -n "$(git remote show)" ] && [ "$branch" != "HEAD" ]; then
    if git rev-parse @{u} &>/dev/null; then
      local ahead="$(git rev-list @{u}..)"
      local behind="$(git rev-list ..@{u})"

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

  # Action
  local git_dir="$(git rev-parse --git-dir)"

  if [ -f "$git_dir/MERGE_HEAD" ]; then
    echo -n " %F{1}(merge)%f"
  elif [ -f "$git_dir/REVERT_HEAD" ]; then
    echo -n "$ %F{1}(revert)%f"
  elif [ -f "$git_dir/rebase-merge/interactive" ]; then
    local step="$(cat "$git_dir/rebase-merge/msgnum")"
    local total="$(cat "$git_dir/rebase-merge/end")"
    echo -n " %F{1}(rebase)%f %F{2}$step%F{8}/%F{2}$total%f"
  fi
}

function _prompt_pyenv() {
  [ -n "$VIRTUAL_ENV" ] && echo -n " %F{5}($(basename "$(dirname "$VIRTUAL_ENV")"))%f"
}

setopt PROMPT_SUBST
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PROMPT=$'%F{4}%~%f$(_prompt_git) %F{%(?.5.1)}\U276F%f '
export RPROMPT='$(_prompt_pyenv)'

# Keybindings
bindkey -rp ''
bindkey -R ' '-'~' self-insert
bindkey -R '\M-^@'-'\M-^?' self-insert

bindkey '^M' accept-line                         # Enter
bindkey '^I' expand-or-complete                  # Tab
bindkey '^[[C' forward-char                      # Right
bindkey '^[[1;5C' forward-word                   # Ctrl+Right
bindkey '^[[D' backward-char                     # Left
bindkey '^[[1;5D' backward-word                  # Ctrl+Left
bindkey '^[[H' beginning-of-line                 # Home
bindkey '^[[F' end-of-line                       # End
bindkey '^[[A' up-line-or-history                # Up
bindkey '^[[B' down-line-or-history              # Down
bindkey '^?' backward-delete-char                # Backspace
bindkey '^H' backward-delete-word                # Ctrl+Backspace
bindkey '^[[3~' delete-char                      # Delete
bindkey '^[[3;5~' delete-word                    # Ctrl+Delete
bindkey '^V' quoted-insert                       # Ctrl+V
bindkey '^[[200~' bracketed-paste                # Ctrl+Shift+V
bindkey '^R' history-incremental-search-backward # Ctrl+R
bindkey '^L' clear-screen                        # Ctrl+L
bindkey '^Z' undo                                # Ctrl+Z
bindkey '^Y' redo                                # Ctrl+Y

bindkey "${key[Home]}" beginning-of-line
bindkey "${key[End]}" end-of-line
bindkey "${key[Up]}" up-line-or-history
bindkey "${key[Down]}" down-line-or-history
bindkey "${key[Left]}" backward-char
bindkey "${key[Right]}" forward-char

# Functions
function mkcd() { mkdir -p "$1" && cd "$1"; }
function mkvim() { mkdir -p "$(dirname "$1")" && vim "$1"; }

function tmprun() {
  local tmp="$(mktemp -d)"
  HOME="$tmp" XDG_CONFIG_HOME="$tmp" XDG_DATA_HOME="$tmp" XDG_CACHE_HOME="$tmp" nix run "nixpkgs#$1" -- "${@:2}"
  rm -rf "$tmp"
}

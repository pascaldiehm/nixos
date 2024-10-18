# Prompt
function _prompt_git() {
    local git_dir=$(git rev-parse --git-dir 2> /dev/null)
    [ -z "$git_dir" ] && return

    local branch=$(git rev-parse --abbrev-ref HEAD)
    local commit=$(git rev-parse --short HEAD)
    local changed=$({ git diff --name-only; git ls-files --others --exclude-standard; } | wc -l)
    local staged=$(git diff --name-only --cached | wc -l)
    local stashed=$(git stash list | wc -l)
    local merge=$([ -f "$git_dir/MERGE_HEAD" ] && echo "merge")

    local remote=$(git rev-parse --abbrev-ref @{u} 2> /dev/null)
    if [ -n "$remote" ]; then
        local ahead=$(git rev-list --count @{u}..)
        local behind=$(git rev-list --count ..@{u})
    fi

    local rebase=$([ -f "$git_dir/rebase-merge/interactive" ] && echo "rebase")
    if [ -n "$rebase" ]; then
        local rebase_step=$(cat "$git_dir/rebase-merge/msgnum")
        local rebase_total=$(cat "$git_dir/rebase-merge/end")
    fi

    [ "$branch" = "HEAD" ] && echo -n " %F{3}$commit%f" || echo -n " %F{8}$branch%f"

    if [ "$changed" -gt 0 ] && [ "$staged" -gt 0 ]; then
        echo -n "%F{6}\U203D%f"
    elif [ "$changed" -gt 0 ]; then
        echo -n "%F{6}?%f"
    elif [ "$staged" -gt 0 ]; then
        echo -n "%F{6}!%f"
    fi

    [ "$stashed" -gt 0 ] && echo -n " %F{4}\U2026%f"

    if [ -n "$remote" ]; then
        if [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then
            echo -n " %F{6}\U296F%f"
        elif [ "$ahead" -gt 0 ]; then
            echo -n " %F{6}\U2191%f"
        elif [ "$behind" -gt 0 ]; then
            echo -n " %F{6}\U2193%f"
        fi
    elif [ "$branch" != "HEAD" ]; then
        echo -n " %F{6}\U21A5%f"
    fi

    [ -n "$rebase" ] && echo -n " %F{1}(rebase)%f %F{2}$rebase_step%F{8}/%F{2}$rebase_total%f"
    [ -n "$merge" ] && echo -n " %F{1}(merge)%f"
}

function _prompt_pyenv() {
    local venv="$VIRTUAL_ENV"
    [ -z "$venv" ] && return

    echo -n " %F{5}($(basename $(dirname "$venv")))%f"
}

setopt PROMPT_SUBST
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PROMPT=$'%F{4}%~%f$(_prompt_git) %F{%(?.5.1)}\U276F%f '
export RPROMPT='$(_prompt_pyenv)'

# Keybindings
bindkey -rp ""
bindkey -R ' '-'~' self-insert
bindkey -R '\M-^@'-'\M-^?' self-insert

bindkey '^M'      accept-line                         # Enter
bindkey '^I'      expand-or-complete                  # Tab
bindkey '^[[C'    forward-char                        # Right
bindkey '^[[1;5C' forward-word                        # Ctrl+Right
bindkey '^[[D'    backward-char                       # Left
bindkey '^[[1;5D' backward-word                       # Ctrl+Left
bindkey '^[[H'    beginning-of-line                   # Home
bindkey '^[[F'    end-of-line                         # End
bindkey '^[[A'    up-line-or-history                  # Up
bindkey '^[[B'    down-line-or-history                # Down
bindkey '^?'      backward-delete-char                # Backspace
bindkey '^H'      backward-delete-word                # Ctrl+Backspace
bindkey '^[[3~'   delete-char                         # Delete
bindkey '^[[3;5~' delete-word                         # Ctrl+Delete
bindkey '^V'      quoted-insert                       # Ctrl+V
bindkey '^[[200~' bracketed-paste                     # Ctrl+Shift+V
bindkey '^R'      history-incremental-search-backward # Ctrl+R
bindkey '^L'      clear-screen                        # Ctrl+L
bindkey '^Z'      undo                                # Ctrl+Z
bindkey '^Y'      redo                                # Ctrl+Y

bindkey "${key[Home]}"  beginning-of-line
bindkey "${key[End]}"   end-of-line
bindkey "${key[Up]}"    up-line-or-history
bindkey "${key[Down]}"  down-line-or-history
bindkey "${key[Left]}"  backward-char
bindkey "${key[Right]}" forward-char

# Functions
function nixos-update() {(
    # Prepare the environment
    set -e
    pushd ~/.config/nixos > /dev/null

    # Make sure the working directory is clean
    if [ -n "$(git status --porcelain)" ]; then
        clear
        echo "There are uncommitted changes."
        echo
        echo "S) Stash"
        echo "R) Restore"
        echo "Q) Abort"
        echo
        echo -n "> "
        read -k 1 action
        echo

        if [ "$action" = "S" ]; then
            local stashed=1
            git stash push
        elif [ "$action" = "R" ]; then
            git restore .
        else
            return 1
        fi
    fi

    # Make sure the working directory is up-to-date
    git fetch
    local ahead=$(git rev-list --count @{u}..)
    local behind=$(git rev-list --count ..@{u})

    if [ $ahead -gt 0 ] && [ $behind -gt 0 ]; then
        clear
        echo "The local branch is diverged from the remote branch."
        echo
        echo "R) Hard reset"
        echo "P) Force push"
        echo "I) Ignore"
        echo "Q) Abort"
        echo
        echo -n "> "
        read -k 1 action
        echo

        if [ "$action" = "R" ]; then
            git reset --hard @{u}
        elif [ "$action" = "P" ]; then
            git push --force
        elif [ "$action" != "I" ]; then
            [ "$stashed" -eq 1 ] && git stash pop
            return 1
        fi
    elif [ $ahead -gt 0 ]; then
        clear
        echo "The local branch is ahead of the remote branch."
        echo
        echo "P) Push"
        echo "R) Reset"
        echo "I) Ignore"
        echo "Q) Abort"
        echo
        echo -n "> "
        read -k 1 action
        echo

        if [ "$action" = "P" ]; then
            git push
        elif [ "$action" = "R" ]; then
            git reset --hard @{u}
        elif [ "$action" != "I" ]; then
            [ "$stashed" -eq 1 ] && git stash pop
            return 1
        fi
    elif [ $behind -gt 0 ]; then
        clear
        echo "The local branch is behind the remote branch."
        echo
        echo "P) Pull"
        echo "I) Ignore"
        echo "Q) Abort"
        echo
        echo -n "> "
        read -k 1 action
        echo

        if [ "$action" = "P" ]; then
            git pull
        elif [ "$action" != "I" ]; then
            [ "$stashed" -eq 1 ] && git stash pop
            return 1
        fi
    fi

    # Update the flake
    nix flake update

    # Update global yarn packages
    yarn --cwd resources/yarn upgrade --latest

    # Update VSCode marketplace extensions
    local tmpdir=$(mktemp -d)
    echo "[" > "$tmpdir/extensions.json"

    local first=1
    for ext in $(cat resources/vscode-extensions.json | jq -c '.[]'); do
        [ "$first" -eq 0 ] && echo "," >> "$tmpdir/extensions.json"
        first=0

        local publisher=$(echo "$ext" | jq -r '.publisher')
        local name=$(echo "$ext" | jq -r '.name')
        local id="$publisher.$name"

        curl --silent -o "$tmpdir/$id.zip" "https://$publisher.gallery.vsassets.io/_apis/public/gallery/publisher/$publisher/extension/$name/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
        local version=$(unzip -qc "$tmpdir/$id.zip" "extension/package.json" | jq -r '.version')
        local sha256=$(nix-hash --flat --base32 --type sha256 "$tmpdir/$id.zip")

        echo -n "  { \"publisher\": \"$publisher\", \"name\": \"$name\", \"version\": \"$version\", \"sha256\": \"$sha256\" }" >> "$tmpdir/extensions.json"
    done

    echo -e "\n]" >> "$tmpdir/extensions.json"
    mv "$tmpdir/extensions.json" resources/vscode-extensions.json
    rm -rf "$tmpdir"

    # Apply the updates
    if [ -n "$(git status --porcelain)" ]; then
        clear
        git status --porcelain
        echo
        echo "Updates are available. Do you want to apply them?"
        echo -n "[y/N] "

        if read -q; then
            echo
            git add flake.lock
            git add resources/yarn/package.json
            git add resources/yarn/yarn.lock
            git add resources/vscode-extensions.json
            git commit -m "Automatic update"
            git push
        else
            echo
            git restore flake.lock
            git restore resources/yarn/package.json
            git restore resources/yarn/yarn.lock
            git restore resources/vscode-extensions.json
        fi
    fi

    # Rebuild the system
    sudo nixos-rebuild --impure --flake . switch
    [ "$stashed" -eq 1 ] && git stash pop
    popd > /dev/null
)}

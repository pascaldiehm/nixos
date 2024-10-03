# Prompt
export PROMPT=$'%F{4}%~%f %F{%(?.5.1)}\U276F%f '

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
    set -e
    pushd ~/.config/nixos > /dev/null

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

    nix flake update
    if [ -n "$(git status --porcelain)" ]; then
        clear
        echo "Updates are available. Do you want to apply them?"
        echo -n "[y/N] "

        if read -q; then
            echo
            git add flake.lock
            git commit -m "Updated flake.lock"
            git push
        else
            echo
            git restore flake.lock
        fi
    fi

    sudo nixos-rebuild --impure --flake . switch
    [ "$stashed" -eq 1 ] && git stash pop
    popd > /dev/null
)}

#!/usr/bin/env bash

set -e
cd ~/Repos

function help() {
  echo "Usage: repo <command> [args...]"
  echo
  echo "Commands:"
  echo "  help                   Show this help"
  echo "  list                   List all repos"
  echo "  status [name]          Show status of one or all repos"
  echo "  clone <url> [name]     Clone a repo"
  echo "  update [name]          Update one or all repos"
  echo "  edit <name> [path]     Open editor in a repo"
  echo "  shell <name> [path]    Open shell in a repo"
  echo "  exec <name> <cmd...>   Execute a command in a repo"
  echo "  remove <name>          Remove a repo"
}

if [ "$#" = 0 ]; then
  help
  exit 1
elif [ "$1" = "help" ]; then
  help
elif [ "$1" = "list" ]; then
  if [ "$#" != 1 ]; then
    echo "Usage: repo list"
    exit 1
  fi

  for REPO in *; do
    test -d "$REPO" || continue
    cd "$REPO"

    HEAD="$(git rev-parse --abbrev-ref HEAD)"
    if [ "$HEAD" = "HEAD" ]; then
      HEAD="\033[33m$(git rev-parse --short HEAD)"
    else
      HEAD="\033[32m$HEAD"
    fi

    CHANGES=""
    if [ -n "$(git status --porcelain)" ]; then
      CHANGES="\033[36m*"
    else
      while read -r BRANCH; do
        if git rev-parse "$BRANCH@{upstream}" &>/dev/null; then
          test -n "$(git rev-list "$BRANCH@{upstream}..$BRANCH")" && CHANGES="\033[36m+"
        else
          CHANGES="\033[36m+"
        fi
      done < <(git branch --format "%(refname:short)")
    fi

    echo -e "\033[1;34m$REPO \033[m$HEAD$CHANGES \033[90m$(git remote get-url origin)"
    cd ..
  done | column -t -N $'\033[4mRepo,Head,Remote\033[m'
elif [ "$1" = "status" ]; then
  function status() {
    cd "$1"
    git fetch

    HEAD="$(git rev-parse --abbrev-ref HEAD)"
    if [ "$HEAD" = "HEAD" ]; then
      HEAD="\033[33m$(git rev-parse --short HEAD)"
    else
      HEAD="\033[32m$HEAD"
    fi

    echo -e "\033[1mRepo: \033[34m$1 \033[m($HEAD\033[m, \033[90m$(git remote get-url origin)\033[m)"
    echo

    if [ -n "$(git status --porcelain)" ]; then
      echo -e "\033[1mChanges:\033[m"
      git status --short
      echo
    fi

    git branch --format "%(refname:short)" | while read -r BRANCH; do
      COMMIT="$(git show --oneline --no-patch "$BRANCH" | sed -E 's/^(\w+) (.+)$/\\033[33m\1 \\033[m\2/')"

      if git rev-parse "$BRANCH@{upstream}" &>/dev/null; then
        AHEAD="$(git rev-list --count "$BRANCH@{upstream}..$BRANCH")"
        BEHIND="$(git rev-list --count "$BRANCH..$BRANCH@{upstream}")"

        echo -e "\033[32m$BRANCH\x09\033[m\u2193\033[36m$BEHIND \033[m\u2191\033[36m$AHEAD\x09$COMMIT"
      else
        echo -e "\033[32m$BRANCH\x09\033[36mlocal\x09$COMMIT"
      fi
    done | column -t -s $'\x09' -N $'\033[4mBranch,Changes,Commit\033[m'

    cd ..
  }

  if [ "$#" = 1 ]; then
    FIRST=1
    for REPO in *; do
      test -d "$REPO" || continue

      ((FIRST)) || echo -e "\n"
      FIRST=0

      status "$REPO"
    done
  elif [ "$#" = 2 ]; then
    if [ ! -d "$2" ]; then
      echo "Repo '$2' not found."
      exit 1
    fi

    status "$2"
  else
    echo "Usage: repo status [name]"
    echo
    echo "name   Repository name (defaults to all)"

    exit 1
  fi
elif [ "$1" = "clone" ]; then
  if [ "$#" = 2 ]; then
    git clone "$2"
  elif [ "$#" = 3 ]; then
    git clone "$2" "$3"
  else
    echo "Usage: repo clone <url> [name]"
    echo
    echo "url    Upstream URL"
    echo "name   Repository name (defaults to upstream name)"

    exit 1
  fi
elif [ "$1" = "update" ]; then
  function conflict() {
    clear
    git status
    echo -n "Press enter to open editor..."
    read -r

    "$EDITOR" .
  }

  function update() {
    cd "$1"
    git fetch

    STASHED=0
    if [ -n "$(git status --porcelain)" ]; then
      STASHED=1
      git stash push --include-untracked
    fi

    HEAD="$(git rev-parse --abbrev-ref HEAD)"
    test "$HEAD" = "HEAD" && HEAD="$(git rev-parse HEAD)"

    git branch --format "%(refname:short)" | while read -r BRANCH; do
      git checkout "$BRANCH"
      git rev-parse "@{u}" &>/dev/null || continue

      if [ -n "$(git status --porcelain)" ]; then
        git stash push --include-untracked
        git pull || conflict
        git stash pop || conflict
      else
        git pull || conflict
      fi
    done

    git checkout "$HEAD"

    if ((STASHED)); then
      git stash pop || conflict
    fi

    cd ..
  }

  if [ "$#" = 1 ]; then
    for REPO in *; do
      test -d "$REPO" && update "$REPO"
    done
  elif [ "$#" = 2 ]; then
    if [ ! -d "$2" ]; then
      echo "Repo '$2' not found."
      exit 1
    fi

    update "$2"
  else
    echo "Usage: repo update [name]"
    echo
    echo "name   Repository name (defaults to all)"

    exit 1
  fi
elif [ "$1" = "edit" ]; then
  if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Usage: repo edit <name> [path]"
    echo
    echo "name   Repository name"
    echo "path   Path to open"

    exit 1
  fi

  if [ ! -d "$2" ]; then
    echo "Repo '$2' not found. Do you want to clone gh:/$2.git?"
    echo
    read -r -n 1 -p "[y/N] " RES
    echo

    if [ "$RES" = "y" ]; then
      git clone "gh:/$2.git"
    else
      exit 1
    fi
  fi

  cd "$2"
  if [ "$#" = 3 ]; then
    if [ -d "$3" ]; then
      cd "$3"
      exec "$EDITOR" .
    elif [ -f "$3" ]; then
      cd "$(dirname "$3")"
      exec "$EDITOR" "$(basename "$3")"
    else
      echo "Path '$3' not found."
      exit 1
    fi
  else
    exec "$EDITOR" .
  fi
elif [ "$1" = "shell" ]; then
  if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Usage: repo shell <name> [path]"
    echo
    echo "name   Repository name"
    echo "path   Path to open"

    exit 1
  fi

  if [ ! -d "$2" ]; then
    echo "Repo '$2' not found."
    exit 1
  fi

  cd "$2"
  if [ "$#" = 3 ]; then
    if [ ! -d "$3" ]; then
      echo "Directory '$3' not found."
      exit 1
    fi

    cd "$3"
  fi

  exec "$SHELL"
elif [ "$1" = "exec" ]; then
  if [ "$#" -lt 3 ]; then
    echo "Usage: repo exec <name> <cmd...>"
    echo
    echo "name   Repository name"
    echo "cmd    Shell command"

    exit 1
  fi

  if [ ! -d "$2" ]; then
    echo "Repo '$2' not found."
    exit 1
  fi

  cd "$2"
  exec "${@:3}"
elif [ "$1" = "remove" ]; then
  if [ "$#" != 2 ]; then
    echo "Usage: repo remove <name>"
    echo
    echo "name   Repository name"

    exit 1
  fi

  if [ ! -d "$2" ]; then
    echo "Repo '$2' not found."
    exit 1
  fi

  cd "$2"
  CHANGES=""
  test -n "$(git status --porcelain)" && CHANGES+="  - Uncommitted changes\n"
  test -n "$(git stash list)" && CHANGES+="  - Stashed changes\n"

  while read -r BRANCH; do
    if git rev-parse "$BRANCH@{upstream}" &>/dev/null; then
      test -n "$(git rev-list "$BRANCH@{upstream}..$BRANCH")" && CHANGES+="  - Unpushed commits ($BRANCH)\n"
    else
      CHANGES+="  - Local branch ($BRANCH)\n"
    fi
  done < <(git branch --format "%(refname:short)")

  if [ -n "$CHANGES" ]; then
    echo "The repository has been changed:"
    echo -e "$CHANGES"
    echo "Are you sure you want to remove the repo?"
    echo
    read -r -n 1 -p "[y/N] " RES
    echo

    test "$RES" = "y" || exit 1
  fi

  cd ..
  rm -rf "$2"
else
  help
  exit 1
fi

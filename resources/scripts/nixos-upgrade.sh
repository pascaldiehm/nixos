#!/usr/bin/env bash

set -e
cd ~/.config/nixos

STASHED=0
if [ -n "$(git status --porcelain)" ]; then
  STASHED=1
  git stash push --include-untracked
fi

git fetch
AHEAD="$(git rev-list "@{u}..")"
BEHIND="$(git rev-list "..@{u}")"

if [ -n "$AHEAD" ] && [ -n "$BEHIND" ]; then
  clear
  echo "The local and remote branches have diverged."
  echo
  echo "P) Pull (rebase) and push"
  echo "F) Force push"
  echo "R) Reset"
  echo "I) Ignore"
  echo "Q) Quit"
  echo
  read -r -n 1 -p "> " RES
  echo

  if [ "$RES" = "P" ]; then
    if ! git pull --rebase; then
      git rebase --abort
      ((STASHED)) && git stash pop
      exit 1
    fi

    git push
  elif [ "$RES" = "F" ]; then
    git push --force
  elif [ "$RES" = "R" ]; then
    git reset --hard "@{u}"
  elif [ "$RES" != "I" ]; then
    ((STASHED)) && git stash pop
    exit 1
  fi
elif [ -n "$AHEAD" ]; then
  clear
  echo "The local branch is ahead of the remote branch."
  echo
  echo "P) Push"
  echo "R) Reset"
  echo "I) Ignore"
  echo "Q) Quit"
  echo
  read -r -n 1 -p "> " RES
  echo

  if [ "$RES" = "P" ]; then
    git push
  elif [ "$RES" = "R" ]; then
    git reset --hard "@{u}"
  elif [ "$RES" != "I" ]; then
    ((STASHED)) && git stash pop
    exit 1
  fi
elif [ -n "$BEHIND" ]; then
  clear
  echo "The local branch is behind the remote branch."
  echo
  echo "P) Pull"
  echo "I) Ignore"
  echo "Q) Quit"
  echo
  read -r -n 1 -p "> " RES
  echo

  if [ "$RES" = "P" ]; then
    git pull
  elif [ "$RES" != "I" ]; then
    ((STASHED)) && git stash pop
    exit 1
  fi
fi

if [ "$(nixos-version --configuration-revision)" = "$(git rev-parse @)" ]; then
  clear
  echo "The configuration has not changed. Continue anyway?"
  echo
  read -r -n 1 -p "[Y/n] " RES
  echo
  test "$RES" = "n" && exit 1
fi

sudo -v
while true; do
  sleep 250
  sudo -v
done &

SUDO_LOOP_PID="$!"
trap 'kill "$SUDO_LOOP_PID"' EXIT

nixos-rebuild --sudo --impure --flake . "${1:-boot}"
if ((STASHED)); then git stash pop; fi

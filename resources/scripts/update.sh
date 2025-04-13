#!/usr/bin/env bash

set -e
pushd ~/.config/nixos

STASHED="false"
if [ -n "$(git status --porcelain)" ]; then
  STASHED="true"
  git stash push --include-untracked
fi

git fetch
AHEAD="$(git rev-list "@{u}..")"
BEHIND="$(git rev-list "..@{u}")"

if [ -n "$AHEAD" ] && [ -n "$BEHIND" ]; then
  clear
  echo "The local branch is diverged from the remote branch."
  echo
  echo "R) Hard reset"
  echo "P) Force push"
  echo "I) Ignore"
  echo "Q) Quit"
  echo
  read -r -n 1 -p "> " RES
  echo

  if [ "$RES" = "R" ]; then
    git reset --hard "@{u}"
  elif [ "$RES" = "P" ]; then
    git push --force
  elif [ "$RES" != "I" ]; then
    test "$STASHED" = "true" && git stash pop
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
    test "$STASHED" = "true" && git stash pop
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
    test "$STASHED" = "true" && git stash pop
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

sudo nixos-rebuild --impure --flake . "${1:-switch}"

test "$STASHED" = "true" && git stash pop
popd

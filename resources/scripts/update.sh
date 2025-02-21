#!/usr/bin/env bash

set -e
pushd ~/.config/nixos
STASHED="false"

if [ -n "$(git status --porcelain)" ]; then
  clear
  echo "There are uncommitted changes."
  echo
  echo "S) Stash"
  echo "R) Restore"
  echo "Q) Quit"
  echo
  read -r -n 1 -p "> " res
  echo

  if [ "$res" = "S" ]; then
    git stash push --include-untracked
    STASHED="true"
  elif [ "$res" = "R" ]; then
    git restore .
  else
    exit 1
  fi
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
  read -r -n 1 -p "> " res
  echo

  if [ "$res" = "R" ]; then
    git reset --hard "@{u}"
  elif [ "$res" = "P" ]; then
    git push --force
  elif [ "$res" != "I" ]; then
    [ "$STASHED" = "true" ] && git stash pop
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
  read -r -n 1 -p "> " res
  echo

  if [ "$res" = "P" ]; then
    git push
  elif [ "$res" = "R" ]; then
    git reset --hard "@{u}"
  elif [ "$res" != "I" ]; then
    [ "$STASHED" = "true" ] && git stash pop
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
  read -r -n 1 -p "> " res
  echo

  if [ "$res" = "P" ]; then
    git pull
  elif [ "$res" != "I" ]; then
    [ "$STASHED" = "true" ] && git stash pop
    exit 1
  fi
fi

if [ "$(cat /etc/nixos/commit)" = "$(git rev-parse HEAD)" ]; then
  clear
  echo "The configuration has not changed. Continue anyway?"
  echo
  read -r -n 1 -p "[Y/n] " res
  echo
  [ "$res" = "n" ] && exit 1
fi

sudo nixos-rebuild --impure --flake . switch
git rev-parse HEAD | sudo tee /etc/nixos/commit

[ "$STASHED" = "true" ] && git stash pop
popd

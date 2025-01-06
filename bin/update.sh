#!/usr/bin/env bash

set -e
pushd ~/.config/nixos >/dev/null

# Make sure the working directory is clean
if [ -n "$(git status --porcelain)" ]; then
  clear
  echo "There are uncommitted changes."
  echo
  echo "S) Stash"
  echo "R) Restore"
  echo "Q) Quit"
  echo
  read -n 1 -p "> " res
  echo

  if [ "$res" = "S" ]; then
    stashed="yes"
    git stash push --include-untracked
  elif [ "$res" = "R" ]; then
    git restore .
  else
    exit 1
  fi
fi

# Make sure the branch is up-to-date
git fetch
ahead="$(git rev-list @{u}..)"
behind="$(git rev-list ..@{u})"

if [ -n "$ahead" ] && [ -n "$behind" ]; then
  clear
  echo "The local branch is diverged from the remote branch."
  echo
  echo "R) Hard reset"
  echo "P) Force push"
  echo "I) Ignore"
  echo "Q) Quit"
  echo
  read -n 1 -p "> " res
  echo

  if [ "$res" = "R" ]; then
    git reset --hard @{u}
  elif [ "$res" = "P" ]; then
    git push --force
  elif [ "$res" != "I" ]; then
    [ -n "$stashed" ] && git stash pop
    exit 1
  fi
elif [ -n "$ahead" ]; then
  clear
  echo "The local branch is ahead of the remote branch."
  echo
  echo "P) Push"
  echo "R) Reset"
  echo "I) Ignore"
  echo "Q) Quit"
  echo
  read -n 1 -p "> " res
  echo

  if [ "$res" = "P" ]; then
    git push
  elif [ "$res" = "R" ]; then
    git reset --hard @{u}
  elif [ "$res" != "I" ]; then
    [ -n "$stashed" ] && git stash pop
    exit 1
  fi
elif [ -n "$behind" ]; then
  clear
  echo "The local branch is behind the remote branch."
  echo
  echo "P) Pull"
  echo "I) Ignore"
  echo "Q) Quit"
  echo
  read -n 1 -p "> " res
  echo

  if [ "$res" = "P" ]; then
    git pull
  elif [ "$res" != "I" ]; then
    [ -n "$stashed" ] && git stash pop
    exit 1
  fi
fi

# Check if configuration changed
if [ "$(cat /etc/nixos/commit)" = "$(git rev-parse HEAD)" ]; then
  clear
  echo "The configuration has not changed. Continue anyway?"
  echo
  read -n 1 -p "[Y/n] " res
  echo
  [ "$res" = "n" ] && exit 1
fi

# Rebuild system
git rev-parse HEAD | sudo tee /etc/nixos/commit
sudo nixos-rebuild --impure --flake . switch

[ -n "$stashed" ] && git stash pop
popd >/dev/null

#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
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

  # Update the system
  bin/update.sh update
  [ -n "$stashed" ] && git stash pop
  popd >/dev/null
elif [ "$1" = "update" ]; then
  # Check if upgrades are available
  clear
  echo "Do you want to check for upgrades?"
  echo
  read -n 1 -p "[Y/n] " res
  echo
  [ "$res" != "n" ] && bin/update.sh upgrade

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
elif [ "$1" = "upgrade" ]; then
  # Upgrade modules
  bin/update.sh upgrade-system
  bin/update.sh upgrade-firefox
  bin/update.sh upgrade-thunderbird
  bin/update.sh upgrade-vscode

  # Apply upgrades
  if [ -n "$(git status --porcelain)" ]; then
    clear
    git status --short
    echo
    echo "Upgrades are available. Apply them?"
    echo
    read -n 1 -p "[y/N] " res
    echo

    if [ "$res" = "y" ]; then
      git add flake.lock
      git add resources/extensions/firefox.json
      git add resources/extensions/thunderbird.json
      git add resources/extensions/vscode.json
      git commit -m "Automatic upgrade"
      git push
    else
      git restore flake.lock
      git restore resources/extensions/firefox.json
      git restore resources/extensions/thunderbird.json
      git restore resources/extensions/vscode.json
    fi
  fi
elif [ "$1" = "upgrade-system" ]; then
  echo "Upgrading system..."
  nix flake update
elif [ "$1" = "upgrade-firefox" ]; then
  echo "Upgrading Firefox extensions..."
  tmp="$(mktemp -d)"
  echo "[" >"$tmp/extensions.json"

  first=1
  for ext in $(cat resources/extensions/firefox.json | jq -c ".[]"); do
    [ "$first" -eq 0 ] && echo "," >>"$tmp/extensions.json"
    first=0

    name="$(echo "$ext" | jq -r ".name")"
    echo "  - $name"

    curl --silent --show-headers "https://addons.mozilla.org/firefox/downloads/latest/$name/latest.xpi" >"$tmp/$name.txt"
    source="$(grep "^location:" "$tmp/$name.txt" | sed -E "s/^location: (\S+)\s*$/\1/")"

    curl --silent -o "$tmp/$name.xpi" "$source"
    id="$(unzip -qc "$tmp/$name.xpi" "manifest.json" | jq -r "(.browser_specific_settings // .applications).gecko.id")"

    echo -n "  { \"name\": \"$name\", \"id\": \"$id\", \"source\": \"$source\" }" >>"$tmp/extensions.json"
  done

  echo -e "\n]" >>"$tmp/extensions.json"
  mv "$tmp/extensions.json" resources/extensions/firefox.json
  rm -rf "$tmp"
elif [ "$1" = "upgrade-thunderbird" ]; then
  echo "Upgrading Thunderbird extensions..."
  tmp="$(mktemp -d)"
  echo "[" >"$tmp/extensions.json"

  first=1
  for ext in $(cat resources/extensions/thunderbird.json | jq -c ".[]"); do
    [ "$first" -eq 0 ] && echo "," >>"$tmp/extensions.json"
    first=0

    name="$(echo "$ext" | jq -r ".name")"
    echo "  - $name"

    curl --silent --show-headers "https://addons.thunderbird.net/thunderbird/downloads/latest/$name/latest.xpi" >"$tmp/$name.txt"
    source="$(grep "^location:" "$tmp/$name.txt" | sed -E "s/^location: (\S+)\s*$/\1/")"

    curl --silent -o "$tmp/$name.xpi" "$source"
    id="$(unzip -qc "$tmp/$name.xpi" "manifest.json" | jq -r "(.browser_specific_settings // .applications).gecko.id")"

    echo -n "  { \"name\": \"$name\", \"id\": \"$id\", \"source\": \"$source\" }" >>"$tmp/extensions.json"
  done

  echo -e "\n]" >>"$tmp/extensions.json"
  mv "$tmp/extensions.json" resources/extensions/thunderbird.json
  rm -rf "$tmp"
elif [ "$1" = "upgrade-vscode" ]; then
  echo "Upgrading VSCode extensions..."
  tmp="$(mktemp -d)"
  echo "[" >"$tmp/extensions.json"

  first=1
  for ext in $(cat resources/extensions/vscode.json | jq -c ".[]"); do
    [ "$first" -eq 0 ] && echo "," >>"$tmp/extensions.json"
    first=0

    publisher="$(echo "$ext" | jq -r ".publisher")"
    name="$(echo "$ext" | jq -r ".name")"
    id="$publisher.$name"
    echo "  - $id"

    curl --silent -o "$tmp/$id.vsix" "https://$publisher.gallery.vsassets.io/_apis/public/gallery/publisher/$publisher/extension/$name/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
    version="$(unzip -qc "$tmp/$id.vsix" "extension/package.json" | jq -r ".version")"

    curl --silent -o "$tmp/$id.vsix" "https://$publisher.gallery.vsassets.io/_apis/public/gallery/publisher/$publisher/extension/$name/$version/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
    hash="sha256-$(sha256sum "$tmp/$id.vsix" | cut -d " " -f 1 | xxd -r -p | base64 -w 0)"

    echo -n "  { \"publisher\": \"$publisher\", \"name\": \"$name\", \"version\": \"$version\", \"hash\": \"$hash\" }" >>"$tmp/extensions.json"
  done

  echo -e "\n]" >>"$tmp/extensions.json"
  mv "$tmp/extensions.json" resources/extensions/vscode.json
  rm -rf "$tmp"
fi

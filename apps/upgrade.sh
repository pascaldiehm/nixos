#!/usr/bin/env bash

set -e

echo "Upgrading system..."
nix flake update

echo "Upgrading Firefox extensions..."
tmp="$(mktemp -d)"
echo "[" >"$tmp/extensions.json"

first=1
jq -c ".[]" resources/extensions/firefox.json | while read -r ext; do
  [ "$first" -eq 0 ] && echo "," >>"$tmp/extensions.json"
  first=0

  name="$(echo "$ext" | jq -r .name)"
  echo "  - $name"

  curl -s -i "https://addons.mozilla.org/firefox/downloads/latest/$name/latest.xpi" >"$tmp/$name.txt"
  source="$(grep "^location:" "$tmp/$name.txt" | sed -E "s/^location: (\S+)\s*$/\1/")"

  curl -s -o "$tmp/$name.xpi" "$source"
  id="$(unzip -q -c "$tmp/$name.xpi" manifest.json | jq -r "(.browser_specific_settings // .applications).gecko.id")"

  echo -n "  { \"name\": \"$name\", \"id\": \"$id\", \"source\": \"$source\" }" >>"$tmp/extensions.json"
done

echo -e "\n]" >>"$tmp/extensions.json"
mv "$tmp/extensions.json" resources/extensions/firefox.json
rm -rf "$tmp"

echo "Upgrading Thunderbird extensions..."
tmp="$(mktemp -d)"
echo "[" >"$tmp/extensions.json"

first=1
jq -c ".[]" resources/extensions/thunderbird.json | while read -r ext; do
  [ "$first" -eq 0 ] && echo "," >>"$tmp/extensions.json"
  first=0

  name="$(echo "$ext" | jq -r .name)"
  echo "  - $name"

  curl -s -i "https://addons.thunderbird.net/thunderbird/downloads/latest/$name/latest.xpi" >"$tmp/$name.txt"
  source="$(grep "^location:" "$tmp/$name.txt" | sed -E "s/^location: (\S+)\s*$/\1/")"

  curl -s -o "$tmp/$name.xpi" "$source"
  id="$(unzip -q -c "$tmp/$name.xpi" manifest.json | jq -r "(.browser_specific_settings // .applications).gecko.id")"

  echo -n "  { \"name\": \"$name\", \"id\": \"$id\", \"source\": \"$source\" }" >>"$tmp/extensions.json"
done

echo -e "\n]" >>"$tmp/extensions.json"
mv "$tmp/extensions.json" resources/extensions/thunderbird.json
rm -rf "$tmp"

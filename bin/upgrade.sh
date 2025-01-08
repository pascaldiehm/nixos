#!/usr/bin/env bash

set -e

echo "Upgrading system..."
nix flake update

echo "Upgrading Firefox extensions..."
tmp="$(mktemp -d)"
echo "[" >"$tmp/extensions.json"

first=1
jq -c ".[]" <resources/extensions/firefox.json | while read -r ext; do
  [ "$first" -eq 0 ] && echo "," >>"$tmp/extensions.json"
  first=0

  name="$(echo "$ext" | jq -r ".name")"
  echo "  - $name"

  curl -s -i "https://addons.mozilla.org/firefox/downloads/latest/$name/latest.xpi" >"$tmp/$name.txt"
  source="$(grep "^location:" "$tmp/$name.txt" | sed -E "s/^location: (\S+)\s*$/\1/")"

  curl -s -o "$tmp/$name.xpi" "$source"
  id="$(unzip -q -c "$tmp/$name.xpi" "manifest.json" | jq -r "(.browser_specific_settings // .applications).gecko.id")"

  echo -n "  { \"name\": \"$name\", \"id\": \"$id\", \"source\": \"$source\" }" >>"$tmp/extensions.json"
done

echo -e "\n]" >>"$tmp/extensions.json"
mv "$tmp/extensions.json" resources/extensions/firefox.json
rm -rf "$tmp"

echo "Upgrading Thunderbird extensions..."
tmp="$(mktemp -d)"
echo "[" >"$tmp/extensions.json"

first=1
jq -c ".[]" <resources/extensions/thunderbird.json | while read -r ext; do
  [ "$first" -eq 0 ] && echo "," >>"$tmp/extensions.json"
  first=0

  name="$(echo "$ext" | jq -r ".name")"
  echo "  - $name"

  curl -s -i "https://addons.thunderbird.net/thunderbird/downloads/latest/$name/latest.xpi" >"$tmp/$name.txt"
  source="$(grep "^location:" "$tmp/$name.txt" | sed -E "s/^location: (\S+)\s*$/\1/")"

  curl -s -o "$tmp/$name.xpi" "$source"
  id="$(unzip -q -c "$tmp/$name.xpi" "manifest.json" | jq -r "(.browser_specific_settings // .applications).gecko.id")"

  echo -n "  { \"name\": \"$name\", \"id\": \"$id\", \"source\": \"$source\" }" >>"$tmp/extensions.json"
done

echo -e "\n]" >>"$tmp/extensions.json"
mv "$tmp/extensions.json" resources/extensions/thunderbird.json
rm -rf "$tmp"

echo "Upgrading VSCode extensions..."
tmp="$(mktemp -d)"
echo "[" >"$tmp/extensions.json"

first=1
jq -c ".[]" <resources/extensions/vscode.json | while read -r ext; do
  [ "$first" -eq 0 ] && echo "," >>"$tmp/extensions.json"
  first=0

  publisher="$(echo "$ext" | jq -r ".publisher")"
  name="$(echo "$ext" | jq -r ".name")"
  id="$publisher.$name"
  echo "  - $id"

  curl -s -o "$tmp/$id.vsix" "https://$publisher.gallery.vsassets.io/_apis/public/gallery/publisher/$publisher/extension/$name/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
  version="$(unzip -qc "$tmp/$id.vsix" "extension/package.json" | jq -r ".version")"

  curl -s -o "$tmp/$id.vsix" "https://$publisher.gallery.vsassets.io/_apis/public/gallery/publisher/$publisher/extension/$name/$version/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
  hash="sha256-$(sha256sum "$tmp/$id.vsix" | cut -d " " -f 1 | xxd -r -p | base64 -w 0)"

  echo -n "  { \"publisher\": \"$publisher\", \"name\": \"$name\", \"version\": \"$version\", \"hash\": \"$hash\" }" >>"$tmp/extensions.json"
done

echo -e "\n]" >>"$tmp/extensions.json"
mv "$tmp/extensions.json" resources/extensions/vscode.json
rm -rf "$tmp"

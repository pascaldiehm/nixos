#!/usr/bin/env bash

set -e

echo "Upgrading system..."
nix flake update

echo "Upgrading Firefox extensions..."
tmp="$(mktemp -d)"
echo "[" >"$tmp/extensions.json"

first=1
for ext in $(cat resources/extensions/firefox.json | jq -c ".[]"); do
  [ "$first" -eq 0 ] && echo "," >>"$tmp/extensions.json"
  first=0

  name="$(echo "$ext" | jq -r ".name")"
  echo "  - $name"

  curl -si "https://addons.mozilla.org/firefox/downloads/latest/$name/latest.xpi" >"$tmp/$name.txt"
  source="$(grep "^location:" "$tmp/$name.txt" | sed -E "s/^location: (\S+)\s*$/\1/")"

  curl -so "$tmp/$name.xpi" "$source"
  id="$(unzip -qc "$tmp/$name.xpi" "manifest.json" | jq -r "(.browser_specific_settings // .applications).gecko.id")"

  echo -n "  { \"name\": \"$name\", \"id\": \"$id\", \"source\": \"$source\" }" >>"$tmp/extensions.json"
done

echo -e "\n]" >>"$tmp/extensions.json"
mv "$tmp/extensions.json" resources/extensions/firefox.json
rm -rf "$tmp"

echo "Upgrading Thunderbird extensions..."
tmp="$(mktemp -d)"
echo "[" >"$tmp/extensions.json"

first=1
for ext in $(cat resources/extensions/thunderbird.json | jq -c ".[]"); do
  [ "$first" -eq 0 ] && echo "," >>"$tmp/extensions.json"
  first=0

  name="$(echo "$ext" | jq -r ".name")"
  echo "  - $name"

  curl -si "https://addons.thunderbird.net/thunderbird/downloads/latest/$name/latest.xpi" >"$tmp/$name.txt"
  source="$(grep "^location:" "$tmp/$name.txt" | sed -E "s/^location: (\S+)\s*$/\1/")"

  curl -so "$tmp/$name.xpi" "$source"
  id="$(unzip -qc "$tmp/$name.xpi" "manifest.json" | jq -r "(.browser_specific_settings // .applications).gecko.id")"

  echo -n "  { \"name\": \"$name\", \"id\": \"$id\", \"source\": \"$source\" }" >>"$tmp/extensions.json"
done

echo -e "\n]" >>"$tmp/extensions.json"
mv "$tmp/extensions.json" resources/extensions/thunderbird.json
rm -rf "$tmp"

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

  curl -so "$tmp/$id.vsix" "https://$publisher.gallery.vsassets.io/_apis/public/gallery/publisher/$publisher/extension/$name/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
  version="$(unzip -qc "$tmp/$id.vsix" "extension/package.json" | jq -r ".version")"

  curl -so "$tmp/$id.vsix" "https://$publisher.gallery.vsassets.io/_apis/public/gallery/publisher/$publisher/extension/$name/$version/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
  hash="sha256-$(sha256sum "$tmp/$id.vsix" | cut -d " " -f 1 | xxd -r -p | base64 -w 0)"

  echo -n "  { \"publisher\": \"$publisher\", \"name\": \"$name\", \"version\": \"$version\", \"hash\": \"$hash\" }" >>"$tmp/extensions.json"
done

echo -e "\n]" >>"$tmp/extensions.json"
mv "$tmp/extensions.json" resources/extensions/vscode.json
rm -rf "$tmp"

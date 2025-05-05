#!/usr/bin/env bash

echo "Upgrading system..."
nix flake update

echo "Upgrading Firefox extensions..."
TMP="$(mktemp -d)"
echo "[" >"$TMP/extensions.json"

FIRST=1
jq -c ".[]" resources/extensions/firefox.json | while read -r EXT; do
  ((FIRST)) || echo "," >>"$TMP/extensions.json"
  FIRST=0

  NAME="$(echo "$EXT" | jq -r .name)"
  echo "  - $NAME"

  curl -Sis "https://addons.mozilla.org/firefox/downloads/latest/$NAME/latest.xpi" >"$TMP/$NAME.txt"
  SOURCE="$(grep "^location:" "$TMP/$NAME.txt" | sed -E "s/^location: (\S+)\s*/\1/")"

  curl -Ss -o "$TMP/$NAME.xpi" "$SOURCE"
  ID="$(unzip -cq "$TMP/$NAME.xpi" manifest.json | jq -r "(.browser_specific_settings // .applications).gecko.id")"

  echo -n "  { \"name\": \"$NAME\", \"id\": \"$ID\", \"source\": \"$SOURCE\" }" >>"$TMP/extensions.json"
done

echo -e "\n]" >>"$TMP/extensions.json"
mv "$TMP/extensions.json" resources/extensions/firefox.json
rm -rf "$TMP"

echo "Upgrading Thunderbird extensions..."
TMP="$(mktemp -d)"
echo "[" >"$TMP/extensions.json"

FIRST=1
jq -c ".[]" resources/extensions/thunderbird.json | while read -r EXT; do
  ((FIRST)) || echo "," >>"$TMP/extensions.json"
  FIRST=0

  NAME="$(echo "$EXT" | jq -r .name)"
  echo "  - $NAME"

  curl -Sis "https://addons.thunderbird.net/thunderbird/downloads/latest/$NAME/latest.xpi" >"$TMP/$NAME.txt"
  SOURCE="$(grep "^location:" "$TMP/$NAME.txt" | sed -E "s/^location: (\S+)\s*/\1/")"

  curl -Ss -o "$TMP/$NAME.xpi" "$SOURCE"
  ID="$(unzip -cq "$TMP/$NAME.xpi" manifest.json | jq -r "(.browser_specific_settings // .applications).gecko.id")"

  echo -n "  { \"name\": \"$NAME\", \"id\": \"$ID\", \"source\": \"$SOURCE\" }" >>"$TMP/extensions.json"
done

echo -e "\n]" >>"$TMP/extensions.json"
mv "$TMP/extensions.json" resources/extensions/thunderbird.json
rm -rf "$TMP"

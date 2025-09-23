#!/usr/bin/env bash

set -e

echo "Upgrading system..."
nix flake update

echo "Upgrading prettier plugins..."
cd overlay/prettier
sed -i 's/"\^.*"/"*"/' package.json
npm upgrade --save
rm -rf node_modules
cd -

echo "Upgrading Firefox extensions..."
TMP="$(mktemp -d)"
echo "[" >"$TMP/extensions.json"

FIRST=1
while read -r EXT; do
  ((FIRST)) || echo "," >>"$TMP/extensions.json"
  FIRST=0

  NAME="$(jq -r .name <<<"$EXT")"
  echo "  - $NAME"

  curl --silent --show-error --head "https://addons.mozilla.org/firefox/downloads/latest/$NAME/latest.xpi" >"$TMP/$NAME.txt"

  if grep -q "^location:" "$TMP/$NAME.txt"; then
    SOURCE="$(grep "^location:" "$TMP/$NAME.txt" | sed -E "s/^location: (\S+)\s*$/\1/")"

    curl --silent --show-error --output "$TMP/$NAME.xpi" "$SOURCE"
    ID="$(unzip -cq "$TMP/$NAME.xpi" manifest.json | jq -r "(.browser_specific_settings // .applications).gecko.id")"
  else
    echo "    -> Failed, no location returned"
    SOURCE="$(jq -r .source <<<"$EXT")"
    SOURCE="$(jq -r .id <<<"$EXT")"
  fi

  echo -n "  { \"name\": \"$NAME\", \"id\": \"$ID\", \"source\": \"$SOURCE\" }" >>"$TMP/extensions.json"
done < <(jq -c ".[]" resources/extensions/firefox.json)

echo -e "\n]" >>"$TMP/extensions.json"
mv "$TMP/extensions.json" resources/extensions/firefox.json
rm -rf "$TMP"

echo "Upgrading Thunderbird extensions..."
TMP="$(mktemp -d)"
echo "[" >"$TMP/extensions.json"

FIRST=1
while read -r EXT; do
  ((FIRST)) || echo "," >>"$TMP/extensions.json"
  FIRST=0

  NAME="$(jq -r .name <<<"$EXT")"
  echo "  - $NAME"

  curl --silent --show-error --head "https://addons.thunderbird.net/thunderbird/downloads/latest/$NAME/latest.xpi" >"$TMP/$NAME.txt"

  if grep -q "^location:" "$TMP/$NAME.txt"; then
    SOURCE="$(grep "^location:" "$TMP/$NAME.txt" | sed -E "s/^location: (\S+)\s*$/\1/")"

    curl --silent --show-error --output "$TMP/$NAME.xpi" "$SOURCE"
    ID="$(unzip -cq "$TMP/$NAME.xpi" manifest.json | jq -r "(.browser_specific_settings // .applications).gecko.id")"
  else
    echo "    -> Failed, no location returned"
    SOURCE="$(jq -r .source <<<"$EXT")"
    ID="$(jq -r .id <<<"$EXT")"
  fi

  echo -n "  { \"name\": \"$NAME\", \"id\": \"$ID\", \"source\": \"$SOURCE\" }" >>"$TMP/extensions.json"
done < <(jq -c ".[]" resources/extensions/thunderbird.json)

echo -e "\n]" >>"$TMP/extensions.json"
mv "$TMP/extensions.json" resources/extensions/thunderbird.json
rm -rf "$TMP"

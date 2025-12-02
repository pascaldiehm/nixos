#!/usr/bin/env bash

set -e
echo "Automatic upgrade" >MSG

echo -e "\n\nUpgrading system..."
nix flake update

CHANGES="$(git diff flake.lock)"
git add flake.lock

test -n "$CHANGES" && {
  echo -e "\nFlake changes:"
  grep '"repo":' <<<"$CHANGES" | cut -d \" -f 4 | sort -u | sed "s/^/  - /"
} >>MSG

echo -e "\n\nUpgrading dynhostmgr..."
pushd overlay/dynhostmgr
cargo update -Z unstable-options --breaking # TODO: Remove unstable-options when breaking is stable
cargo update
popd

CHANGES="$(git diff overlay/dynhostmgr/Cargo.toml)"
git add overlay/dynhostmgr

test -n "$CHANGES" && {
  echo -e "\nDynhostmgr changes:"
  grep ^+ <<<"$CHANGES" | tail -n +2 | cut -d = -f 1 | sort -u | sed "s/^+/  - /"
} >>MSG

echo -e "\n\nUpgrading prettier..."
pushd overlay/prettier
TMP="$(mktemp)"

jq '.dependencies |= with_entries(.value = "*")' package.json >"$TMP"
cp "$TMP" package.json

npm upgrade --save
rm -rf node_modules

if [ -n "$(git status --porcelain .)" ]; then
  jq '.version = (now | strftime("%Y-%m-%d"))' package.json >"$TMP"
  cp "$TMP" package.json
fi

rm "$TMP"
popd

CHANGES="$(git diff overlay/prettier/package.json)"
git add overlay/prettier

test -n "$CHANGES" && {
  echo -e "\nPrettier changes:"
  grep ^+ <<<"$CHANGES" | tail -n +3 | cut -d \" -f 2 | sort -u | sed "s/^/  - /"
} >>MSG

echo -e "\n\nUpgrading Firefox extensions..."
TMP="$(mktemp -d)"
echo "[" >"$TMP/extensions.json"

FIRST=1
while read -r EXT; do
  ((FIRST)) || echo "," >>"$TMP/extensions.json"
  FIRST=0

  NAME="$(jq -r .name <<<"$EXT")"
  echo "  - $NAME"

  curl -fsS --head "https://addons.mozilla.org/firefox/downloads/latest/$NAME/latest.xpi" >"$TMP/$NAME.txt"

  if grep -q "^location:" "$TMP/$NAME.txt"; then
    SOURCE="$(grep "^location:" "$TMP/$NAME.txt" | sed -E "s/^location: (\S+)\s*$/\1/")"

    curl -fsSL -o "$TMP/$NAME.xpi" "$SOURCE"
    ID="$(unzip -cq "$TMP/$NAME.xpi" manifest.json | jq -r "(.browser_specific_settings // .applications).gecko.id")"
  else
    echo "    -> Failed, no location returned"
    SOURCE="$(jq -r .source <<<"$EXT")"
    ID="$(jq -r .id <<<"$EXT")"
  fi

  echo -n "  { \"name\": \"$NAME\", \"id\": \"$ID\", \"source\": \"$SOURCE\" }" >>"$TMP/extensions.json"
done < <(jq -c ".[]" resources/extensions/firefox.json)

echo -e "\n]" >>"$TMP/extensions.json"
mv "$TMP/extensions.json" resources/extensions/firefox.json
rm -rf "$TMP"

CHANGES="$(git diff resources/extensions/firefox.json)"
git add resources/extensions/firefox.json

test -n "$CHANGES" && {
  echo -e "\nFirefox extension changes:"
  grep ^+ <<<"$CHANGES" | tail -n +2 | cut -d \" -f 4 | sort -u | sed "s/^/  - /"
} >>MSG

echo -e "\n\nUpgrading Thunderbird extensions..."
TMP="$(mktemp -d)"
echo "[" >"$TMP/extensions.json"

FIRST=1
while read -r EXT; do
  ((FIRST)) || echo "," >>"$TMP/extensions.json"
  FIRST=0

  NAME="$(jq -r .name <<<"$EXT")"
  echo "  - $NAME"

  curl -fsS --head "https://addons.thunderbird.net/thunderbird/downloads/latest/$NAME/latest.xpi" >"$TMP/$NAME.txt"

  if grep -q "^location:" "$TMP/$NAME.txt"; then
    SOURCE="$(grep "^location:" "$TMP/$NAME.txt" | sed -E "s/^location: (\S+)\s*$/\1/")"

    curl -fsSL -o "$TMP/$NAME.xpi" "$SOURCE"
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

CHANGES="$(git diff resources/extensions/thunderbird.json)"
git add resources/extensions/thunderbird.json

test -n "$CHANGES" && {
  echo -e "\nThunderbird extension changes:"
  grep ^+ <<<"$CHANGES" | tail -n +2 | cut -d \" -f 4 | sort -u | sed "s/^/  - /"
} >>MSG

echo "Done!"

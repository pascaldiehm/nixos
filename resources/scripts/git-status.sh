#!/usr/bin/env bash

REPO_FILE="$(mktemp)"

while true; do
  TMP="$(mktemp)"
  find ~ -type d -name .git -exec dirname "{}" + >"$TMP"
  mv "$TMP" "$REPO_FILE"
  sleep 10
done &

DISCOVER_PID="$!"

while true; do
  while read -r REPO; do
    test -d "$REPO" || continue
    test "$(git -C "$REPO" rev-parse --abbrev-ref HEAD 2>/dev/null)" = "HEAD" && continue
    test -z "$(git -C "$REPO" rev-parse "@{u}" 2>/dev/null)" && continue

    AHEAD="$(git -C "$REPO" rev-list --count "@{u}..")"
    BEHIND="$(git -C "$REPO" rev-list --count "..@{u}")"

    if [ "$AHEAD" -gt "0" ] && [ "$BEHIND" -gt "0" ]; then
      echo -en " $(basename "$REPO")\u296F"
    elif [ "$AHEAD" -gt "0" ]; then
      echo -en " $(basename "$REPO")\u2191"
    elif [ "$BEHIND" -gt "0" ]; then
      echo -en " $(basename "$REPO")\u2193"
    fi
  done <"$REPO_FILE"

  echo
  sleep 1
done &

STATUS_PID="$!"

function cleanup() {
  kill "$DISCOVER_PID" "$STATUS_PID"
  rm "$REPO_FILE"
}

trap cleanup EXIT
wait "$DISCOVER_PID" "$STATUS_PID"

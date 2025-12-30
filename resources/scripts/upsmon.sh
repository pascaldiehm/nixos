#!/usr/bin/env bash

set +e
trap 'echo "{ \"alt\": \"error\", \"class\": \"error\", \"percentage\": 0 }" >"$XDG_RUNTIME_DIR/upsmon"' ERR

while true; do
  CHARGE="$(upsc ext@bowser battery.charge)"
  STATUS="$(upsc ext@bowser ups.status)"
  POWER="$(upsc ext@bowser ups.realpower)"

  if grep -q DISCHRG <<<"$STATUS"; then
    STATE="discharging"
  elif [ "$CHARGE" = 100 ]; then
    STATE="full"
  else
    STATE="charging"
  fi

  echo "{ \"alt\": \"$STATE\", \"class\": \"$STATE\", \"percentage\": $CHARGE, \"tooltip\": \"${POWER}W\" }" >"$XDG_RUNTIME_DIR/upsmon"
  sleep 1
done

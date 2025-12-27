#!/usr/bin/env bash

CHARGE="$(upsc ext@bowser battery.charge)"
STATUS="$(upsc ext@bowser ups.status)"
POWER="$(upsc ext@bowser ups.realpower)"

if grep -q OL <<<"$STATUS"; then
  if [ "$CHARGE" = 100 ]; then
    MODE="full"
  else
    MODE="charging"
  fi
else
  if [ "$CHARGE" -lt 50 ]; then
    MODE="critical"
  else
    MODE="discharging"
  fi
fi

echo "{\"alt\": \"$MODE\", \"class\": \"$MODE\", \"percentage\": $CHARGE, \"tooltip\": \"${POWER}W\"}"

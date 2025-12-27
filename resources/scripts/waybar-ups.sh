#!/usr/bin/env bash

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

echo "{\"alt\": \"$STATE\", \"class\": \"$STATE\", \"percentage\": $CHARGE, \"tooltip\": \"${POWER}W\"}"

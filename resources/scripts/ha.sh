#!/usr/bin/env bash

TOKEN="$(cat "${TOKEN}")"

if [ "$#" = 3 ]; then
  curl --header "Authorization: Bearer $TOKEN" --data "{ \"entity_id\": \"$1.$3\" }" "http://homeassistant:8123/api/services/$1/$2"
else
  echo "Usage: ha <domain> <action> <device>"
  exit 1
fi

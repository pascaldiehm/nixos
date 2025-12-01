#!/usr/bin/env bash

if [ "$#" != 3 ]; then
  echo "Usage: ha <domain> <action> <device>"
  exit 1
fi

TOKEN="$(cat "${TOKEN}")"
curl --header "Authorization: Bearer $TOKEN" --data "{ \"entity_id\": \"$1.$3\" }" "http://homeassistant:8123/api/services/$1/$2"

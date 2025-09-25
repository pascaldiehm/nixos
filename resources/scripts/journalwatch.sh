#!/usr/bin/env bash

PAT_SSHD_PASSWORD="^(Accepted|Failed) password for (\w+) from (\S+) port ([0-9]+) ssh2$"
PAT_SSHD_PUBLICKEY="^(Accepted|Failed) publickey for (\w+) from (\S+) port ([0-9]+) ssh2: (\S+) SHA256:(\S+)$"
PAT_SSHD_USER_DENIED="^User (\w+) from (\S+) not allowed because not listed in AllowUsers$"
PAT_SSHD_USER_INVALID="^Invalid user (\w+) from (\S+) port ([0-9]+)$"
PAT_SUDO_COMMAND="^\s+(\w+) : TTY=\S+ ; PWD=\S+ ; USER=(\w+) ; COMMAND=(.+)$"

journalctl --follow --output json | while read -r LINE; do
  SERVICE="$(jq -r .SYSLOG_IDENTIFIER <<<"$LINE")"
  MESSAGE="$(jq -r .MESSAGE <<<"$LINE")"

  if [ "$SERVICE" = "sshd-session" ]; then
    if grep -Eq "$PAT_SSHD_PASSWORD" <<<"$MESSAGE"; then
      ntfy journal "$(sed -E "s/$PAT_SSHD_PASSWORD/[sshd] \\1 password for \\2 from \\3/" <<<"$MESSAGE")"
    elif grep -Eq "$PAT_SSHD_PUBLICKEY" <<<"$MESSAGE"; then
      ntfy journal "$(sed -E "s/$PAT_SSHD_PUBLICKEY/[sshd] \\1 publickey for \\2 from \\3/" <<<"$MESSAGE")"
    elif grep -Eq "$PAT_SSHD_USER_DENIED" <<<"$MESSAGE"; then
      ntfy journal "$(sed -E "s/$PAT_SSHD_USER_DENIED/[sshd] Denied user \\1 from \\2/" <<<"$MESSAGE")"
    elif grep -Eq "$PAT_SSHD_USER_INVALID" <<<"$MESSAGE"; then
      ntfy journal "$(sed -E "s/$PAT_SSHD_USER_INVALID/[sshd] Invalid user \\1 from \\2/" <<<"$MESSAGE")"
    fi
  elif [ "$SERVICE" = "sudo" ]; then
    if grep -Eq "$PAT_SUDO_COMMAND" <<<"$MESSAGE"; then
      ntfy journal "$(sed -E "s/$PAT_SUDO_COMMAND/[sudo] \\1 as \\2: \\3/" <<<"$MESSAGE")"
    fi
  fi
done

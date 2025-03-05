#!/usr/bin/env bash

PAT_SSHD_PASSWORD="^(Accepted|Failed) password for (\w+) from (\S+) port ([0-9]+) ssh2$"
PAT_SSHD_PUBLICKEY="^(Accepted|Failed) publickey for (\w+) from (\S+) port ([0-9]+) ssh2: (\S+) SHA256:(\S+)$"
PAT_SSHD_USER_DENIED="^User (\w+) from (\S+) not allowed because not listed in AllowUsers$"
PAT_SSHD_USER_INVALID="^Invalid user (\w+) from (\S+) port ([0-9]+)$"
PAT_SUDO_COMMAND="^\s+(\w+) : TTY=\S+ ; PWD=\S+ ; USER=(\w+) ; COMMAND=(.+)$"

journalctl -f -o json | while read -r LINE; do
  SERVICE="$(echo "$LINE" | jq -r .SYSLOG_IDENTIFIER)"
  MESSAGE="$(echo "$LINE" | jq -r .MESSAGE)"

  if [ "$SERVICE" = "sshd-session" ]; then
    if echo "$MESSAGE" | grep -Eq "$PAT_SSHD_PASSWORD"; then
      ntfy journal "$(echo "$MESSAGE" | sed -E "s/$PAT_SSHD_PASSWORD/[sshd] \\1 password for \\2 (\\3:\\4)/")"
    elif echo "$MESSAGE" | grep -Eq "$PAT_SSHD_PUBLICKEY"; then
      ntfy journal "$(echo "$MESSAGE" | sed -E "s/$PAT_SSHD_PUBLICKEY/[sshd] \\1 publickey (\\5) for \\2 (\\3:\\4): \\6/")"
    elif echo "$MESSAGE" | grep -Eq "$PAT_SSHD_USER_DENIED"; then
      ntfy journal "$(echo "$MESSAGE" | sed -E "s/$PAT_SSHD_USER_DENIED/[sshd] Denied user \\1 (\\2)/")"
    elif echo "$MESSAGE" | grep -Eq "$PAT_SSHD_USER_INVALID"; then
      ntfy journal "$(echo "$MESSAGE" | sed -E "s/$PAT_SSHD_USER_INVALID/[sshd] Invalid user \\1 (\\2:\\3)/")"
    fi
  elif [ "$SERVICE" = "sudo" ]; then
    if echo "$MESSAGE" | grep -Eq "$PAT_SUDO_COMMAND"; then
      ntfy journal "$(echo "$MESSAGE" | sed -E "s/$PAT_SUDO_COMMAND/[sudo] \\1 as \\2: \\3/")"
    fi
  fi
done

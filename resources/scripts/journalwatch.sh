#!/usr/bin/env bash

PAT_SSHD_PASSWORD="^(Accepted|Failed) password for (\w+) from (\S+) port ([0-9]+) ssh2$"
PAT_SSHD_PUBLICKEY="^(Accepted|Failed) publickey for (\w+) from (\S+) port ([0-9]+) ssh2: (\S+) SHA256:(\S+)$"
PAT_SSHD_USER="^Invalid user (\w+) from (\S+) port ([0-9]+)$"
PAT_SYSTEMD_SESSION="^New session ([0-9]+) of user (\w+).$"
PAT_SUDO_COMMAND="^\s+(\w+) : TTY=\S+ ; PWD=\S+ ; USER=(\w+) ; COMMAND=(.+)$"

journalctl -f | while read -r line; do
  service="$(echo "$line" | cut -d "[" -f 1 | cut -d " " -f 5)"
  message="$(echo "$line" | cut -d : -f 4- | tail -c +2)"

  if [ "$service" = "sshd" ]; then
    if echo "$message" | grep -Eq "$PAT_SSHD_PASSWORD"; then
      ntfy journal "$(echo "$message" | sed -E "s/$PAT_SSHD_PASSWORD/[sshd] \\1 password for \\2 (\\3:\\4)/")"
    elif echo "$message" | grep -Eq "$PAT_SSHD_PUBLICKEY"; then
      ntfy journal "$(echo "$message" | sed -E "s/$PAT_SSHD_PUBLICKEY/[sshd] \\1 publickey (\\5) for \\2 (\\3:\\4): \\6/")"
    elif echo "$message" | grep -Eq "$PAT_SSHD_USER"; then
      ntfy journal "$(echo "$message" | sed -E "s/$PAT_SSHD_USER/[sshd] Invalid user \\1 (\\2:\\3)/")"
    fi
  elif [ "$service" = "systemd-logind" ]; then
    if echo "$message" | grep -Eq "$PAT_SYSTEMD_SESSION"; then
      ntfy journal "$(echo "$message" | sed -E "s/$PAT_SYSTEMD_SESSION/[systemd] New session for \\2/")"
    fi
  elif [ "$service" = "sudo" ]; then
    if echo "$message" | grep -Eq "$PAT_SUDO_COMMAND"; then
      ntfy journal "$(echo "$message" | sed -E "s/$PAT_SUDO_COMMAND/[sudo] \\1 as \\2: \\3/")"
    fi
  fi
done

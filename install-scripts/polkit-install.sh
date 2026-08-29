#!/usr/bin/env bash

set -e

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# pcscd guards access via polkit. The packaged default only allows local,
# active sessions, so scdaemon fails over SSH with
# "selecting card failed: Service is not running".
sudo install -m 644 -o root -g root \
    "$repo/polkit/49-pcscd.rules" /etc/polkit-1/rules.d/49-pcscd.rules

# polkit >= 121 no longer reads .pkla files; remove the dead override.
sudo rm -f /etc/polkit-1/localauthority/50-local.d/org.debian.pcsc-lite.pkla

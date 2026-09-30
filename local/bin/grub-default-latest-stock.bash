#!/usr/bin/env bash

# Set GRUB_DEFAULT to the latest installed stock (distro packaged) kernel.
# Self-built kernels are skipped because they are not owned by a dpkg package.

set -euo pipefail

grub_file=/etc/default/grub

latest=""
for f in /boot/vmlinuz-*; do
    dpkg -S "$f" > /dev/null 2>&1 || continue
    ver=${f#/boot/vmlinuz-}
    latest=$(printf '%s\n%s\n' "$latest" "$ver" | sed '/^$/d' | sort -V | tail -n1)
done

if [ -z "$latest" ]; then
    echo "No stock kernel found in /boot" >&2
    exit 1
fi

uuid=$(findmnt -no UUID /)
if [ -z "$uuid" ]; then
    echo "Could not determine UUID of /" >&2
    exit 1
fi

entry="gnulinux-advanced-$uuid>gnulinux-$latest-advanced-$uuid"
current=$(sed -n 's/^GRUB_DEFAULT=//p' "$grub_file" | tr -d '"')

echo "Latest stock kernel: $latest"
echo "Current default:     $current"

if [ "$current" = "$entry" ]; then
    echo "Already up to date."
    exit 0
fi

echo "New default:         $entry"

sudo sed -i "s|^GRUB_DEFAULT=.*|GRUB_DEFAULT=\"$entry\"|" "$grub_file"
sudo update-grub

#!/usr/bin/env bash

set -e

script_dir=$(dirname $0)

echo "The script is located in: $script_dir"

restic -r sftp:root@kaka.local:/srv/dev-disk-by-uuid-9d46a446-dacd-42d8-8752-1f64bc9e6361/backups-julian/restic \
	--verbose backup ~/ \
	--exclude-file $script_dir/restic-exclude.txt

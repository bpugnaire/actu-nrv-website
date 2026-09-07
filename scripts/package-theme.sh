#!/usr/bin/env sh
set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
theme_dir="$project_root/theme"
output_dir="$project_root/dist"
output_file="$output_dir/nice-rendezvous-theme.zip"

mkdir -p "$output_dir"
rm -f "$output_file"

cd "$theme_dir"
zip -q -r "$output_file" . \
    -x '*.DS_Store' \
    -x 'node_modules/*'

printf 'Created %s\n' "$output_file"

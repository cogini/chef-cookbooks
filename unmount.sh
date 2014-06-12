#!/bin/bash

set -e

bin_dir="$(cd "$(dirname "$0")" && pwd)"

while read module
do
    link_path="$bin_dir/site-cookbooks/${module%;*}"
    mkdir -p "$link_path"
    [[ "$(ls -A "$link_path")" ]] && sudo umount "$link_path"
done < "$bin_dir/modules"

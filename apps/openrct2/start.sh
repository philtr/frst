#!/bin/sh
set -eu

data_dir=/data
autosave_dir="$data_dir/save/autosave"
seed="$data_dir/save/seed.park"

mkdir -p "$autosave_dir"

if [ ! -e "$data_dir/config.ini" ]; then
    cp /openrct2/config.ini "$data_dir/config.ini"
    echo "openrct2: installed initial config.ini"
fi

if [ ! -e "$data_dir/groups.json" ]; then
    cp /openrct2/groups.json "$data_dir/groups.json"
    echo "openrct2: installed initial multiplayer groups"
fi

if [ ! -s "$seed" ]; then
    echo "openrct2: immutable seed is missing or empty: $seed" >&2
    exit 1
fi

newest_autosave="$({
    find "$autosave_dir" -maxdepth 1 -type f -name 'autosave_*.park' -size +0c \
        -printf '%T@ %p\n' 2>/dev/null || true
} | sort -nr | sed -n '1s/^[^ ]* //p')"

if [ -n "$newest_autosave" ]; then
    park="$newest_autosave"
    echo "openrct2: selected newest persisted autosave: $park"
else
    park="$seed"
    echo "openrct2: no persisted autosave found; selected immutable seed: $park"
fi

exec openrct2-cli host "$park" \
    --port 11753 \
    --headless \
    --user-data-path "$data_dir"

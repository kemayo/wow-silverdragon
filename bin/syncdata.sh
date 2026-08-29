#!/bin/bash -eu

# Pull data files from one of my HandyNotes plugins into Data/<Expansion>/.
#
#   bin/syncdata.sh WarWithin ../HandyNotes_WarWithin
#   bin/syncdata.sh WarWithin ../HandyNotes_WarWithin --dry-run
#
# Data/<Expansion>/sync.files lists which plugin files to copy, one path per
# line relative to the plugin root. They land verbatim except that a
# `[coord] = { -- Some Name` label comment becomes a real `label="Some Name"`
# key, so the Browser has names without a live lookup.
#
# Everything SilverDragon-specific stays in files this never writes:
# module.lua (the curated RegisterMobData/RegisterTreasureData), and, once zone
# files are being carried, whatever lists them for load.

cd "$(dirname "$0")/.."

EXP=${1:?expansion folder name, e.g. WarWithin}
PLUGIN=${2:?path to the plugin checkout}
DRYRUN=${3:-}

DEST=Data/$EXP
MANIFEST=$DEST/sync.files

[ -d "$PLUGIN" ]   || { echo >&2 "no plugin checkout at $PLUGIN"; exit 1; }
[ -f "$MANIFEST" ] || { echo >&2 "no manifest at $MANIFEST"; exit 1; }

# Refuse only if something this script would overwrite is dirty. sync.files is
# an input you often edit right before running, and module.lua is never touched.
written=( "$DEST" ":(exclude)$DEST/sync.files" ":(exclude)$DEST/module.lua" )
if [ -z "$DRYRUN" ] && { ! git diff --quiet -- "${written[@]}" || ! git diff --cached --quiet -- "${written[@]}"; }; then
	echo >&2 "$DEST has uncommitted changes to files syncdata.sh writes; commit or stash them (or pass --dry-run)"
	exit 1
fi

# Manifest lines: drop CR (a CRLF checkout), the # comment, and blank lines.
strip() { tr -d '\r' | sed 's/#.*//' | awk 'NF'; }

# Warn if the plugin .toc gained a zones/ or shared/ file the manifest misses.
toc_data=$(grep -ohiE '^(zones|shared)\\[A-Za-z0-9_]+\.lua' "$PLUGIN"/*.toc \
           | tr 'A-Z\\' 'a-z/' | sort -u || true)
missing=$(comm -23 <(printf '%s\n' "$toc_data") <(strip < "$MANIFEST" | tr 'A-Z' 'a-z' | sort -u) || true)
if [ -n "$missing" ]; then
	echo >&2 "note: plugin .toc lists data files not in $MANIFEST:"
	printf >&2 '  %s\n' $missing
fi

# `[12345678] = { -- Some Name`  ->  `[12345678] = { label="Some Name",`
# The plugin convention is exactly `{ -- Name`; require the space so `--- x`
# and `{ --note` stay comments, and skip names with a quote in them.
labelfix='s|^([[:space:]]*\[[0-9]+\][[:space:]]*=[[:space:]]*\{)[[:space:]]*-- ([^"]*[^"[:space:]])[[:space:]]*$|\1 label="\2",|'

while IFS= read -r rel; do
	rel=${rel%%#*}; rel=${rel//$'\r'/}; rel=$(echo $rel)
	[ -n "$rel" ] || continue
	src=$PLUGIN/$rel
	[ -f "$src" ] || { echo >&2 "missing in plugin: $rel"; exit 1; }
	if [ -n "$DRYRUN" ]; then
		echo "would copy $rel"
		continue
	fi
	mkdir -p "$DEST/$(dirname "$rel")"
	# tr strips CR: the plugin checkouts are CRLF, and these land LF here.
	if [ "$rel" = "constants.lua" ]; then
		tr -d '\r' < "$src" > "$DEST/$rel"
	else
		sed -E "$labelfix" "$src" | tr -d '\r' > "$DEST/$rel"
	fi
done < "$MANIFEST"

if [ -z "$DRYRUN" ]; then
	git add "$DEST"
	echo
	echo "staged. review:  git diff --cached -- $DEST"
	echo "lint:            wsl.exe -e bash -lc 'cd /mnt/c/src/wow/SilverDragon && luacheck . --no-color -q'"
fi

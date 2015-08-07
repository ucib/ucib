debug "Formatting /data filesystem as btrfs..."

# Sigh... mkfs.btrfs turned on options that make the damned thing unrecognisable
# to older kernels.  YOU PEOPLE ARE MONSTERS
set +o pipefail
if mkfs.btrfs -h 2>&1 | grep -q -- -O; then
	btrfs_opts="-O ^extref"
fi
set -o pipefail

mkfs.btrfs $btrfs_opts -f "${PARTITIONS[/data]}" |& spin "Formatting '/data' filesystem"

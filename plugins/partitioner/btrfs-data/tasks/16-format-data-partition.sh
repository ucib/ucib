debug "Formatting /data filesystem as btrfs..."

mkfs.btrfs -f "${PARTITIONS[/data]}" |& spin "Formatting '/data' filesystem"

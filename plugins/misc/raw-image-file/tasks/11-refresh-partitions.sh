cleanup_refresh_partitions() {
	kpartx -d "$BLOCK_DEVICE"
}

register_cleanup "cleanup_refresh_partitions"

kpartx -s -a "$BLOCK_DEVICE"

# kpartx has a nasty habit of putting all its partitions under /dev/mapper,
# which, of course, the partitioner isn't expected to know.  So, we need to
# manually mangle the partition names to correspond to the kpartx-created
# names.
for partname in "${!PARTITIONS[@]}"; do
	debug "Converting $partname (${PARTITIONS[$partname]}) to kpartx-created device name"
	PARTITIONS[$partname]="/dev/mapper/$(basename "${PARTITIONS[$partname]}")"
done

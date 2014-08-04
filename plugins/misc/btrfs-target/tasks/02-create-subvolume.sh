btrfs subvolume create "$(optval dest)" >/dev/null

cleanup_btrfs_create_subvolume() {
	if [ "$BUILD_COMPLETE" != "y" ]; then
		btrfs subvolume delete "$(optval dest)"
	fi
}

register_cleanup cleanup_btrfs_create_subvolume

rmdir "$TARGET"
ln -s "$(optval dest)" "$TARGET"

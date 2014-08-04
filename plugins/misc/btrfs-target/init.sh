misc_btrfs_target_plugin_usage() {
	usage_section "btrfs Target"

	usage_description "Create the image in a btrfs subvolume"

	usage_option "--dest <dir>" \
	             "Specify the location where the new subvolume will be" \
	             "created.  Must be inside a btrfs filesystem."
}

register_usage "misc_btrfs_target_plugin_usage"

parseopt "dest" "true"

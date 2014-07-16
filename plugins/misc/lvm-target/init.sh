misc_lvm_target_plugin_usage() {
	usage_section "LVM Target"
	
	usage_description "Make the installation target an LVM logical volume"
	
	usage_option "--vgname <name>" \
	             "Create the LV on the specified VG"
	
	usage_option "--lvname <name>" \
	             "Create the LV with the specified name"
	
	usage_option "--lvsize <size>" \
	             "Create the LV with the specified size" \
	             "Anything accepted by lvcreate -L will be OK" \
	             "(default: 1G)"
	
	usage_option "--thinpool <pool>" \
	             "Create a thin LV, in the specified pool"
	
	usage_option "--fs <fsname>" \
	             "Format the LV with the specified filesystem" \
	             "(valid values: 'ext4', 'xfs', default 'ext4')"
}

register_usage "misc_lvm_target_plugin_usage"

parseopt "vgname" "true"
parseopt "lvname" "true"
parseopt "lvsize" "true" "1G"
parseopt "thinpool" "true"
parseopt "fs" "true" "ext4"

load_plugin_or_die "misc/$(optval fs)-filesystem"

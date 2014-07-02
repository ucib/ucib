cloud_lxc_usage() {
	usage_section "lxc container template"

	usage_description "This plugin builds an LXC container, either
	                  in a specified target directory, or in a logical
	                  volume."
}

register_usage "cloud_lxc_usage"

load_plugin_or_die "package/sshd"
load_plugin_or_die "package/sudo"

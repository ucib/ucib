cloud_lxc_usage() {
	usage_section "lxc container template"

	usage_description "This plugin builds an LXC container, either
	                  into a tarball, or directly into a logical
	                  volume."
	
	usage_option "--lvm" \
	             "Put the image directly into an LV" \
	             "(requires at least --lvname and --vgname options)"
}

register_usage "cloud_lxc_usage"

load_plugin_or_die "package/sshd"
load_plugin_or_die "package/sudo"

parseopt "lvm"

if [ "$(optval lvm)" = "true" ]; then
	load_plugin_or_die "misc/lvm-target"
fi

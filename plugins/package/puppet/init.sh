package_puppet_plugin_usage() {
	usage_section "Puppet Initialization"

	usage_description "This plugin installs Puppet packages and optionally
	                   clones a git repo into /etc/puppet."

	usage_option "--puppet-git-repo <URL>" \
	             "A git repo URL to clone into /etc/puppet"
}

register_usage "package_puppet_plugin_usage"

parseopt "puppet-git-repo" "true"


os_wheezy_plugin_usage() {
	usage_section "Debian Wheezy"
	
	usage_description "This plugin installs a very minimal Debian Wheezy
	                   (7.0)."
	
	usage_option "--arch <arch>" \
	             "The architecture to build for."      \
	             "(Default: amd64)"                    \
	             "Valid values are 'i386' or 'amd64'." \
	
	usage_option "--debootstrap-mirror <url>" \
	             "The URL from which debootstrap will get packages." \
	             "If not specified, this will default to the first"  \
	             "URL in the --apt-mirrors option."
	
	usage_option "--apt-mirrors '<url>[ <url>...]'" \
	             "A list of mirrors to use post-debootstrap." \
	             "(Default: http://http.debian.net/)"         \
	             "This option instructs the installer to"     \
	             "configure apt to download packages from"    \
	             "the given package mirror.  Multiple mirror" \
	             "URLs may be specified in a single option,"  \
	             "separated by spaces."
}

register_usage "os_wheezy_plugin_usage"

parseopt "arch" "true" "amd64"
parseopt "apt-mirrors" "true" "http://http.debian.net/"
first_mirror="$(echo "${OPTS[apt-mirrors]}" | cut -d ' ' -f 1)"
parseopt "debootstrap-mirror" "true" "$first_mirror"

load_plugin_or_die "partitioner/full-disk"
load_plugin_or_die "misc/ext4-filesystem"

install_packages_in_target() {
	run_in_target apt-get install "$@" | spin "Installing $*"
}

create_user() {
	local user="$1"
	local gecos="${2:-$user}"
	local pw="$3"
	
	run_in_target adduser --gecos "$gecos" \
	        --disabled-password --shell /bin/bash "$user" >/dev/null 2>&1

	if [ -n "$pw" ]; then
		echo "$user:$pw" | run_in_target chpasswd
	fi
}

dhcp_interface() {
	local if="$1"
	
	cat <<EOF >>"${TARGET}/etc/network/interfaces"
auto $if
iface $if inet dhcp
EOF
}

disable_consoles() {
	local keep1="$1"
	
	if [ -n "$keep1" ]; then
		sed -i 's/^\([2-6]:\)/#\1/' "${TARGET}/etc/inittab"
	else
		sed -i 's/^\([1-6]:\)/#\1/' "${TARGET}/etc/inittab"
	fi
}		

install_init_script() {
	local file="$1"
	
	debug "Installing '$file' as an init script"
	cp "$file" "${TARGET}/etc/init.d/"
	chmod 0755 "${TARGET}/etc/init.d/$(basename "$file")"
	run_in_target insserv -d "$(basename "$file")"
}

install_package_containing() {
	local file="$1"
	
	debug "Looking for a package containing '$file'"
	pkg="$(apt-file --sources-list "${TARGET}/etc/apt/sources.list" -l search "$file")"
	
	if [ -z "$pkg" ]; then
		return 1
	else
		install_packages_in_target $pkg
		return 0
	fi
}
	
set_hostname() {
	echo "$1" >"${TARGET}/etc/hostname"
}

set_password() {
	echo "$1:$2" | run_in_target chpasswd
}

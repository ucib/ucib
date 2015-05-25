os_jessie_plugin_usage() {
	usage_section "Debian Jessie (8.0)"
	
	usage_description "This plugin installs a very minimal Debian Jessie
	                   (8.0) system."
	
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

	usage_option "--proxy <url>" \
	             "Use the given URL as an HTTP proxy."

	usage_option "--extra-repo <repoline>" \
	             "Add an extra repo to the machine"

	usage_option "--apt-key-url <url>" \
	             "Install an APT key from the URL given"
}

register_usage "os_jessie_plugin_usage"

parseopt "arch" "true" "amd64"
parseopt "apt-mirrors" "true" "http://http.debian.net/debian"
first_mirror="$(echo "${OPTS[apt-mirrors]}" | cut -d ' ' -f 1)"
parseopt "debootstrap-mirror" "true" "$first_mirror"
parseopt "proxy" "true"

declare -a EXTRA_APT_REPOS
declare -a APT_KEY_URLS

parseopt "apt-key-url" "true"
while optval "apt-key-url" >/dev/null; do
	APT_KEY_URLS+=("$(optval apt-key-url)")
	parseopt "apt-key-url" "true"
done

parseopt "extra-repo" "true"
while optval "extra-repo" >/dev/null; do
	EXTRA_APT_REPOS+=("$(optval extra-repo)")
	parseopt "extra-repo" "true"
done

if optval proxy >/dev/null; then
	export http_proxy="$(optval proxy)"
fi

install_packages_in_target() {
	local orig_debian_frontend="$DEBIAN_FRONTEND"
	export DEBIAN_FRONTEND="noninteractive"
	run_in_target apt-get -y install "$@" | spin "Installing $*"
	export DEBIAN_FRONTEND="$orig_debian_frontend"
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
	
	if [ -n "$keep1" ]; then
		echo "NAutoVTs=1" >"${TARGET}/etc/systemd/logind.conf"
	else
		echo "NAutoVTs=0" >"${TARGET}/etc/systemd/logind.conf"
	fi
}		

install_init_script() {
	local file="$1"
	
	debug "Installing '$file' as a systemd service"
	
	if [ ! -e "${file}.service" ]; then
		fatal "No .service file available for $file"
	fi

	cp "$file" "${TARGET}/etc/init.d/"
	cp "${file}.service" "${TARGET}/etc/systemd/system/"
	chmod 0755 "${TARGET}/etc/init.d/$(basename "$file")"
	run_in_target systemctl enable "$(basename "$file")"
}

install_package_containing() {
	for file in "$@"; do
		debug "Looking for a package containing '$file'"
		pkg="$(run_in_target apt-file -l -x search "^$file\$")"

		if [ -n "$pkg" ]; then
			install_packages_in_target $pkg
			return 0
		fi
	done
	
	debug "No package found for any of: $@"
	return 1
}

install_kernel() {
	case "${OPTS[arch]}" in
		"amd64") kernel="linux-image-amd64";;
		"i386")  kernel="linux-image-686";;
		*)       fatal "Unknown architecture: ${OPTS[arch]}"
	esac
	
	install_packages_in_target "$kernel"
}
	
set_hostname() {
	echo "$1" >"${TARGET}/etc/hostname"
}

set_password() {
	echo "$1:$2" | run_in_target chpasswd
}

grant_full_sudo() {
	echo "$1 ALL=(ALL) NOPASSWD: ALL" >"${TARGET}/etc/sudoers.d/99_$1"
}
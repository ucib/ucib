wget --progress=dot -O "${WORKSPACE}/vbox.iso" http://download.virtualbox.org/virtualbox/4.3.8/VBoxGuestAdditions_4.3.8.iso |& spin "Downloading VBoxGuestAdditions ISO"

# I really don't want to clog up the rest of UCIB with this stuff, since I doubt any other
# targets are going to require development packages
if [ -e "${TARGET}/etc/debian_version" ]; then
	case "${OPTS[arch]}" in
		"amd64")
			install_packages_in_target linux-headers-amd64
			;;
		"i386")
			install_packages_in_target linux-headers-i686
			;;
		*)
			fatal "Unknown architecture: ${OPTS[arch]}"
	esac
elif [ -e "${TARGET}/etc/redhat-release" ]; then
	install_packages_in_target kernel-devel perl gcc
fi

mkdir "${TARGET}/vbox"

mount -o loop,ro "${WORKSPACE}/vbox.iso" "${TARGET}/vbox"

cleanup_mount_vbox_iso() {
	umount -f "${TARGET}/vbox"
	rmdir "${TARGET}/vbox"
}

register_cleanup "cleanup_mount_vbox_iso"

# This is supposed to fail, because installing the additions *requires* the
# current kernel to be the one you want to build against.  The proper build
# will happen on first boot, because we add a haxxed up vboxadd init script.
run_in_target "/vbox/VBoxLinuxAdditions.run" |& spin "Installing VBox Guest Additions" || true

cp $(plugin_file cloud/vagrant-virtualbox init-scripts/vboxadd) "${TARGET}/etc/init.d/"

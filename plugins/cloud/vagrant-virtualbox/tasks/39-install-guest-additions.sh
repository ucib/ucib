wget --progress=dot -O "${WORKSPACE}/vbox.iso" http://download.virtualbox.org/virtualbox/4.3.8/VBoxGuestAdditions_4.3.8.iso |& spin "Downloading VBoxGuestAdditions ISO"

# I really don't want to clog up the rest of UCIB with this stuff, since I doubt any other
# targets are going to require development packages
if [ -e "${TARGET}/etc/debian_version" ]; then
	target_kernel_ver="$(run_in_target dpkg -l linux-image-*-* | grep ^ii | cut -d ' ' -f 3 | sed 's/^linux-image-//')"

	if [ -z "$target_kernel_ver" ]; then
		fatal "No kernel version found.  Something is very wrong here."
	fi

	headers_pkg="linux-headers-${target_kernel_ver}"
	run_in_target apt-get -y install build-essential dkms $headers_pkg |& spin "Installing build environment"

	# This is exceedingly fucked up... VirtualBox provides no capability
	# to build the modules it needs for a kernel other than what is
	# currently running, and even if you do manage to hack around that,
	# it tries to immediately load them into the running kernel, which
	# you can *guarantee* is going to fail spectacularly.  The only way
	# I can work out to get around it is to just skip the build, ignore the
	# attempt to load the module, and pray like fuck it works on next boot.
	#
	# Annoyingly, this means that I've got to leave the kernel headers,
	# build-essential, and the rest of it all installed on the image,
	# making it *significantly* larger.
	cat <<-EOF >"${TARGET}/usr/local/sbin/dkms"
#!/bin/sh

exit 0
fi
EOF
	chmod 0555 "${TARGET}/usr/local/sbin/dkms"
fi

mkdir "${TARGET}/vbox"

mount -o loop,ro "${WORKSPACE}/vbox.iso" "${TARGET}/vbox"

cleanup_mount_vbox_iso() {
	umount -f "${TARGET}/vbox"
	rmdir "${TARGET}/vbox"
}

register_cleanup "cleanup_mount_vbox_iso"

# This is supposed to fail
run_in_target "/vbox/VBoxLinuxAdditions.run" |& spin "Installing VBox Guest Additions" || true

if [ -e "${TARGET}/etc/debian_version" ]; then
	rm -f "${TARGET}/usr/local/sbin/dkms"
fi

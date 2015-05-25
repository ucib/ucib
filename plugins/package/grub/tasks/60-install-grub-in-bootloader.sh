mkdir -p "${TARGET}/boot/grub"

cleanup_grub1_install() {
	kpartx -d /dev/mapper/hda
	dmsetup remove hda
}

# Temporary device.map for grub installation purposes
echo "(hd0) $BLOCK_DEVICE" >"${TARGET}/boot/grub/device.map"

if [ -n "${PARTITIONS[/boot]}" ]; then
	prefix="(,1)/grub"
else
	prefix="(,1)/boot/grub"
fi

if run_in_target grub-install --version | grep -q "1\\.99"; then
	cp "${TARGET}/usr/lib/grub/i386-pc/"* "${TARGET}/boot/grub/"

	run_in_target grub-mkimage -d /usr/lib/grub/i386-pc -O i386-pc    \
	   --output=/boot/grub/core.img --prefix="$prefix"                \
	   biosdisk ext2 part_msdos

	run_in_target grub-setup -d /boot/grub --root-device='(hd0)' "$BLOCK_DEVICE"

	# Final, real device.map for boot
	echo "(hd0) /dev/vda" >"${TARGET}/boot/grub/device.map"

	case "${PARTITIONS[/]}" in
		/dev/mapper/loop*)
			grub_device="$(echo "${PARTITIONS[/]}" | sed 's%^/dev/mapper/loop[0-9][0-9]*p%/dev/vda%')"
			;;
		/dev/*/*)
			grub_device="$(echo "${PARTITIONS[/]}" |
			               sed 's%/dev/\(.*\)/\(.*\)$%/dev/mapper/\1___\2%;
			                    s/-/--/; s/___/-/')"
			;;
		*)
			grub_device="${PARTITIONS[/]}"
	esac

	echo "GRUB_DEVICE=$grub_device" >> "${TARGET}/etc/default/grub"
elif run_in_target grub-install --version | grep -q "2\\."; then
	run_in_target grub-install /dev/loop0

	# Final, real device.map for boot
	echo "(hd0) /dev/vda" >"${TARGET}/boot/grub/device.map"
elif run_in_target grub-install --version | grep -q "0\\.97"; then
	# Oh *man*... I thought grub2 was weird

	register_cleanup cleanup_grub1_install

	# http://ebroder.net/2009/08/04/installing-grub-onto-a-disk-image/
	# gave me the nasty details of this one

	blocks=$(($(optval image-size) * 2097152))
	maj_num=$((0x$(stat -c %t "$BLOCK_DEVICE")))
	min_num=$((0x$(stat -c %T "$BLOCK_DEVICE")))

	echo "0 $blocks linear $maj_num:$min_num 0" | dmsetup create hda
	kpartx -a /dev/mapper/hda

	# Setup some dummy files
	echo "(hd0) /dev/mapper/hda" >"${TARGET}/boot/grub/device.map"
	echo "/dev/mapper/hda1 / ext4 defaults 0 0" >"${TARGET}/etc/mtab"

	run_in_target /sbin/grub-install /dev/mapper/hda >/dev/null 2>&1

	# Replace with a real device.map
	echo "(hd0) /dev/vda" >"${TARGET}/boot/grub/device.map"
	rm -f "${TARGET}/etc/mtab"
else
	fatal "Unknown version of GRUB installed.  Bailing."
fi

info "GRUB installed"

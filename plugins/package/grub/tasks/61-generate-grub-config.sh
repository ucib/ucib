if [ -x "${TARGET}/usr/sbin/update-grub" ]; then
	run_in_target "/usr/sbin/update-grub"
else
	if ! [ -e "${TARGET}/etc/grub.conf" ]; then
		ln -s "/boot/grub/grub.conf" "${TARGET}/etc/grub.conf"
	fi
	
	if ! [ -e "${TARGET}/boot/grub/menu.lst" ]; then
		ln -s "/boot/grub/grub.conf" "${TARGET}/boot/grub/menu.lst"
	fi
	
	if ! [ -e "${TARGET}/boot/grub/grub.conf" ]; then
		kernel="$(basename $(ls "${TARGET}/boot/"vmlinuz*))"
		if [ -z "$kernel" ]; then
			fatal "No kernel found"
		fi
		
		initrd="$(basename $(ls "${TARGET}/boot/"init*img*))"
		if [ -z "$initrd" ]; then
			fatal "No initrd found"
		fi
		
		cat <<EOF >"${TARGET}/boot/grub/grub.conf"
default=0
timeout=1
title Linux
	root (hd0,0)
	kernel /boot/$kernel ro root=/dev/vda1
	initrd /boot/$initrd
EOF
	fi
fi

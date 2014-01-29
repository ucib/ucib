cleanup_mount_specials() {
	umount "${TARGET}/dev/pts"
	umount "${TARGET}/sys"
	umount "${TARGET}/proc"
	umount "${TARGET}/dev"
}

register_cleanup "cleanup_mount_specials"

mkdir -p "${TARGET}/dev"
mount --bind /dev "${TARGET}/dev"
run_in_target mount -t proc none /proc
run_in_target mount -t sysfs none /sys
run_in_target mount -t devpts none /dev/pts

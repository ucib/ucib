if ! [ "$(optval lvm)" = "y" -o "$(optval btrfs)" = "y" ]; then
	tar cjf "${OPTS[name]}.tar.bz2" -C "$TARGET" .
fi

if ! [ "$(optval lvm)" = "y" ] && [ "$(optval btrfs)" = "y" ]; then
	tar cjf "${OPTS[name]}.tar.bz2" -C "$TARGET" .
fi

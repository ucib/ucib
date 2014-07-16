if ! optval lvm >/dev/null; then
	tar cjf "${OPTS[name]}.tar.bz2" -C "$TARGET" .
fi

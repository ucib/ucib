if ! [ "$(optval lvm)" = "true" ]; then
	tar cjf "${OPTS[name]}.tar.bz2" -C "$TARGET" .
fi

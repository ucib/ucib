if ! optval vgname >/dev/null; then
	fatal "--vgname must be specified"
fi

if ! optval lvname >/dev/null; then
	fatal "--lvname must be specified"
fi

if ! vgs $(optval vgname) >/dev/null 2>&1; then
	fatal "VG '$(optval vgname)' does not exit"
fi

if lvs $(optval vgname)/$(optval lvname) >/dev/null 2>&1; then
	fatal "LV '$(optval vgname)/$(optval lvname)' already exists"
fi

if optval thinpool >/dev/null; then
	lvcreate "-V$(optval lvsize)" --thinpool "$(optval thinpool)" \
	         -n "$(optval lvname)" "$(optval vgname)" |& \
	         logpipe "lvcreate"
else
	lvcreate "-L$(optval lvsize)" -n "$(optval lvname)" \
	         "$(optval vgname)" |& logpipe "lvcreate"
fi

declare -A PARTITIONS
PARTITIONS[/]="/dev/$(optval vgname)/$(optval lvname)"

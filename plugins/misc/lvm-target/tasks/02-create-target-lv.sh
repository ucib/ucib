if optval thinpool >/dev/null; then
	lvcreate "-V$(optval lvsize)" --thinpool "$(optval thinpool)" \
	         -n "$(optval lvname)" "$(optval vgname)"
else
	lvcreate "-L$(optval lvsize)" -n "$(optval lvname)" "$(optval vgname)"
fi

declare -A PARTITIONS
PARTITIONS[/]="/dev/$(optval vgname)/$(optval lvname)"

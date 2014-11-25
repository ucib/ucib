cleanup_init_lvm() {
	vgchange -an "${OPTS[name]}" || true
}

register_cleanup "cleanup_init_lvm"

# 2GB root LV, leave the rest empty
pvcreate "${PARTITIONS[PV]}" >/dev/null
vgcreate "${OPTS[name]}" "${PARTITIONS[PV]}" >/dev/null
lvcreate -L2G -n root "${OPTS[name]}" >/dev/null

PARTITIONS[/]="/dev/${OPTS[name]}/root"

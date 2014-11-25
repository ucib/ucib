# 128MB /boot, the rest an LVM PV
sfdisk -f -u S "$BLOCK_DEVICE" <<EOF >/dev/null 2>&1
2048,262144,83
264192,,8e
EOF

declare -A PARTITIONS

PARTITIONS[/boot]="${BLOCK_DEVICE}p1"
PARTITIONS[PV]="${BLOCK_DEVICE}p2"

# LVs get created *after* the block device has appeared

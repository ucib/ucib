debug "Formatting all filesystems for ext4..."

for part in "${!PARTITIONS[@]}"; do
	if ! [[ "$part" =~ ^/ ]]; then
		# Not a regular filesystem partition; leave it alone
		continue
	fi
	
	mkfs.ext4 "${PARTITIONS[$part]}" |& spin "Formatting '$part' filesystem"
	tune2fs -i 0 "${PARTITIONS[$part]}" >/dev/null 2>&1
done

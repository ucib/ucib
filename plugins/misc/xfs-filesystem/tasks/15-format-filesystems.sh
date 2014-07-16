debug "Formatting all filesystems for xfs..."

for part in "${!PARTITIONS[@]}"; do
	if ! [[ "$part" =~ ^/ ]]; then
		# Not a regular filesystem partition; leave it alone
		continue
	fi

	mkfs.xfs "${PARTITIONS[$part]}" |& spin "Formatting '$part' filesystem"
done

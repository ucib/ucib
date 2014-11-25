if [ -z "$PARTITIONER_DEFINED" ]; then
	load_plugin_or_die "partitioner/full-disk"
fi

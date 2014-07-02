if [ -x "${TARGET}/etc/puppet/run" ]; then
	install_init_script "$(plugin_file package/puppet init-scripts/run-puppet)"
fi

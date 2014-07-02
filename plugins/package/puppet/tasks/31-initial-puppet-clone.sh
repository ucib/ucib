if [ -n "${OPTS[puppet-git-repo]}" ]; then
	rm -rf "${TARGET}/etc/puppet"
	git clone "${OPTS[puppet-git-repo]}" "${TARGET}/etc/puppet"
fi

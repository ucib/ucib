cleanup_disable_daemons() {
	rm -f "${TARGET}/usr/sbin/policy-rc.d"
}

register_cleanup "cleanup_disable_daemons"

cat <<EOF >"${TARGET}/usr/sbin/policy-rc.d"
#!/bin/sh

exit 101
EOF
chmod 0755 "${TARGET}/usr/sbin/policy-rc.d"

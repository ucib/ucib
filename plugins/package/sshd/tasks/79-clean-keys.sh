shred --remove "${TARGET}/etc/ssh/ssh_host_"{dsa,rsa,ecdsa}_key{,.pub} >/dev/null 2>&1 || true

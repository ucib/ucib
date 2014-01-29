# Privileged access to hashed passwords
run_in_target shadowconfig on >/dev/null

# Disallow password authentication, public/private key only
sed -i -e 's/^#PasswordAuthentication yes/PasswordAuthentication no/' "${TARGET}/etc/ssh/sshd_config"

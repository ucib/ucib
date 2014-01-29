# Disallow password authentication, public/private key only
sed -i -e 's/^#PasswordAuthentication yes/PasswordAuthentication no/' "${TARGET}/etc/ssh/sshd_config"

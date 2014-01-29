create_user "vagrant" "Base Vagrant user"

echo "vagrant ALL=(ALL) NOPASSWD: ALL" >"${TARGET}/etc/sudoers.d/99_vagrant"
        
mkdir -p "${TARGET}/home/vagrant/.ssh"
cat <<EOF >"${TARGET}/home/vagrant/.ssh/authorized_keys"
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
EOF
        
# Do this in the chroot so we've got the UID/name mapping available
run_in_target chown -R vagrant:vagrant /home/vagrant/.ssh
        
# Don't require a TTY to sudo
sed -i '/^Defaults requiretty/d' ${TARGET}/etc/sudoers

qemu-img convert -f raw -O qcow2 "$IMAGEFILE" "${WORKSPACE}/box.img"

cat <<EOF >"${WORKSPACE}/metadata.json"
{
  "provider":     "libvirt",
  "format":       "qcow2",
  "virtual_size": "${OPTS[image-size]}"
}
EOF
cat <<EOF >"${WORKSPACE}/Vagrantfile"
Vagrant.configure("2") do |config|
  # You really should be configuring libvirt in your own Vagrantfile
end
EOF

tar cf - -C "$WORKSPACE" ./metadata.json ./Vagrantfile ./box.img |pigz -c >"${OPTS[name]}.box"

info "Your box is now available in '${OPTS[name]}.box'"

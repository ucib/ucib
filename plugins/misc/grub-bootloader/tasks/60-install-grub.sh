mkdir -p "${TARGET}/boot/grub"

cp "${TARGET}/usr/lib/grub/i386-pc/"* "${TARGET}/boot/grub/"

# Temporary device.map for grub installation purposes
echo "(hd0) $BLOCK_DEVICE" >"${TARGET}/boot/grub/device.map"

run_in_target grub-mkimage -d /usr/lib/grub/i386-pc -O i386-pc    \
   --output=/boot/grub/core.img --prefix="(,1)/boot/grub"         \
   biosdisk ext2 part_msdos
          
run_in_target grub-setup -d /boot/grub --root-device='(hd0)' "$BLOCK_DEVICE"
          
# Final, real device.map for boot
echo "(hd0) /dev/vda" >"${TARGET}/boot/grub/device.map"
          
echo "GRUB_DEVICE=/dev/vda1" >> "${TARGET}/etc/default/grub"

# Update grub.cfg using the script
run_in_target update-grub >/dev/null 2>&1

# Alias grub.cfg as menu.lst
run_in_target ln -s /boot/grub/grub.cfg /boot/grub/menu.lst

info "GRUB installed"

echo "$(disk_partition 1) / ext4 defaults 0 1" >>${TARGET}/etc/fstab
echo "$(disk_partition 2) /data btrfs defaults 0 2" >>${TARGET}/etc/fstab

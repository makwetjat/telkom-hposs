#!/bin/bash

# Check if LVM /dev/mapper/vg_misc-tsanas exists
if [ -e "/dev/mapper/vg_misc-tsanas" ]; then
    # Unmount /tsanas/users/tooladm
    umount /tsanas/users/tooladm
    
    # Remove logical volume
    lvremove --force /dev/mapper/vg_misc-tsanas
fi
# Comment out line in /etc/fstab if it exists
if grep -q "/dev/vg_misc/tsanas /tsanas/users/tooladm" /etc/fstab; then
    sed -i '/\/dev\/vg_misc\/tsanas \/tsanas\/users\/tooladm/s/^/#/' /etc/fstab
fi
# Delete user and group if user tooladm exists
if id "tooladm" &>/dev/null; then
    userdel tooladm
    groupdel aimsys
fi
# Create group aimsys with GID 16700
groupadd -g 16700 aimsys
# Add new entry in /etc/fstab
echo "10.227.243.101:/tsanas/users /tsanas/users/tooladm nfs soft,bg,rw,nosuid,retry=4 0 2" >> /etc/fstab
# Mount all filesystems mentioned in /etc/fstab
mount -a
# Add user tooladm with specific UID and other settings
useradd -g aimsys -u 101675 -s /bin/ksh -d /tsanas/users/tooladm tooladm
# Change password for user tooladm
echo "Telkom_123" | passwd --stdin tooladm
# Change permissions
chmod 755 /tsanas
chmod 755 /tsanas/users

#!/bin/bash

# Check if user is root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Change password for user tooladm
echo "Changing password for user tooladm"
echo "tooladm:Telkom_123" | chpasswd

if [ $? -eq 0 ]; then
    echo "Password changed successfully"
else
    echo "Failed to change password" 1>&2
    exit 1
fi


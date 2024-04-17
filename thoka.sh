#!/bin/bash

# Function to check if a user exists in /etc/passwd
user_exists_in_passwd() {
    local username=$1
    grep -E "^${username}:" /etc/passwd &>/dev/null
}

# Function to check if a user exists in sudoers file
user_exists_in_sudoers() {
    local username=$1
    sudo grep -E "^[[:space:]]*${username}[[:space:]]+ALL" /etc/sudoers &>/dev/null
}

# Check if users 'bastion' and 'tooladm' exist in /etc/passwd
if user_exists_in_passwd "bastion" && user_exists_in_passwd "tooladm"; then
    # Check if users 'bastion' and 'tooladm' already exist in sudoers
    if user_exists_in_sudoers "bastion" && user_exists_in_sudoers "tooladm"; then
        echo "Users 'bastion' and 'tooladm' already exist in sudoers."
    else
        # Add users to sudoers
        echo "Adding users 'bastion' and 'tooladm' to sudoers..."
        sudo bash -c 'echo "bastion ALL=NOPASSWD:ALL" >> /etc/sudoers'
        sudo bash -c 'echo "tooladm ALL=NOPASSWD:ALL" >> /etc/sudoers'

        # Check if users were successfully added to sudoers
        if [ $? -eq 0 ]; then
            echo "Users added to sudoers successfully."
        else
            echo "Error: Failed to add users to sudoers."
            exit 1
        fi
    fi
else
    echo "Error: Users 'bastion' and 'tooladm' do not exist in /etc/passwd."
    exit 1
fi


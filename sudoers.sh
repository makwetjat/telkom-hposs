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

# Check if users 'USER1' and 'USER2' exist in /etc/passwd
if user_exists_in_passwd "USER1" && user_exists_in_passwd "USER2"; then
    # Check if users 'USER1' and 'USER2' already exist in sudoers
    if user_exists_in_sudoers "USER1" && user_exists_in_sudoers "USER2"; then
        echo "Users 'USER1' and 'USER2' already exist in sudoers."
    else
        # Add users to sudoers
        echo "Adding users 'USER1' and 'USER2' to sudoers..."
        sudo bash -c 'echo "USER1 ALL=NOPASSWD:ALL" >> /etc/sudoers'
        sudo bash -c 'echo "USER2 ALL=NOPASSWD:ALL" >> /etc/sudoers'

        # Check if users were successfully added to sudoers
        if [ $? -eq 0 ]; then
            echo "Users added to sudoers successfully."
        else
            echo "Error: Failed to add users to sudoers."
            exit 1
        fi
    fi
else
    echo "Error: Users 'USER1' and 'USER2' do not exist in /etc/passwd."
    exit 1
fi


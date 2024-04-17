#!/bin/bash

# Prompt for username
username=ssh-username
hostname=HOSTNAME
password=ssh-password

# Path to local script
local_script="sudoers.sh"

# Path to remote directory
remote_dir="/tmp/"

# Copy local script to remote server
echo "Copying script to $username@$hostname:$remote_dir"
sshpass -p "$password" scp -o StrictHostKeyChecking=no "$local_script" "$username@$hostname:$remote_dir"

# Check if SCP was successful
if [ $? -eq 0 ]; then
    echo "Script copied successfully."
else
    echo "Error: Script copy failed."
    exit 1
fi

# Execute the remote script
echo "Executing remote script..."
sshpass -p "$password" ssh -o StrictHostKeyChecking=no "$username@$hostname" "bash $remote_dir/sudoers.sh"

# Check if SSH was successful
if [ $? -eq 0 ]; then
    echo "Remote script executed successfully."

    # Remove the remote script
    echo "Removing remote script..."
    sshpass -p "$password" ssh -o StrictHostKeyChecking=no "$username@$hostname" "rm $remote_dir/sudoers.sh"
    
    # Check if removal was successful
    if [ $? -eq 0 ]; then
        echo "Remote script removed successfully."
    else
        echo "Error: Remote script removal failed."
        exit 1
    fi
else
    echo "Error: Remote script execution failed."
    exit 1
fi

exit 0


#!/bin/bash

# Directory path
DIRECTORY="/tsanas"

# Check if the directory exists
if [ -d "$DIRECTORY" ]; then
    # Get current ownership of the directory
    CURRENT_OWNER=$(stat -c "%U:%G" "$DIRECTORY")

    # Check if ownership is already set to tooladm:aimsys
    if [ "$CURRENT_OWNER" = "tooladm:aimsys" ]; then
        echo "Ownership of $DIRECTORY is already set to tooladm:aimsys"
    else
        # Check if the user tooladm exists
        if id "tooladm" &>/dev/null; then
            # Change ownership recursively
            sudo chown -R tooladm:aimsys "$DIRECTORY"
            echo "Ownership of $DIRECTORY and its contents changed to tooladm:aimsys"
        else
            echo "User tooladm does not exist"
        fi
    fi
else
    echo "Directory $DIRECTORY does not exist"
fi


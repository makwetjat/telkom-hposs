#!/bin/bash

# Check if the system is already registered
if sudo subscription-manager identity &>/dev/null; then
    echo "The system is already registered."
else
    # Register the system
    echo "Registering the system..."
    sudo subscription-manager clean
    sudo subscription-manager register --org="Hposs-ONECLOUD" --activationkey="BSS"

    # Check registration status
    if [ $? -eq 0 ]; then
        echo "Registration successful."
    else
        echo "Error: Registration failed."
        exit 1
    fi
fi


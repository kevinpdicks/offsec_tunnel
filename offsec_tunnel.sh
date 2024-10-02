#!/bin/bash

# Check if the script is run as root; if not, prompt for sudo
if [[ $EUID -ne 0 ]]; then
   echo "This script requires sudo privileges."
   exit 1
fi

# Now we can safely display the status of tun0 since we have sudo privileges
echo "Current status of tun0:"
ip link show tun0

# Check if tun0 is up
if ! ip link show tun0 | grep -q "UP"; then
   echo "Error: tun0 is down. Please ensure it's up before running this script."
   exit 1
fi

# Now tun0 is confirmed to be up, proceed with the rest of the script
echo "tun0 is up. Proceeding with the script."

# Execute the commands and display messages only when run with sudo
echo "Setting tun0 mtu to 1250"
ifconfig tun0 mtu 1250

echo "Adding 8.8.8.8 to /etc/resolv.conf"
bash -c "echo nameserver 8.8.8.8 > /etc/resolv.conf"

echo "Adding 8.8.4.4 to /etc/resolv.conf"
bash -c "echo nameserver 8.8.4.4 >> /etc/resolv.conf"

# Display completion message only when run with sudo
echo "All commands have been executed."

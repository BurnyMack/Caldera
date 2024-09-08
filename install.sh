#!/bin/bash

function print_msg {
    echo -e "\e[32m$1\e[0m"
}
print_msg "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y
print_msg "Creating directory /opt/caldera and navigating into it..."
sudo mkdir -p /opt/caldera
cd /opt/caldera
print_msg "Installing Caldera..."
sudo apt install caldera -y
print_msg "Starting Caldera server..."
sudo systemctl start caldera
print_msg "Enabling Caldera to start on boot..."
sudo systemctl enable caldera
print_msg "Caldera is installed and running! Access it via http://localhost:8888"
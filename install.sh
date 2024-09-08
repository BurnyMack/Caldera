#!/bin/bash

# Install.sh script for MITRE Caldera installation.

function print_msg {
    echo -e "\e[32m$1\e[0m"
}

function command_exists {
    command -v "$1" >/dev/null 2>&1
}

# Check for installs
print_msg "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y
if command_exists git; then
    print_msg "Git is already installed."
else
    print_msg "Installing Git..."
    sudo apt install -y git
fi

if command_exists python3; then
    print_msg "Python3 is already installed."
else
    print_msg "Installing Python3..."
    sudo apt install -y python3 python3-venv
fi

if command_exists pip3; then
    print_msg "pip3 is already installed."
else
    print_msg "Installing pip3..."
    sudo apt install -y python3-pip
fi


print_msg "Creating directory /opt/caldera and navigating into it..."
sudo mkdir -p /opt/caldera
cd /opt/caldera
print_msg "Cloning the Caldera repository..."
sudo git clone https://github.com/mitre/caldera.git --recursive
cd caldera
print_msg "Creating and activating a Python virtual environment..."
python3 -m venv venv
source venv/bin/activate
print_msg "Installing Caldera dependencies..."
pip install -r requirements.txt
print_msg "Installing additional plugins..."
cd plugins
git clone https://github.com/mitre/stockpile.git
git clone https://github.com/mitre/atomic.git
print_msg "Running Caldera..."
python3 server.py --insecure &
print_msg "Caldera is installed and running! Access it via http://localhost:8888"
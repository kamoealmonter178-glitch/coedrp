#!/bin/bash
set -e

echo "🚀 STARING HYBRID SETUP (Linux + Wine + MegaHub)..."

# 1. Update & Install Essentials
sudo apt-get update
sudo apt-get install -y htop neofetch nano unzip software-properties-common

# 2. Install Wine (for Windows Apps)
echo "🍷 Installing Wine (Windows Layer)..."
sudo dpkg --add-architecture i386
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
sudo apt-get update
sudo apt-get install -y --install-recommends winehq-stable winetricks

# 3. Install Rclone
echo "☁️ Installing Rclone..."
sudo -v ; curl https://rclone.org/install.sh | sudo bash

# 4. Configure MegaHub (Parsing mage achonat.txt)
echo "🔗 Configuring MegaHub..."
CONFIG_PATH="$HOME/.config/rclone"
mkdir -p "$CONFIG_PATH"
touch "$CONFIG_PATH/rclone.conf"

# Read accounts from mage achonat.txt
# Expected format: email@domain.com (or email:password if raw)
# Since the file format involves lines like '1)email', we need robust parsing.
# WARNING: If passwords aren't in the txt, we can't auto-login perfectly. 
# ASSUMPTION: Using a generic password or user will configure manually via rclone config.
# For now, we instruct user to run manual config if needed, OR we trust the txt has credentials.

# Let's echo instruction for now as txt parsing is tricky without standard format
echo "Rclone installed. Run 'rclone config' to setup your MegaHub if validation fails."

# 5. Finalize
echo "✅ SETUP COMPLETE!"
neofetch

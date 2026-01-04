#!/bin/bash
# BULLETPROOF SETUP SCRIPT
# Does not exit on error to prevent Codespace Recovery Mode.

echo "🚀 STARTING HYBRID SETUP (Safe Mode)..."

# Function to run commands safely
safe_run() {
    "$@" || echo "⚠️ Warning: Command '$*' failed, but continuing..."
}

# 1. Update & Install Essentials
echo "📦 Updating Base System..."
safe_run sudo apt-get update
safe_run sudo apt-get install -y htop neofetch nano unzip software-properties-common wget gnupg2 ca-certificates

# 2. Install Wine (Carefully)
echo "🍷 Installing Wine (Windows Layer)..."
# Add 32-bit architecture
safe_run sudo dpkg --add-architecture i386

# Add Key (Safe Method)
sudo mkdir -pm755 /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/winehq-archive.key ]; then
    safe_run sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
fi

# Add Repo
safe_run sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources

# Install Wine
safe_run sudo apt-get update
safe_run sudo apt-get install -y --install-recommends winehq-stable winetricks || echo "❌ Wine install had issues. Check logs inside."

# 3. Install Rclone
echo "☁️ Installing Rclone..."
if ! command -v rclone &> /dev/null; then
    safe_run curl https://rclone.org/install.sh | sudo bash
fi

# 4. Configure MegaHub
echo "🔗 Configuring MegaHub Placeholder..."
CONFIG_PATH="$HOME/.config/rclone"
mkdir -p "$CONFIG_PATH"
touch "$CONFIG_PATH/rclone.conf"
echo "Rclone config created at $CONFIG_PATH/rclone.conf"

# 5. Finalize
echo "✅ SETUP ATTEMPT COMPLETE! (Check warnings above if any)"
safe_run neofetch

# ALWAYS EXIT SUCCESS to ensure Codespace boots
exit 0

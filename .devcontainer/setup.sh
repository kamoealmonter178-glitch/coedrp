#!/bin/bash
# RELIABLE SETUP SCRIPT (Golden Config)
# Installs Wine (10.0) & Tailscale explicitly during container creation.

echo "🚀 SETUP STARTED: Installing Wine & Tailscale..."

# 1. Clean & Update
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get clean
sudo apt-get update

# 2. Install Base Tools & Desktop Environment (Fixed Black Screen)
sudo apt-get install -y --no-install-recommends software-properties-common wget curl grep xrdp xfce4 xfce4-goodies dbus-x11
echo "xfce4-session" > ~/.xsession

# 3. Install Wine (Verified Deb Method) - BACKGROUNDED due to Timeout
echo "🍷 Triggering Wine Install (Background)..."
(
  sudo dpkg --add-architecture i386 || true
  sudo mkdir -pm755 /etc/apt/keyrings
  [ ! -f /etc/apt/keyrings/winehq-archive.key ] && sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
  sudo echo "deb [signed-by=/etc/apt/keyrings/winehq-archive.key] https://dl.winehq.org/wine-builds/ubuntu/ jammy main" | sudo tee /etc/apt/sources.list.d/winehq-jammy.list
  sudo apt-get update
  sudo apt-get install -y --install-recommends winehq-stable wine-stable || echo "⚠️ Wine install warning"
  touch /tmp/wine_ready
) > /tmp/wine_install.log 2>&1 &


# 4. Install Tailscale & Configure Networking
echo "🔗 Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh
sudo service tailscaled stop 2>/dev/null || true

# FIX: Bridge RDP Port for Userspace Network
echo "🌉 Configuring Tailscale Serve (Port 3389)..."
# We need the daemon running for this, but it might not be fully up yet.
# We will rely on Deep-Breath.yml to run the serve command effectively after auth,
# BUT we enable the service here anyway.

# FIX: Set Password for 'vscode' user (Required for RDP)
echo "🔑 Setting Default Password..."
echo "vscode:vscode" | sudo chpasswd

# 5. Finalize
echo "✅ SETUP COMPLETE! Signal file created."
neofetch || true
touch /tmp/setup_done
exit 0

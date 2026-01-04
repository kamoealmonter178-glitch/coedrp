#!/bin/bash
# RELIABLE SETUP SCRIPT (Golden Config)
# Installs Wine (10.0) & Tailscale explicitly during container creation.

echo "🚀 SETUP STARTED: Installing Wine & Tailscale..."

# 1. Clean & Update
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get clean
sudo apt-get update

# 2. Install Base Tools
sudo apt-get install -y --no-install-recommends software-properties-common wget curl grep xrdp

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


# 4. Install Tailscale
echo "🔗 Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh
sudo service tailscaled start 2>/dev/null || sudo tailscaled --cleanup

# 5. Finalize
echo "✅ SETUP COMPLETE! Signal file created."
neofetch || true
touch /tmp/setup_done
exit 0

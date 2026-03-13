#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Starting macOS dotfiles setup..."

# Install Nix (Determinate Systems installer)
if ! command -v nix &> /dev/null; then
    echo "📦 Installing Nix..."
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
    
    # Source Nix
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
    echo "✅ Nix already installed"
fi

# Clone dotfiles if not already present
if [ ! -d "$HOME/dotfiles" ]; then
    echo "📥 Cloning dotfiles repository..."
    git clone https://github.com/marijnvanderhorst/dotfiles.git "$HOME/dotfiles"
else
    echo "✅ Dotfiles repository already present"
fi

# Get current hostname and username
HOSTNAME=$(scutil --get LocalHostName)
USERNAME=$(whoami)

echo ""
echo "🔍 Detected configuration:"
echo "  Hostname: $HOSTNAME"
echo "  Username: $USERNAME"
echo ""

# Install nix-darwin and apply configuration
echo "🔧 Installing nix-darwin and applying configuration..."
echo "⏳ This may take 10-30 minutes on first run..."
echo ""

nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake "$HOME/dotfiles#$HOSTNAME"

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "  1. Sign into Mac App Store (required for mas apps)"
echo "  2. Configure Bitwarden and enable SSH agent"
echo "  3. Set up JetBrains Toolbox and install IDEs"
echo "  4. Configure VSCode Settings Sync"
echo "  5. Review and customize configurations in ~/dotfiles"
echo ""
echo "💡 Useful commands:"
echo "  Update system:  darwin-rebuild switch --flake ~/dotfiles"
echo "  Update packages: cd ~/dotfiles && nix flake update"
echo "  Edit config:    vim ~/dotfiles/darwin-configuration.nix"
echo ""

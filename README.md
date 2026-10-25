# macOS Dotfiles

Declarative macOS system configuration using nix-darwin, Home Manager, and Homebrew.

This repository serves as the single source of truth for system configuration, similar to how Terraform manages infrastructure as code.

## Features

- **Declarative System Configuration**: macOS preferences managed via nix-darwin
- **Package Management**: Nix packages for CLI tools, Homebrew for GUI apps
- **Dotfiles Management**: User configurations managed via Home Manager
- **Reproducible**: Clone repo and rebuild entire system state
- **Rollback Support**: Revert to previous configurations if needed

## What's Managed

### System Configuration (nix-darwin)
- macOS system preferences (Dock, Finder, keyboard, etc.)
- System-wide packages
- Shell environment

### User Configuration (Home Manager)
- Git configuration
- Zsh shell configuration
- Application dotfiles

### Applications
- **Nix Packages**: Node.js, pnpm, Python, uv, git, CLI utilities
- **Homebrew Casks**: Ghostty, Docker Desktop, VSCode, JetBrains Toolbox
- **Mac App Store**: Amphetamine, Bitwarden, Tailscale

## Prerequisites

- macOS (tested on macOS 26.2)
- Admin access (via Privileges.app or similar)
- Apple ID signed into Mac App Store (for mas apps)

## Initial Setup

### On Fresh macOS Install

1. **Install Nix** (if not already installed):
   ```bash
   sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
   ```

2. **Clone this repository**:
   ```bash
   git clone https://github.com/marijnvanderhorst/dotfiles.git ~/dotfiles
   ```

3. **Apply configuration**:
   ```bash
   nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake ~/dotfiles
   ```

   Or use the bootstrap script:
   ```bash
   bash ~/dotfiles/scripts/bootstrap.sh
   ```

4. **Manual post-setup**:
   - Sign into Mac App Store (required for mas apps)
   - Configure Bitwarden and enable SSH agent
   - Set up JetBrains Toolbox and install IDEs
   - Enable VSCode Settings Sync

### On Current Machine (First Time)

Since you already have this machine set up, you'll want to:

1. **Review existing Homebrew packages**:
   ```bash
   brew list
   brew list --cask
   ```

   Add any packages you want to keep to `modules/system/homebrew.nix` or `modules/packages.nix`

2. **Apply configuration** (this will install nix-darwin):
   ```bash
   nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake ~/dotfiles
   ```

3. **On subsequent updates**, use the simpler command:
   ```bash
   darwin-rebuild switch --flake ~/dotfiles
   ```

   Or use the alias (after first setup):
   ```bash
   update
   ```

## Daily Usage

### Adding a New Package

1. **Edit the appropriate file**:
   - Nix packages: `modules/packages.nix`
   - Homebrew casks: `modules/system/homebrew.nix`
   - Mac App Store apps: `modules/system/homebrew.nix` (masApps section)

2. **Apply changes**:
   ```bash
   darwin-rebuild switch --flake ~/dotfiles
   ```

3. **Commit to git**:
   ```bash
   cd ~/dotfiles
   git add .
   git commit -m "Add package X"
   git push
   ```

### Updating Packages

```bash
# Update flake inputs (package versions)
cd ~/dotfiles
nix flake update

# Apply updates
darwin-rebuild switch --flake ~/dotfiles

# Commit the updated lockfile
git add flake.lock
git commit -m "Update dependencies"
git push
```

Or use the convenient alias:
```bash
update-flake
```

### Modifying System Preferences

Edit `modules/system/defaults.nix` and run:
```bash
darwin-rebuild switch --flake ~/dotfiles
```

### Modifying Dotfiles

Edit files in `modules/programs/` (e.g., `git.nix`, `zsh.nix`) and run:
```bash
darwin-rebuild switch --flake ~/dotfiles
```

## Repository Structure

```
~/dotfiles/
├── darwin-configuration.nix           # Main system configuration
├── flake.lock                         # Locked dependency versions
├── flake.nix                          # Nix flake entry point
├── home.nix                           # Home Manager configuration
├── personal.nix                       # Machine/user-local config overrides
├── modules/
│   ├── packages.nix                   # Nix packages
│   ├── programs/
│   │   ├── git.nix                    # Git configuration
│   │   ├── obsidian.nix               # Obsidian configuration
│   │   ├── secrets.nix                # Keychain-backed env helpers (keychain-env, keychain-sync)
│   │   ├── starship.nix               # Starship prompt configuration
│   │   └── zsh.nix                    # Zsh configuration
│   ├── system/
│   │   ├── defaults.nix               # macOS system preferences
│   │   ├── direnv.nix                 # direnv + nix-direnv setup
│   │   ├── dnsmasq.nix                # Local DNS configuration
│   │   └── homebrew.nix               # Homebrew packages & apps
├── certs/
│   └── collect-cas.sh                 # Certificate helper script
├── scripts/
│   └── bootstrap.sh                   # Initial setup script
└── README.md                          # This file
```

## Local-Only `personal.nix`

To keep local changes in `personal.nix` out of normal Git tracking:

```bash
git update-index --skip-worktree personal.nix
```

To start tracking changes in `personal.nix` again:

```bash
git update-index --no-skip-worktree personal.nix
```

## Configuration Details

### System Defaults

Current macOS preferences (see `modules/system/defaults.nix`):
- **Dock**: Left position, size 36, no recents, no magnification
- **Finder**: Show extensions, path bar, status bar, list view, search current folder
- **Keyboard**: Faster key repeat, no autocorrect

### Shell Aliases

Available aliases (see `modules/programs/zsh.nix`):
- `update` - Apply configuration changes
- `update-flake` - Update dependencies and apply changes
- `ll` - Better ls with git integration
- `g` - Git shorthand
- `pn` - pnpm shorthand

## Secrets Management

Secrets (SSH keys, API tokens, etc.) are managed via Bitwarden, NOT committed to this repository:

- **SSH Keys**: Use Bitwarden SSH Agent
- **API Tokens**: Use Bitwarden CLI or Secrets
- **Passwords**: Stored in Bitwarden

### Per-directory env vars from macOS Keychain

For shell environment variables that authenticate CLIs (e.g. `GITHUB_TOKEN`,
`OPENAI_API_KEY`), secrets are cached in the **macOS login Keychain** and
auto-exported via [direnv](https://direnv.net/) when you `cd` into a project.

Two helpers are provided (declared in `modules/programs/secrets.nix`):

- `keychain-sync <bitwarden_item> [keychain_service] [field]`
  Pulls a secret from your Bitwarden vault and stores it as a generic
  password in the login Keychain. Field defaults to `password`.
- `keychain-env VAR [SERVICE]`
  Reads `SERVICE` (default: `VAR`) from the Keychain and prints
  `export VAR=<value>` to stdout — usable as `eval "$(keychain-env FOO)"`.

A direnv stdlib function `keychain_env` is also installed (see
`modules/system/direnv.nix`) for cleaner `.envrc` syntax.

#### One-time bootstrap

```bash
bw login                       # interactive, once per machine
keychain-sync github_token     # pulls 'github_token' item -> Keychain
```

#### Per-project usage

In any project directory:

```bash
# .envrc
keychain_env GITHUB_TOKEN
keychain_env OPENAI_API_KEY openai_api_key   # var name != service name
```

Then run `direnv allow` once per directory. On the first read, macOS will
prompt to grant Keychain access — choose **Always Allow** to suppress
future prompts for that calling binary.

#### Standalone (outside direnv)

```bash
eval "$(keychain-env GITHUB_TOKEN)"
gh auth status
```

## Troubleshooting

### Build Errors

If you encounter build errors:

1. **Check Nix store**: Sometimes cache issues occur
   ```bash
   nix-collect-garbage -d
   ```

2. **Check for syntax errors**:
   ```bash
   nix flake check ~/dotfiles
   ```

3. **Verbose output**:
   ```bash
   darwin-rebuild switch --flake ~/dotfiles --show-trace
   ```

### Homebrew Cleanup Warning

The configuration uses `onActivation.cleanup = "uninstall"`, which means:
- Any Homebrew package/app NOT in your config will be removed
- This enforces the "repository as source of truth" model
- If you want to keep a package, add it to `modules/system/homebrew.nix`

### Mac App Store Apps Not Installing

Ensure you're signed into the Mac App Store and have "purchased" (even if free) the apps before. Run:
```bash
mas account
mas list
```

### Rollback

If something breaks, rollback to previous configuration:
```bash
darwin-rebuild switch --flake ~/dotfiles --rollback
```

Or select a specific generation:
```bash
darwin-rebuild --list-generations
darwin-rebuild switch --flake ~/dotfiles --switch-generation <number>
```

## Learning Resources

- [nix-darwin Documentation](https://github.com/LnL7/nix-darwin)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [Zero to Nix](https://zero-to-nix.com/)

## License

This is a personal dotfiles repository. Feel free to use as inspiration for your own setup.

# Agent Guidelines for Dotfiles Repository

## Build/Check Commands
- **Apply changes**: `darwin-rebuild switch --flake ~/dotfiles`
- **Check syntax**: `nix flake check ~/dotfiles`
- **Format Nix files**: `nixpkgs-fmt <file.nix>`
- **Verbose build**: `darwin-rebuild switch --flake ~/dotfiles --show-trace`
- **Rollback**: `darwin-rebuild switch --flake ~/dotfiles --rollback` (emergency recovery)
- **Update dependencies**: `nix flake update` (commit `flake.lock` after updating)

## Code Style
- **Language**: Nix expression language for declarative macOS configuration
- **Formatting**: Use 2-space indentation, format with `nixpkgs-fmt`
- **Imports**: Group by category with comments (e.g., "# Version control", "# Node.js ecosystem")
- **Module structure**: Follow pattern `{ config, pkgs, ... }: { ... }`
- **Naming**: Use camelCase for Nix attributes (e.g., `systemPackages`), kebab-case for files (e.g., `darwin-configuration.nix`)
- **Comments**: Use `#` for inline comments; add descriptive headers for sections

## Key Conventions
- **Package management**: Nix packages in `modules/packages.nix`, GUI apps in `modules/system/homebrew.nix`
- **Homebrew cleanup**: `onActivation.cleanup = "uninstall"` means any package/app NOT in config will be removed on rebuild
- **No secrets**: Never commit API tokens, SSH keys, or passwords (use Bitwarden)
- **Source of truth**: All system config must be declared in Nix files
- **Testing**: No unit tests; validate with `nix flake check` before committing

## Repository Structure
Main config: `darwin-configuration.nix` (system) and `home.nix` (user). Modules in `modules/`: `system/`, `programs/`, `packages.nix`.

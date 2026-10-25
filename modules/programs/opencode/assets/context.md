# Agent Guidelines for macOS System Configuration

## macOS Package Installation Workflow

### CRITICAL: Do NOT Use `brew install` Directly

This macOS system is managed declaratively using Nix and nix-darwin. All software installation must go through the dotfiles configuration.

**NEVER run commands like:**
- `brew install <package>` ❌
- `brew cask install <app>` ❌
- `npm install -g <package>` ❌
- Direct downloads/installers ❌

### How to Install Software

1. **Identify the package type:**
   - CLI tools/libraries → Add to `~/dotfiles/modules/packages.nix`
   - GUI applications (casks) → Add to `~/dotfiles/modules/system/homebrew.nix` under `casks`
   - Homebrew-only CLI tools → Add to `~/dotfiles/modules/system/homebrew.nix` under `brews`
   - Mac App Store apps → Add to `~/dotfiles/modules/system/homebrew.nix` under `masApps`

2. **Add the package to the appropriate file:**

   For CLI tools (`~/dotfiles/modules/packages.nix`):
   ```nix
   environment.systemPackages = with pkgs; [
     # ... existing packages ...
     newtool  # Add new package here
   ];
   ```

   For GUI apps (`~/dotfiles/modules/system/homebrew.nix`):
   ```nix
   casks = [
     # ... existing casks ...
     "new-app"  # Add new cask here
   ];
   ```

3. **Apply the configuration:**
   ```bash
   darwin-rebuild switch --flake ~/dotfiles
   ```

4. **Verify installation:**
   - CLI tools: `which <command>`
   - GUI apps: Check Applications folder

### Search for Packages

- **Nix packages**: `nix search nixpkgs <package-name>`
- **Homebrew casks**: `brew search --cask <app-name>`
- **Homebrew brews**: `brew search <package-name>`
- **Mac App Store**: Use `mas search <app-name>` (get ID with `mas search`)

### Unfree/Proprietary Software

Some packages require explicit approval. Add to `allowUnfreePredicate` in `~/dotfiles/modules/packages.nix`:
```nix
nixpkgs.config = {
  allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
    "new-unfree-package"  # Add here
  ];
};
```

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

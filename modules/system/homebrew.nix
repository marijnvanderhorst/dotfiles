{ ... }:

let
  personal = import ../../personal.nix;
in
{
  homebrew = {
    enable = true;

    global = {
      autoUpdate = false;
    };

    # Homebrew update and cleanup behavior
    onActivation = {
      autoUpdate = false; # Manual updates as preferred
      cleanup = "uninstall"; # Remove packages not in config (enforces source of truth)
      upgrade = false; # Manual upgrades
      extraEnv = {
        XDG_CONFIG_HOME = "${personal.home}/.config";
      };
    };

    # Brew Taps
    taps = [
      "anomalyco/tap"
      "datadog-labs/pack"
      "nnnkkk7/tap"
      "snyk/tap"
    ];

    # CLI tools via Homebrew
    brews = [
      "anomalyco/tap/opencode-v2" # AI coding assistant/agent
      "datadog-labs/pack/pup" # DataDog Pup CLI
      "github-mcp-server" # GitHub MCP Server
      "hstr" # History manager for the terminal
      "mas" # Mac App Store CLI
      "md5sha1sum" # MD5/SHA1 checksum utility
      "nnnkkk7/tap/lazyactions" # Lazygit-style TUI for GitHub Actions
      "pinentry-mac" # Pinentry for GPG
      "snyk/tap/snyk"
      "azure/azd/azd"

      {
        name = "helm@3"; # Kubernetes package manager
        link = true;
      }
    ];

    # GUI applications (casks)
    casks = [
      "affinity" # Affinity Studio
      "alfred" # Alfred launcher
      "betterdisplay" # BetterDisplay Pro
      "busycal" # BusyCal
      "cleanshot" # CleanShot
      "copilot-cli" # GitHub Copilot CLI
      "dbngin" # DBngin
      "github-copilot-app" # | GitHub Copilot desktop app for managing GitHub Copilot settings and subscriptions
      "hyperkey" # Hyperkey - The extra macOS modifier key
      "jetbrains-toolbox" # JetBrains Toolbox | Manage JetBrains IDEs
      "kicad" # KiCad EDA | Open source PCB design / electronics CAD software
      "lm-studio" # LM Studio for local LLMs
      "mac-mouse-fix" # Mac Mouse Fix
      "opencode-desktop" # AI coding agent desktop client
      "pixelsnap" # PixelSnap
      "proton-pass" # Proton Pass | Password manager
      "rectangle-pro" # Rectangle Pro
      "skim" # Skim PDF reader
      "slack" # Slack desktop client
      "slack-cli" # Slack CLI | create, run, and deploy Slack apps
      "wakatime" # macos-wakatime
      "xquartz" # X.Org X Window System for macOS
      "yubico-authenticator" # Yubico Authenticator | Companion app to manage YubiKey and access one-time passwords
      "zen" # Zen Browser | Gecko based web browser
    ];

    # Mac App Store apps
    masApps = {
      "Amphetamine" = 937984704;
      "Bitwarden" = 1352778147;
      "Tailscale" = 1475387142;
      "TextSniper" = 1528890965;
    };
  };
}

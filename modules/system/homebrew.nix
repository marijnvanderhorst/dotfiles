{ ... }:

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
    };

    # Brew Taps
    taps = [
      "anomalyco/tap"
    ];

    # CLI tools via Homebrew
    brews = [
      "mas" # Mac App Store CLI
      "md5sha1sum" # MD5/SHA1 checksum utility
      "pinentry-mac" # Pinentry for GPG
      "okta-aws-cli" # Okta AWS CLI
      "anomalyco/tap/opencode" # AI coding assistant/agent

      # Kubernetes package manager
      {
        name = "helm@3";
        link = true;
      }
    ];

    # GUI applications (casks)
    casks = [
      "alfred" # Alfred launcher
      "betterdisplay" # BetterDisplay Pro
      "busycal" # BusyCal
      "cleanshot" # CleanShot
      "dbngin" # DBngin
      "docker-desktop" # Docker Desktop
      "git-credential-manager" # Git Credential Manager for Mac
      "kando" # Cross-platform pie menu for your desktop
      "logi-options+" # Logitech Options+ for mouse/keyboard management
      "mac-mouse-fix" # Mac Mouse Fix
      "pixelsnap" # PixelSnap
      "rectangle-pro" # Rectangle Pro
      "wakatime" # macos-wakatime
      "lm-studio" # LM Studio for local LLMs
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

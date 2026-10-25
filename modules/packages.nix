{ pkgs, lib, inputs, ... }:

let
  personal = import ../personal.nix;
  gifcurryHaskellPackages = pkgs.haskellPackages.override {
    overrides = hfinal: hprev: {
      # gi-gst 1.0.30 incorrectly marks these callback parameters nullable.
      gi-gst = hprev.gi-gst.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          sed -i \
            -e 's|Gst/BufferForeachMetaFunc/@parameters/meta nullable 1|Gst/BufferForeachMetaFunc/@parameters/meta nullable 0|' \
            -e 's|Gst/BufferListFunc/@parameters/buffer nullable 1|Gst/BufferListFunc/@parameters/buffer nullable 0|' \
            -e 's|Gst/PadStickyEventsForeachFunction/@parameters/event nullable 1|Gst/PadStickyEventsForeachFunction/@parameters/event nullable 0|' \
            Gst.overrides
        '';
      });
    };
  };
  gifcurry = inputs.nurpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.gifcurry.override {
    haskellPackages = gifcurryHaskellPackages;
  };
  php = pkgs.php84.buildEnv {
    extensions = (
      { enabled, all }:
      enabled
      ++ (with all; [
        xdebug
        redis
      ])
    );
    extraConfig = ''
      memory_limit = 2G
      xdebug.mode = debug
      error_reporting = E_COMPILE_ERROR|E_RECOVERABLE_ERROR|E_ERROR|E_CORE_ERROR
    '';
  };
  phpFpmConfig = pkgs.writeTextFile {
    name = "php-fpm.ini";
    destination = "/lib/php-fpm.ini";
    text = ''
      [customproxy]
      user = ${personal.username}
      listen = /var/run/phpfpm/php-fpm.sock
      listen.owner = ${personal.username}
      listen.group = staff
      listen.mode = 0660
      pm = dynamic
      pm.max_children = 32
      pm.max_requests = 500
      pm.start_servers = 2
      pm.min_spare_servers = 1
      pm.max_spare_servers = 5
      php_admin_value[error_log] = stderr
      php_admin_flag[log_errors] = true
      catch_workers_output = true
    '';
  };
  platformio = pkgs.platformio-core.overrideAttrs (old: {
    patches = old.patches ++ [
      (pkgs.fetchpatch {
        name = "platformio-starlette-1-compatibility";
        url = "https://github.com/platformio/platformio-core/pull/5423.diff";
        hash = "sha256-6idGmxqKW+RsSMZW1mfOCqWRfjj3tXkvm2XzZBxUiIA=";
      })
    ];
  });
  tmux = pkgs.tmux.overrideAttrs (old: {
    # tmux 3.7c requires jemalloc on Darwin because of a macOS calloc issue.
    buildInputs = old.buildInputs ++ [ pkgs.jemalloc ];
    configureFlags = old.configureFlags ++ [ "--enable-jemalloc" ];
  });
in
{

  launchd.daemons.phpfpm = {
    command = "/bin/bash -c 'mkdir -p /var/run/phpfpm && chown ${personal.username}:staff /var/run/phpfpm && ${pkgs.lib.makeBinPath [ php ]}/php-fpm --nodaemonize --fpm-config ${phpFpmConfig}/lib/php-fpm.ini'";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "/var/log/phpfpm.log";
    };
  };

  environment.systemPackages = with pkgs; [
    # Version control
    nix-diff # Get diffs between nix derivations (local vs latest version)
    git
    git-credential-manager
    gh

    # Node.js ecosystem
    fnm
    pnpm

    file # File type detector (mimetype support) AKA libmagic

    # PHP
    php
    php.packages.composer

    # .NET
    (dotnetCorePackages.combinePackages [
      pkgs.dotnetCorePackages.sdk_10_0-bin
      pkgs.dotnetCorePackages.sdk_9_0-bin
    ])
    docfx
    powershell

    # Lua
    lua5_1 # Powerful, fast, lightweight, embeddable scripting language
    luarocks # A package manager for Lua modules

    # Go
    go

    # Terminal emulator
    ghostty-bin

    # CLI utilities
    wget
    httpie # HTTP client like curl but with a nicer interface
    hwatch # Watch command with a nicer interface
    curl
    gnupg # GPG for encryption and signing
    yubikey-manager # YubiKey management tool
    bat # Better cat with syntax highlighting
    bitwarden-cli # Bitwarden CLI (bw) for personal vault access
    bws # Bitwarden Secrets Manager CLI
    eza # Better ls with colors and git integration
    fd # Better find
    fzf # Fuzzy finder
    btop # Interactive process viewer
    jq # JSON processor
    k9s # Kubernetes terminal UI
    kubectl # Kubernetes CLI
    opentofu # Infrastructure as Code tool
    pv # Pipe viewer
    ripgrep # Better grep (rg)
    tmux # Terminal multiplexer
    tree # Directory tree viewer
    devcontainer # Development Containers CLI
    zoxide # Directory navigation
    imagemagick
    ffmpeg
    gifcurry
    desktoppr
    yubikey-manager
    librsvg
    openfga-cli
    hyperfine # Command-line benchmarking tool

    # Database
    redis # In-memory data structure store

    # Development tools
    cmake # Cross-platform build system
    neovim # Text editor
    vscode # Visual Studio Code
    caddy # Web server
    mkcert # Local development SSL certificates
    dnsmasq # Lightweight DNS forwarder
    bun # Fast JavaScript runtime

    # Nix development tools
    nixpkgs-fmt # Nix code formatter
    nil # Nix Language Server
    nixd # Nix Language Server

    daisydisk
    spotify
    thunderbird
    mouser
  ];

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "bws"
        "daisydisk"
        "jetbrains-toolbox"
        "obsidian"
        "spotify"
        "vscode"
        "claude-code"
      ];
  };
}

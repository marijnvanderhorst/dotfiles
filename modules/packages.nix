{ pkgs, lib, ... }:

let
  personal = import ../personal.nix;
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
    git
    #    git-credential-manager
    gh

    daisydisk

    # Node.js ecosystem
    nodejs
    pnpm

    # Python ecosystem
    python3
    uv
    file # File type detector (mimetype support) AKA libmagic

    # PHP
    php
    php.packages.composer
    #    php84Packages.composer
    #    php84Extensions.xdebug

    # .NET
    dotnet-sdk_9
    mono

    # Terminal emulator
    ghostty-bin

    # CLI utilities
    atuin # Shell history manager
    wget
    curl
    gnupg # GPG for encryption and signing
    yubikey-manager # YubiKey management tool
    bat # Better cat with syntax highlighting
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
    azure-cli # Azure CLI
    snyk # Snyk Security Scanner
    devcontainer # Development Containers CLI
    awscli # AWS CLI v2
    # gimme-aws-creds # AWS credentials helper
    zoxide # Directory navigation
    imagemagick
    ffmpeg

    # Development tools
    #opencode            # AI coding assistant
    neovim # Text editor
    jetbrains-toolbox # JetBrains IDE manager
    vscode # Visual Studio Code
    caddy # Web server
    mkcert # Local development SSL certificates
    dnsmasq # Lightweight DNS forwarder
    bun # Fast JavaScript runtime

    # Nix development tools
    nixpkgs-fmt # Nix code formatter
    nil # Nix Language Server
  ];

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "jetbrains-toolbox"
        "vscode"
        "daisydisk"
        "bws"
        "obsidian"
      ];
  };
}

{ config, pkgs, ... }:

let
  personal = import ./personal.nix;
  programModules = map
    (name: ./modules/programs + "/${name}")
    (builtins.attrNames (builtins.readDir ./modules/programs));
in
{
  imports = programModules;

  home.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    SSH_AUTH_SOCK = "$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock";
    NODE_USE_SYSTEM_CA = 1;
    NODE_EXTRA_CA_CERTS = "/Library/Application Support/Netskope/STAgent/data/nscacert.pem";
    HOMEBREW_PREFIX = "/opt/homebrew";
    NIX_SSL_CERT_FILE = "${config.home.sessionVariables.HOMEBREW_PREFIX}/etc/ca-certificates/cert.pem";
    CURL_CA_BUNDLE = "${config.home.sessionVariables.HOMEBREW_PREFIX}/etc/ca-certificates/cert.pem";
    SSL_CERT_FILE = "${config.home.sessionVariables.HOMEBREW_PREFIX}/etc/ca-certificates/cert.pem";
    REQUESTS_CA_BUNDLE = "${config.home.sessionVariables.HOMEBREW_PREFIX}/etc/ca-certificates/cert.pem";
    PNPM_HOME = "$HOME/Library/pnpm";
    COMPOSER_HOME = "${config.home.sessionVariables.XDG_CONFIG_HOME}/composer";

    VISUAL = "nvim";
    EDITOR = "nvim";
    SUDO_EDITOR = "${pkgs.neovim}/bin/nvim";

    DOTNET_ROOT = "${pkgs.dotnetCorePackages.sdk_10_0-bin}/share/dotnet";

    HSTR_CONFIG = "hicolor";
    HSTR_TIOCSTI = "y";

    DISABLE_TELEMETRY = "1";

    DYLD_FALLBACK_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      # Needed for pandas / numpy
      pkgs.stdenv.cc.cc.lib
      pkgs.zlib
      # Needed for python-magic
      pkgs.file
    ];
  };

  home.sessionPath = [
    "/Applications/Nix Apps/Visual Studio Code.app/Contents/Resources/app/bin"
    "$HOME/.local/bin"
    "$HOME/.dotnet/tools"
    "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
    "$HOME/.cache/.bun/bin"
    "${config.home.sessionVariables.HOMEBREW_PREFIX}/bin"
    "${config.home.sessionVariables.HOMEBREW_PREFIX}/opt/openssl/bin"
    "${config.home.sessionVariables.PNPM_HOME}/bin"
    "${config.home.sessionVariables.COMPOSER_HOME}/vendor/bin"
  ];

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Home Manager state version
  home.stateVersion = "24.11";
}

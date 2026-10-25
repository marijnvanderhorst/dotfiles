{ pkgs, ... }:

let
  personal = import ./personal.nix;
in
{
  imports = [
    ./modules/system/defaults.nix
    ./modules/system/homebrew.nix
    ./modules/system/dnsmasq.nix
    ./modules/system/direnv.nix
    ./modules/system/secrets.nix
    ./modules/packages.nix
  ];

  # Enable experimental features
  nix.settings = {
    experimental-features = "nix-command flakes";
    download-buffer-size = 1073741824; # 1GB
    cores = 0; # '0' means use all available CPU cores for a single build
    max-jobs = "auto"; # Run as many parallel package builds as you have CPUs
  };

  nix.optimise = {
    automatic = true;
  };

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Set user shell
  users.users.${personal.username} = {
    home = personal.home;
    shell = pkgs.zsh;
  };

  system.startup.chime = false;

  system.primaryUser = personal.username;

  security.pki.certificates = personal.tls.trustedCAs;

  environment.variables = {
    DYLD_FALLBACK_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      # Needed for pandas / numpy
      pkgs.stdenv.cc.cc.lib
      pkgs.zlib
      # Needed for python-magic
      pkgs.file
    ];
  };

  system.activationScripts.postActivation.text = ''
    mkdir -p /usr/local/lib
    ln -sf ${pkgs.file}/lib/libmagic.dylib /usr/local/lib/libmagic.dylib
    ln -sf ${pkgs.file}/lib/libmagic.1.dylib /usr/local/lib/libmagic.1.dylib
  '';

  # System state version
  system.stateVersion = 5;
}

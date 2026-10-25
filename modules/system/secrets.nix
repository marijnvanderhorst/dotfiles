{ pkgs, ... }:

let
  keychain-env = pkgs.writeShellScriptBin "keychain-env"
    (builtins.readFile ../../scripts/secrets/keychain-env.sh);

  keychain-sync = pkgs.writeShellScriptBin "keychain-sync"
    (builtins.readFile ../../scripts/secrets/keychain-sync.sh);
in
{
  environment.systemPackages = [
    keychain-env
    keychain-sync
  ];
}

{ pkgs, ... }:

let
  personal = import ../../personal.nix;
in
{
  programs.uv = {
    enable = true;

    python = {
      prune = true;
      versions = [
        "3.15"
        "3.14"
        "3.11"
      ];
      default = ["3.14"];
    };

    tool = {
      packages = [
        "ruff"
        "ty"
        "azure-cli"
      ];
    };

    settings = {
      python-downloads = "manual";
      python-preference = "managed";
      system-certs = true;
    };
  };
}

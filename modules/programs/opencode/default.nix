{ config, pkgs, ... }:

let
  personal = import ../../../personal.nix;
in
{
  # Keep private agent and skill definitions mutable and outside the flake's Git source.
  xdg.configFile = builtins.listToAttrs (map
    (directory: {
      name = "opencode/${directory}";
      value.source = config.lib.file.mkOutOfStoreSymlink "${personal.paths.dotfiles}/local/opencode/${directory}";
    })
    [ "agents" "skills" ]);

  programs.mcp = {
    enable = true;
    servers = {
      context7 = {
        command = "${personal.home}/.secrets/context7/main.sh";
        args = [ ];
        type = "local";
      };
    };
  };

  programs.opencode = {
    enable = true;
    package = pkgs.writeShellScriptBin "opencode" ''
      exec /opt/homebrew/bin/opencode "$@"
    '';

    enableMcpIntegration = true;
    settings = {
      autoupdate = "notify";

      formatter = true;
      lsp = true;

      disabled_providers = [
        "opencode"
      ];

      enabled_providers = [
        "github-copilot"
        "lmstudio"
      ];

      permissions = [
        {
          action = "external_directory";
          resource = "/tmp/**";
          effect = "allow";
        }
      ];

      plugins = [
        "${personal.home}/.local/src/ponytail/.opencode/plugins/ponytail.mjs"
        "@slkiser/opencode-quota@5"
        "@wakatime/opencode-wakatime"
      ];

      compaction = {
        auto = true;
        prune = true;
      };
    };

    tui = {
      theme = "tokyonight";
      keybinds = {
        variant_list = "<leader>v";
      };
    };

    commands = { };

    context = builtins.readFile ./assets/context.md;
  };
}

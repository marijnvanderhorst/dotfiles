{ pkgs, ... }:

let
  personal = import ../../personal.nix;
in
{
  programs.git = {
    enable = true;

    signing = {
      format = "ssh";
      key = personal.defaults.git.signingKey;
      signByDefault = true;
    };

    settings = {
      user = {
        name = personal.defaults.git.name;
        email = personal.defaults.git.email;
      };

      gpg = {
        ssh = {
          allowedSignersFile = "${personal.home}.ssh/allowedSigners";
        };
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;

      core = {
        sshCommand = "ssh";
        editor = "nvim";
        autocrlf = "input";
      };

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };

      credential = {
        helper = pkgs.lib.meta.getExe pkgs.git-credential-manager;
        credentialStore = "keychain";
        azreposCredentialType = "oauth";

        "https://dev.azure.com" = {
          useHttpPath = true;
          provider = "azure-repos";
        };
      } // personal.defaults.git.azRepos;
    };
  };
}

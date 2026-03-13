{ config
, pkgs
, lib
, ...
}:

let
  personal = import ../../personal.nix;
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # System updates
      update = "sudo darwin-rebuild switch --flake ${personal.home}/dotfiles";
      update-flake = "cd ~/dotfiles && sudo nix flake update && sudo darwin-rebuild switch --flake ${personal.home}/dotfiles";

      # Formatting (workaround for nix fmt hang - Nix 2.31 bug #13927)
      nix-fmt = "nixpkgs-fmt .";

      # Better alternatives for common commands
      ll = "eza -la --git";
      lt = "eza --tree";
      cat = "bat";
      nano = "nvim";

      # Git shortcuts
      g = "git";
      gst = "git status";

      # Directory navigation
      cd = "z";
      ".." = "z ..";
      "..." = "z ../..";

      # Development shortcuts
      pn = "pnpm";

      # MacOS fixes
      airdrop-up = "sudo ifconfig awdl0 up";
      airdrop-down = "sudo ifconfig awdl0 down";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    completionInit = ''
      autoload -U compinit && compinit
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
    '';

    initContent = lib.mkOrder 1500 ''
      # Home / End key bindings
      bindkey "^[[H"    beginning-of-line   # Home
      bindkey "^[[F"    end-of-line         # End
      bindkey "^[[1~"   beginning-of-line   # Home (alternate)
      bindkey "^[[4~"   end-of-line         # End (alternate)
      bindkey "^[[3~"   delete-char         # Delete

      bindkey "\e[A"    history-beginning-search-backward   # Up arrow with prefix
      bindkey "\e[B"    history-beginning-search-forward    # Down arrow with prefix

      eval "$(zoxide init zsh)"
      eval "$(atuin init zsh)"
    '';

    setOptions = [
      "NO_BEEP"
      "HIST_FIND_NO_DUPS"
    ];
  };
}

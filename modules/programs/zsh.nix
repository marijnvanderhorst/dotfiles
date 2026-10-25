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
      update-flake = "cd ~/dotfiles && nix flake update && sudo darwin-rebuild switch --flake ${personal.home}/dotfiles";

      # Formatting (workaround for nix fmt hang - Nix 2.31 bug #13927)
      nix-fmt = "nixpkgs-fmt .";

      # Better alternatives for common commands
      ls = "eza";
      ll = "eza -lga --icons --hyperlink --git --sort=name";
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
      #      code = "/Applications/Nix Apps/Visual Studio Code.app/Contents/MacOS/Code";

      # MacOS fixes
      airdrop-up = "sudo ifconfig awdl0 up";
      airdrop-down = "sudo ifconfig awdl0 down";

      # History
      hh = "hstr";
    };

    history = {
      size = 10000000;
      save = 10000000;
      path = personal.paths.history;
      ignoreAllDups = true;
      share = true;
    };

    plugins = [
      {
        name = "zsh-defer";
        src = pkgs.zsh-defer;
        file = "share/zsh-defer/zsh-defer.plugin.zsh";
      }
      {
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
    ];

    completionInit = ''
      setopt extendedglob
      typeset -aU fpath
      autoload -Uz compinit
      if [[ -f ~/.zcompdump && -z ~/.zcompdump(#qN.mh+24) ]]; then
        compinit -C
      else
        compinit
      fi
      zstyle ':completion:*' menu no
    '';

    initContent = lib.mkOrder 1500 ''
      # zsh-vi-mode overwrites key bindings when it initializes, and this happens
      # *after* the rest of initContent runs (home-manager sources initContent
      # before the plugins list, regardless of mkOrder). A plain `bindkey` call
      # here has no effect, since zsh-vi-mode (sourced later, from the plugins
      # list) resets it. zvm_after_init is zsh-vi-mode's documented hook that
      # runs right after its own init, so bindings set here persist.
      # https://github.com/jeffreytse/zsh-vi-mode#execute-extra-commands
      function zvm_after_init() {
        # Bind Ctrl-R to HSTR in vi insert mode.
        bindkey -M viins -s "^R" "^A hstr -- ^J"

        # Home / End key bindings
        bindkey "^[[H"    beginning-of-line   # Home
        bindkey "^[[F"    end-of-line         # End
        bindkey "^[[1~"   beginning-of-line   # Home (alternate)
        bindkey "^[[4~"   end-of-line         # End (alternate)
        bindkey "^[[3~"   delete-char         # Delete
      }

      bindkey "\e[A"    history-beginning-search-backward   # Up arrow with prefix
      bindkey "\e[B"    history-beginning-search-forward    # Down arrow with prefix

      eval "$(zoxide init zsh)"
      eval "$(fnm env --shell zsh)"
      export VISUAL="nvim"
      export EDITOR="nvim"
      export SUDO_EDITOR="${pkgs.neovim}/bin/nvim"
      # zsh-vi-mode reads $EDITOR at *plugin load time* to set its internal
      # ZVM_VI_EDITOR (used by "Esc v v" to edit the command line), but our
      # own `export EDITOR="nvim"` (in modules/home/editor) runs later in
      # initContent, after the plugins are sourced. Set ZVM_VI_EDITOR here,
      # early, so zsh-vi-mode picks up nvim instead of whatever $EDITOR the
      # outer environment happened to have (e.g. macOS's default of pico).
      export ZVM_VI_EDITOR="nvim"
    '';

    setOptions = [
      "VI" # Use vi key bindings in ZLE (equivalent to `set -o vi`).
      "NO_BEEP"
      "BANG_HIST" # Treat the '!' character specially during expansion.
      "EXTENDED_HISTORY" # Write the history file in the ":start:elapsed;command" format.
      "INC_APPEND_HISTORY" # Write to the history file immediately, not when the shell exits.
      "NO_SHARE_HISTORY" # Keep per-session history behavior predictable.
      "HIST_FCNTL_LOCK" # Better history file locking with multiple shells.
      "HIST_IGNORE_DUPS" # Don't record an entry that was just recorded again.
      "HIST_FIND_NO_DUPS" # Do not display a line previously found.
      "HIST_IGNORE_SPACE" # Don't record an entry starting with a space.
      "HIST_REDUCE_BLANKS" # Remove superfluous blanks before recording entry.
      "HIST_VERIFY" # Don't execute immediately upon history expansion.
      "NO_NOMATCH" # stop zsh from catching ^ chars.
      "INTERACTIVE_COMMENTS" # allow comments in interactive shells
    ];
  };
}

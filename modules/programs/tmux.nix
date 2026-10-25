{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
    historyLimit = 10000;
    keyMode = "vi";
    plugins = with pkgs; [
      tmuxPlugins.cpu
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
    ];
    extraConfig = ''
      # Use vi keys when entering copy mode.
      set -g mode-keys vi

      # Improve colors
      set -g default-terminal "screen-256color"

      # Renumber windows when one is closed
      set -g renumber-windows on

      # Status bar styling
      set -g status-style bg=default
      set -g status-left-length 40
      set -g status-left "#[fg=green]Session: #S #[fg=yellow]#I #[fg=cyan]#P"
      set -g status-right "#[fg=cyan]%d %b %R"
      set -g status-justify centre

      bind j resize-pane -D 10
      bind k resize-pane -U 10
      bind l resize-pane -L 10
      bind h resize-pane -R 10
    '';
  };
}

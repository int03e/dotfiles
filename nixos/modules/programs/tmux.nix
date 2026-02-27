{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
    ];
    extraConfig = ''
      set -g base-index 1
      setw -g pane-base-index 1
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      set -g mouse on
      set -g status-style bg=colour65,fg=white
      set-window-option -g window-status-current-style bg=colour108,fg=black,bold
      set -g status-right 'Bat: #(acpi | grep -o "[0-9]*%") | %H:%M '
      set -g status-right-length 50
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix
      bind r source-file /etc/tmux.conf \; display "System Tmux Config Reloaded!"
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
    '';
  };
}

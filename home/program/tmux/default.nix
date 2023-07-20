{ pkgs }:

{
  enable = true;
  keyMode = "vi";
  historyLimit = 102400;
  terminal = "screen-256color";
  tmuxinator.enable = true;
  extraConfig = ''
    # Don't use a login shell
    set-option -g default-command $SHELL

    # Change bind key to ctrl-a
    unbind-key c-b
    set-option -g prefix c-a

    # Renumber windows when a window is closed
    set-option -g renumber-windows on

    # Repeat time limit (ms)
    set-option -g repeat-time 500

    # True color support
    set-option -ga terminal-overrides ",xterm-256color:Tc"

    # Key binding in the status line (bind-key :)
    set-option -g status-keys vi

    # Mouse
    set-option -g mouse on

    # -------------------------------------------------------------------
    # Window options
    # -------------------------------------------------------------------
    # Copy-mode
    set-window-option -g mode-keys vi

    # -------------------------------------------------------------------
    # Key bindings
    # -------------------------------------------------------------------
    # prefix c
    bind-key c new-window -c "#{pane_current_path}"

    # prefix ctrl-a
    bind-key c-a last-window

    # prefix a
    bind-key a send-prefix

    # prefix |
    bind-key | split-window -h -c "#{pane_current_path}"

    # prefix -
    bind-key - split-window -c "#{pane_current_path}"

    # Moving windows
    bind-key -r > swap-window -t :+
    bind-key -r < swap-window -t :-

    # Back and forth
    bind-key bspace previous-window
    bind-key space next-window
    bind-key / next-layout # Overridden

    # Pane-movement
    bind-key h select-pane -L
    bind-key l select-pane -R
    bind-key j select-pane -D
    bind-key k select-pane -U
    bind-key tab select-pane -t :.+
    bind-key btab select-pane -t :.-

    # Synchronize panes
    bind-key * set-window-option synchronize-pane

    # Reload ~/.tmux.conf
    bind-key R source-file ~/.config/tmux/tmux.conf \; display-message "Reloaded!"

    # Capture pane and open in Vim
    bind-key C-c run 'tmux capture-pane -S -102400 -p > /tmp/tmux-capture.txt'\;\
                 new-window "view /tmp/tmux-capture.txt"
    bind-key M-c run "screencapture -l$(osascript -e 'tell app \"iTerm\" to id of window 1') -x -o -P /tmp/$(date +%Y%m%d-%H%M%S).png"

    #------------------------------------------------------------------
    # TokyoNight colors for Tmux
    #------------------------------------------------------------------

    # set -g mode-style "fg=#7aa2f7,bg=#3b4261"

    # set -g message-style "fg=#7aa2f7,bg=#3b4261"
    # set -g message-command-style "fg=#7aa2f7,bg=#3b4261"

    # set -g pane-border-style "fg=#3b4261"
    # set -g pane-active-border-style "fg=#7aa2f7"

    # set -g status "on"
    # set -g status-justify "left"

    # set -g status-style "fg=#7aa2f7,bg=#1f2335"

    # set -g status-left-length "100"
    # set -g status-right-length "100"

    # set -g status-left-style NONE
    # set -g status-right-style NONE

    # set -g status-left "#[fg=#1D202F,bg=#7aa2f7,bold] #S #[fg=#7aa2f7,bg=#1f2335,nobold,nounderscore,noitalics]"
    # set -g status-right "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#1f2335] #{prefix_highlight} #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %I:%M %p #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#1D202F,bg=#7aa2f7,bold] #h "

    # setw -g window-status-activity-style "underscore,fg=#a9b1d6,bg=#1f2335"
    # setw -g window-status-separator ""
    # setw -g window-status-style "NONE,fg=#a9b1d6,bg=#1f2335"
    # setw -g window-status-format "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]"
    # setw -g window-status-current-format "#[fg=#1f2335,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261,bold] #I  #W #F #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]"

    # -------------------------------------------------------------------
    # fzf integration
    # -------------------------------------------------------------------
    # Tmux completion
    bind-key -n 'M-t' run "tmux split-window -p 40 'tmux send-keys -t #{pane_id} \"$(tmuxwords.rb --all --scroll 1000 --min 5 | fzf --multi | paste -sd\\  -)\"'"

    # fzf-locate (all)
    bind-key -n 'M-`' run "tmux split-window -p 40 'tmux send-keys -t #{pane_id} \"$(locate / | fzf -m | paste -sd\\  -)\"'"

    # select-pane (@george-b)
    bind-key 0 run "tmux split-window -l 12 'bash -ci ftpane'"

    # Theme
    set -g @catppuccin_flavour 'frappe'
    set -g @catppuccin_date_time "%Y-%m-%d %H:%M"
    set -g @catppuccin_window_tabs_enabled on
  '';
  plugins = with pkgs.tmuxPlugins; [
    catppuccin
    sensible
    yank
    vim-tmux-navigator
    # nord
  ];
}

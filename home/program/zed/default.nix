{ pkgs, extraPackages ? [], extraExtensions ? [], userSettings ? {}, userKeymaps ? [], ... }:

{
  enable = true;
  extraPackages = extraPackages;
  extensions = [
    "catppuccin"
    "dockerfile"
    "docker-compose"
    "scss"
    "nix"
    "terraform"
    "toml"
  ] ++ extraExtensions;
  mutableUserDebug = false;
  mutableUserKeymaps = false;
  mutableUserSettings = false;
  mutableUserTasks = false;

  userKeymaps = [
    {
      context = "Editor && vim_mode == normal && !VimWaiting && !menu";
      bindings = {
        ctrl-h = "workspace::ActivatePaneLeft";
        ctrl-j = "workspace::ActivatePaneDown";
        ctrl-k = "workspace::ActivatePaneUp";
        ctrl-l = "workspace::ActivatePaneRight";
      };
    }
    {
      context = "Editor && vim_mode == insert && !menu";
      bindings = {
        "j k" = "vim::NormalBefore";
        "f d" = "vim::NormalBefore";
        escape = "vim::NormalBefore";
      };
    }
    {
      context = "(VimControl && !menu)";
      bindings = {
        space = null;
      };
    }
  ] ++ userKeymaps;

  userSettings = pkgs.lib.mergeAttrs {
    agent = {
      enable_feedback = false;
    };

    buffer_font_family = "FiraCode Nerd Font";
    buffer_font_size = 16;
    ui_font_size = 16;
    cursor_blink = false;

    theme = {
      mode = "system";
      light = "Catppuccin Latte";
      dark = "Catppuccin Macchiato";
    };

    telemetry =  {
      metrics = false;
      diagnostics = false;
    };

    helix_mode = true;
    vim = {
      use_system_clipboard = "on_yank";
    };
    which_key = {
      enabled = true;
      delay_ms = 500;
    };
  } userSettings;
}

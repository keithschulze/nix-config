{ pkgs, extraPackages ? [], extraExtensions ? [], userSettings ? {}, ... }:

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
  userKeymaps = builtins.fromJSON(builtins.readFile ./keymap.json);
  userSettings = pkgs.lib.mergeAttrs {
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

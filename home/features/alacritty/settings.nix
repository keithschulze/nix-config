{ config, ... }:
let
  colors = config.colorscheme.palette;
in {
  window = {
    padding.x = 10;
    padding.y = 10;
    decorations = "full";
    opacity = 1.0;
  };

  font = {
    size = 15.0;

    normal.family = "FiraCode Nerd Font";
    bold.family = "FiraCode Nerd Font";
    italic.family = "FiraCode Nerd Font";
  };

  cursor.style = "Block";

  colors = {
    primary = {
      background = "#${colors.base00}";
      foreground = "#${colors.base05}";
    };
    cursor = {
      text = "#${colors.base00}";
      cursor = "#${colors.base05}";
    };
    normal = {
      black = "#${colors.base00}";
      red = "#${colors.base08}";
      green = "#${colors.base0B}";
      yellow = "#${colors.base0A}";
      blue = "#${colors.base0D}";
      magenta = "#${colors.base0E}";
      cyan = "#${colors.base0C}";
      white = "#${colors.base05}";
    };
    bright = {
      black = "#${colors.base03}";
      red = "#${colors.base08}";
      green = "#${colors.base0B}";
      yellow = "#${colors.base0A}";
      blue = "#${colors.base0D}";
      magenta = "#${colors.base0E}";
      cyan = "#${colors.base0C}";
      white = "#${colors.base07}";
    };
    indexed_colors = [
      {
        index = 16;
        color = "#${colors.base09}";
      }
      {
        index = 17;
        color = "#${colors.base0F}";
      }
      {
        index = 18;
        color = "#${colors.base01}";
      }
      {
        index = 19;
        color = "#${colors.base02}";
      }
      {
        index = 20;
        color = "#${colors.base04}";
      }
      {
        index = 21;
        color = "#${colors.base06}";
      }
    ];
  };
}

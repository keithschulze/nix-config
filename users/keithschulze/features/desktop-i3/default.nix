{ config, lib, pkgs, ... }:
let
  colorscheme = config.colorscheme;

  term = "WINIT_X11_SCALE_FACTOR=1.0 alacritty";

  mod = "Mod1";
  exec = "exec --no-startup-id";

  alwaysRun = [
    "systemctl --user restart polybar"
    "xset r rate 250 50"
  ];

  run = [
    "i3-msg workspace number 1"
  ];
in
{
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        bars = [ ];
        gaps = {
          inner = 5;
        };
        window.border = 5;
        floating.border = 5;
        modifier = "${mod}";
        terminal = "${term}";
        keybindings = lib.mkOptionDefault {
          "${mod}+Return" = "${exec} ${term}";
        };
        colors = {
          focused = {
            border = "#${colorscheme.colors.base07}";
            childBorder = "#${colorscheme.colors.base07}";
            background = "#${colorscheme.colors.base07}";
            text = "#${colorscheme.colors.base07}";
            indicator = "#${colorscheme.colors.base07}";
          };
          focusedInactive = {
            border = "#${colorscheme.colors.base03}";
            childBorder = "#${colorscheme.colors.base03}";
            background = "#${colorscheme.colors.base03}";
            text = "#${colorscheme.colors.base03}";
            indicator = "#${colorscheme.colors.base03}";
          };
          unfocused = {
            border = "#${colorscheme.colors.base03}";
            childBorder = "#${colorscheme.colors.base03}";
            background = "#${colorscheme.colors.base03}";
            text = "#${colorscheme.colors.base03}";
            indicator = "#${colorscheme.colors.base03}";
          };
          urgent = {
            border = "#${colorscheme.colors.base03}";
            childBorder = "#${colorscheme.colors.base03}";
            background = "#${colorscheme.colors.base00}";
            text = "#${colorscheme.colors.base05}";
            indicator = "#${colorscheme.colors.base00}";
          };
        };
        startup = []
        ++
        builtins.map ( command:
            {
              command = command;
              always = true;
              notification = false;
            }
          ) alwaysRun
        ++
          builtins.map ( command:
            {
              command = command;
              notification = false;
            }
          ) run;
      };
    };
  };

  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    config = with config.colorscheme; {
      "bar/main" = {
        background = "#${colorscheme.colors.base00}";
        foreground = "#${colorscheme.colors.base05}";
        modules-left = "i3";
        modules-center = "mpd";
        modules-right = "battery date";
        border-left-size = 1;
        border-left-color = "#${colorscheme.colors.base00}";
        border-right-size = 1;
        border-right-color = "#${colorscheme.colors.base00}";
        border-top-size = 2;
        border-top-color = "#${colorscheme.colors.base00}";
        border-bottom-size = 2;
        border-bottom-color = "#${colorscheme.colors.base00}";
        font-0 = "lemon:pixelsize=10;1";
      };
      "module/battery" = {
        type = "internal/battery";
      };
      "module/date" =
        let
          calnotify = pkgs.writeShellScript "calnotify.sh" ''
            day="$(${pkgs.coreutils}/bin/date +'%-d ' | ${pkgs.gnused}/bin/sed 's/\b[0-9]\b/ &/g')"
            cal="$(${pkgs.utillinux}/bin/cal | ${pkgs.gnused}/bin/sed -e 's/^/ /g' -e 's/$/ /g' -e "s/$day/\<span color=\'#${colorscheme.colors.base0B}\'\>\<b\>$day\<\/b\>\<\/span\>/" -e '1d')"
            top="$(${pkgs.utillinux}/bin/cal | ${pkgs.gnused}/bin/sed '1!d')"
            ${pkgs.libnotify}/bin/notify-send "$top" "$cal"
          '';
        in
        {
          type = "internal/date";
          date = "%I:%M %p    %a %b %d";
          label = "%{A1:${calnotify}:}%date%%{A}";
          format = "<label>";
          label-padding = 5;
        };
      "module/i3" = {
        type = "internal/i3";
        label-unfocused-foreground = "#${colorscheme.colors.base03}";
        label-urgent-foreground = "#${colorscheme.colors.base09}";
        label-unfocused-padding = 1;
        label-focused-padding = 1;
        label-urgent-padding = 1;
      };
    };
    script = ''
      polybar main &
    '';
  };
}

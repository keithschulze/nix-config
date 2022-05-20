{ config, lib, pkgs, ... }:
let
  colorscheme = config.colorscheme;

  term = "WINIT_X11_SCALE_FACTOR=1.3333333333 alacritty";

  mod = "Mod1";
  exec = "exec --no-startup-id";

  alwaysRun = [
    "${pkgs.feh}/bin/feh --bg-scale ~/.background-image"
    "systemctl --user restart polybar"
    "xset r rate 250 50"
  ];

  run = [
    "i3-msg workspace number 1"
  ];

  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  programs.autorandr = {
    enable = true;
    profiles = {
      "dell27" = {
        fingerprint = {
          "Virtual-1" = "--CONNECTED-BUT-EDID-UNAVAILABLE--Virtual-1";
        };
        config = {
          "Virtual-1" = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "2560x1440";
            rate = "60.00";
          };
        };
      };
      "mbp" = {
        fingerprint = {
          "Virtual-1" = "--CONNECTED-BUT-EDID-UNAVAILABLE--Virtual-1";
        };
        config = {
          "Virtual-1" = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "2560x1600";
            rate = "60.00";
          };
        };
      };
    };
    hooks = {
      postswitch = {
        "change-dpi" = ''
          case "$AUTORANDR_CURRENT_PROFILE" in
            default)
              DPI=220
              ;;
            dell27)
              DPI=108
              ;;
            mbp)
              DPI=220
              ;;
            *)
              echo "UNKNOWN PROFILE: $AUTORANDR_CURRENT_PROFILE"
              exit 1
          esac

          echo "Xft.dpi: $DPI" | ${pkgs.xorg.xrdb}/bin/xrdb -merge
        '';
      };
    };
  };

  programs.rofi = {
    enable = true;
    font = "FiraCode 24";
    theme = {
      "*" = {
        background-color = mkLiteral "#${colorscheme.colors.base00}";
        foreground-color = mkLiteral "#${colorscheme.colors.base07}";
        active-background = mkLiteral "#${colorscheme.colors.base02}";
        urgent-background = mkLiteral "#${colorscheme.colors.base05}";
        selected-background = mkLiteral "@active-background";
        selected-urgent-background = mkLiteral "@urgent-background";
        selected-active-background = mkLiteral "@active-background";
        separatorcolor = mkLiteral "@active-background";
        bordercolor = mkLiteral "@active-background";
        width = 1280;
      };

      "#window" = {
        background-color = mkLiteral "@background";
        border = 2;
        border-radius = 6;
        border-color = mkLiteral "@bordercolor";
        padding = 5;
      };

      "#mainbox" = {
        border = 0;
        padding = 0;
      };

      "#message" = {
        border = mkLiteral "1px dash 0px 0px";
        border-color = mkLiteral "@separatorcolor";
        padding = mkLiteral "1px";
      };

      "#listview" = {
        fixed-height = 0;
        border = mkLiteral "2px dash 0px 0px";
        border-color = mkLiteral "@bordercolor";
        spacing =      mkLiteral "2px" ;
        scrollbar =    false;
        padding =      mkLiteral "2px 0px 0px" ;
      };

      "#element" = {
        border =  0;
        padding = mkLiteral "1px" ;
      };

      "#element-text" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "#element.normal.normal" = {
        background-color = mkLiteral "@background-color";
        text-color =       mkLiteral "@foreground-color";
      };

      "#element.normal.urgent" = {
        background-color = mkLiteral "@urgent-background";
        text-color =       mkLiteral "@urgent-foreground";
      };

      "#element.normal.active" = {
        background-color = mkLiteral "@active-background";
        text-color =       mkLiteral "@foreground-color";
      };

      "#element.selected.normal" = {
        background-color = mkLiteral "@selected-background";
        text-color =       mkLiteral "@foreground-color";
      };

      "#element.selected.urgent" = {
        background-color = mkLiteral "@selected-urgent-background";
        text-color =       mkLiteral "@foreground-color";
      };

      "#element.selected.active" = {
        background-color = mkLiteral "@selected-active-background";
        text-color =       mkLiteral "@foreground-color";
      };

      "#element.alternate.normal" = {
        background-color = mkLiteral "@background-color";
        text-color =       mkLiteral "@foreground-color";
      };

      "#element.alternate.urgent" = {
        background-color = mkLiteral "@urgent-background";
        text-color =       mkLiteral "@foreground-color";
      };

      "#element.alternate.active" = {
        background-color = mkLiteral "@active-background";
        text-color =       mkLiteral "@foreground-color";
      };

      "#scrollbar" = {
        width =        mkLiteral "2px" ;
        border =       0;
        handle-width = mkLiteral "8px" ;
        padding =      0;
      };

      "#sidebar" = {
        border =       mkLiteral "2px dash 0px 0px" ;
        border-color = mkLiteral "@separatorcolor";
      };

      "#button.selected" = {
        background-color = mkLiteral "@selected-background";
        text-color =       mkLiteral "@background-color";
      };

      "#inputbar" = {
        spacing =    0;
        text-color =  mkLiteral "@foreground-color";
        padding = mkLiteral "1px";
      };

      "#case-indicator" = {
        spacing = 0;
        text-color =  mkLiteral "@foreground-color";
      };

      "#entry" = {
        spacing = 0;
        text-color =  mkLiteral "@foreground-color";
      };

      "#prompt" = {
        spacing = 0;
        text-color =  mkLiteral "@foreground-color";
      };

      "#inputbar" = {
        children = map mkLiteral [ "prompt" "entry" ];
      };

      "#textbox" = {
        text-color = mkLiteral "@foreground-color";
      };

      "#textbox-prompt-colon" = {
        expand = false;
        str = ":";
        margin = mkLiteral "0px 0.3em 0em 0em";
        text-color = mkLiteral "@foreground-color";
      };
    };
  };

  home.pointerCursor = {
    x11.enable = true;
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
  };

  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        bars = [ ];
        gaps = {
          inner = 3;
        };
        window.border = 2;
        floating.border = 2;
        modifier = "${mod}";
        terminal = "${term}";
        keybindings = lib.mkOptionDefault {
          "${mod}+Return" = "${exec} ${term}";
          "${mod}+d" = "${exec} ${pkgs.rofi}/bin/rofi -show run";
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";
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

  services.picom = {
    enable = true;
    backend = "glx";
  };

  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    config = with config.colorscheme; {
      "bar/main" = {
        witdth = "100%";
        height = "3%";
        background = "#${colorscheme.colors.base00}";
        foreground = "#${colorscheme.colors.base07}";
        modules-left = "i3";
        modules-right = "battery date";
        border-left-size = 1;
        border-left-color = "#${colorscheme.colors.base00}";
        border-right-size = 1;
        border-right-color = "#${colorscheme.colors.base00}";
        border-top-size = 2;
        border-top-color = "#${colorscheme.colors.base00}";
        border-bottom-size = 2;
        border-bottom-color = "#${colorscheme.colors.base00}";
        font-0 = "FiraCode:pixelsize=18;1";
      };
      "module/battery" = {
        type = "internal/battery";
      };
      "module/date" = {
          type = "internal/date";
          interval = 1;
          date = "%a %d %b   %I:%M %p";
          label = "%date%";
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

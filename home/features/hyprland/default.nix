{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    ../../common/wayland-wm
    inputs.hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland =
    let
      inherit (config.colorscheme) colors;
    in {
      enable = true;
      xwayland.enable = true;
      package = pkgs.hyprland;
      extraConfig = ''
        exec-once=xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2
        monitor=Virtual-1,2560x1600@60,0x0,1
        workspace=Virtual-1,1

        general {
          main_mod=ALT
          gaps_in=15
          gaps_out=20
          border_size=2.7
          col.active_border=0xff${colors.base0C}
          col.inactive_border=0xff${colors.base02}
          cursor_inactive_timeout=4
        }

        decoration {
          active_opacity=0.9
          inactive_opacity=0.65
          fullscreen_opacity=1.0
          rounding=5
          blur=true
          blur_size=6
          blur_passes=3
          blur_new_optimizations=true
          blur_ignore_opacity=true
          drop_shadow=true
          shadow_range=12
          shadow_offset=3 3
          col.shadow=0x44000000
          col.shadow_inactive=0x66000000
        }

        animations {
          enabled=true
          animation=windows,1,4,default,slide
          animation=border,1,5,default
          animation=fade,1,7,default
          animation=workspaces,1,2,default
        }

        dwindle {
          force_split=2
          preserve_split=true
          col.group_border_active=0xff${colors.base0B}
          col.group_border=0xff${colors.base04}
        }

        misc {
          no_vfr=false
        }

        input {
          kb_layout=br
        }

        input:touchpad {
          disable_while_typing=false
        }

        # Program bindings
        bind=ALT,Return,exec,alacritty

        # Window manager controls
        bind=ALTSHIFT,q,killactive
        bind=ALTSHIFT,e,exit
        bind=ALT,s,togglesplit
        bind=ALT,f,fullscreen,1
        bind=ALTSHIFT,f,fullscreen,0
        bind=ALTSHIFT,space,togglefloating

        bind=ALT,left,movefocus,l
        bind=ALT,right,movefocus,r
        bind=ALT,up,movefocus,u
        bind=ALT,down,movefocus,d
        bind=ALT,h,movefocus,l
        bind=ALT,l,movefocus,r
        bind=ALT,k,movefocus,u
        bind=ALT,j,movefocus,d

        bind=ALTSHIFT,left,movewindow,l
        bind=ALTSHIFT,right,movewindow,r
        bind=ALTSHIFT,up,movewindow,u
        bind=ALTSHIFT,down,movewindow,d
        bind=ALTSHIFT,h,movewindow,l
        bind=ALTSHIFT,l,movewindow,r
        bind=ALTSHIFT,k,movewindow,u
        bind=ALTSHIFT,j,movewindow,d

        bind=ALT,1,workspace,1
        bind=ALT,2,workspace,2
        bind=ALT,3,workspace,3
        bind=ALT,4,workspace,4
        bind=ALT,5,workspace,5
        bind=ALT,6,workspace,6
        bind=ALT,7,workspace,7
        bind=ALT,8,workspace,8
        bind=ALT,9,workspace,9
        bind=ALT,0,workspace,10

        bind=ALTSHIFT,1,movetoworkspace,1
        bind=ALTSHIFT,2,movetoworkspace,2
        bind=ALTSHIFT,3,movetoworkspace,3
        bind=ALTSHIFT,4,movetoworkspace,4
        bind=ALTSHIFT,5,movetoworkspace,5
        bind=ALTSHIFT,6,movetoworkspace,6
        bind=ALTSHIFT,7,movetoworkspace,7
        bind=ALTSHIFT,8,movetoworkspace,8
        bind=ALTSHIFT,9,movetoworkspace,9
        bind=ALTSHIFT,0,movetoworkspace,10
      '';
    };
}

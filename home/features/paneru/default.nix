{ inputs, ... }:

{
  imports = [
    inputs.paneru.homeModules.paneru
  ];

  services.paneru = {
    enable = true;
    # Equivalent to what you would put into `~/.paneru` (See Configuration options below).
    settings = {
      options = {
        preset_column_widths = [
          0.33
          0.5
          0.66
          0.75
          0.9
          0.97
        ];
        padding_left = 5;
        padding_right = 5;
        swipe_gesture_fingers = 4;
        swipe_gesture_direction = "Natural";
        animation_speed = 4000;
      };
      windows.all = {
        title = ".*";
        horizontal_padding = 3;
      };
      bindings = {
        window_focus_west = "cmd - h";
        window_focus_east = "cmd - l";
        window_focus_north = "cmd - k";
        window_focus_south = "cmd - j";
        window_swap_west = "alt - h";
        window_swap_east = "alt - l";
        window_swap_first = "alt + shift - h";
        window_swap_last = "alt + shift - l";
        window_center = "alt - c";
        window_resize = "alt - r";
        window_fullwidth = "alt - f";
        window_manage = "ctrl + alt - t";
        window_stack = "alt - ]";
        window_unstack = "alt + shift - ]";
        quit = "ctrl + alt - q";
      };
    };
  };
}

{ pkgs, ... }:
{
  imports = [
    ./swayidle.nix
    ./swaylock.nix
    ./waybar.nix
    ./tofi.nix
  ];

  home.packages = with pkgs; [
    wf-recorder
    wl-clipboard
    wl-mirror
    cliphist
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 22;
  };

  home.sessionVariables = {
    LIBSEAT_BACKEND = "logind";
  };
}

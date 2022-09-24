{ pkgs, ... }:
{
  imports = [
    ./swayidle.nix
    # ./swaylock.nix
    ./waybar.nix
    ./wofi.nix
  ];

  home.packages = with pkgs; [
    wf-recorder
    wl-clipboard
    wl-mirror
  ];

  home.sessionVariables = {
    LIBSEAT_BACKEND = "logind";
  };
}

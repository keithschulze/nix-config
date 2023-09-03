{ pkgs, ... }:
{
  imports = [
    ./swayidle.nix
    # ./swaylock.nix
    ./waybar.nix
    ./tofi.nix
  ];

  home.packages = with pkgs; [
    wf-recorder
    wl-clipboard
    wl-mirror
    cliphist
  ];

  home.sessionVariables = {
    LIBSEAT_BACKEND = "logind";
  };
}

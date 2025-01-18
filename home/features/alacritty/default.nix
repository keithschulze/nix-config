{ config, ... }:
let
  settings = import ./settings.nix { inherit config; };
in {
  programs.alacritty = {
    enable = true;
    settings = settings;
  };
}

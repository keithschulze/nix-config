{ config, lib, pkgs, ... }:
let
  settings = pkgs.callPackage ./settings { };
in {
  programs.alacritty = {
    enable = true;
    settings = settings;
  };
}

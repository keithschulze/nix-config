{ config, pkgs, system, inputs, ... }:

let
  inherit (pkgs) lorri;
  inherit (inputs) home-manager;
in {
  nix.package = pkgs.nixVersions.stable;

  environment.systemPackages = with pkgs;
    [ lorri
    ];

  programs.zsh = {
    enable = true;  # default shell on catalina
    promptInit = "";
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      roboto
    ];
  };

  system.stateVersion = 4;

  users.users.keithschulze = {
    name = "keithschulze";
    home = "/Users/keithschulze";
  };

  services = {
    nix-daemon.enable = false;
    lorri.enable = true;
  };
}

{ config, pkgs, system, inputs, ... }:

let
  inherit (pkgs) lorri;
in {
  nix.package = pkgs.nixFlakes;

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
    nix-daemon.enable = true;
    lorri.enable = true;
  };

  nix.extraOptions = ''
    system = ${system}
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}

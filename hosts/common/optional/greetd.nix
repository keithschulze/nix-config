{ pkgs, lib, config, outputs, ... }:
{
  environment.etc."greetd/environments".text = ''
    Hyprland
  '';

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "Hyprland";
        user = "keithschulze";
      };
      default_session = initial_session;
    };
  };
}

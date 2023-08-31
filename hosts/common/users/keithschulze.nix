{ pkgs, ... }:

{
  system.stateVersion = "22.11";
  users.users.keithschulze = {
    isNormalUser = true;
    name = "keithschulze";
    home = "/home/keithschulze";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
    initialPassword = "test";
    openssh.authorizedKeys.keys = [];
  };

  virtualisation.docker.enable = true;
}

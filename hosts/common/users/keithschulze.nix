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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHl4x/eh2n9WnzGZdluFMceNAHa0K7E6dHQ18e8wVIx8 keith.schulze@thoughtworks.com"
    ];
  };

  services.lorri = {
    enable = true;
  };

  virtualisation.docker.enable = true;
}

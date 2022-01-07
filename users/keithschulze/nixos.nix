{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  users.users.keithschulze = {
    isNormalUser = true;
    name = "keithschulze";
    home = "/home/keithschulze";
    extraGroups = [ "docker" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHl4x/eh2n9WnzGZdluFMceNAHa0K7E6dHQ18e8wVIx8 keith.schulze@thoughtworks.com"
    ];
  };
}

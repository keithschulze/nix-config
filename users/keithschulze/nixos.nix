{ pkgs, ... }:

{
  users.users.keithschulze = {
    name = "keithschulze";
    home = "/home/keithschulze";
  };

  home-manager = {
    users.keithschulze = import ./home.nix;
    useUserPackages = true;
  };
}

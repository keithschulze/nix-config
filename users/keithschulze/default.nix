{ pkgs, lib, role, features, username, colorscheme, ... }:

let
  inherit (pkgs) stdenv;
  home = if stdenv.isDarwin then "Users" else "home";
  feats = if stdenv.isDarwin then [] else features;
in {
  imports = [
    ./rice.nix
    ./nix-home/role/${role}
  ] ++ map (f: ../../home/features/${f}) features;
    # Import each feature requested

  # Needed for basic operations
  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    inherit username;
    homeDirectory = "/${home}/${username}";
    stateVersion = "22.05";
  };
}

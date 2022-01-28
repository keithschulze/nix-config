{ lib, role, features, ... }:

{
  imports = [
    ./rice.nix
    (./nix-home/role + "/${role}")
  ] ++
    # Import each feature requested
    lib.forEach features (f: ../../home/features + "/${f}");

  # Needed for basic operations
  programs = {
    home-manager.enable = true;
    git.enable = true;
  };
}

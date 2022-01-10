# Hardware configuration.
{ config, lib, pkgs, modulesPath, ... }:

{
  disabledModules = [ "virtualisation/parallels-guest.nix" ];

  imports = [
    # "${modulesPath}/virtualisation/vmware-image.nix"
    ../modules/parallels-unfree/parallels-guest.nix
    ./vm-shared.nix
  ];

  networking.interfaces.enp0s5.useDHCP = true;

  nixpkgs.config.allowUnfree = true;
  hardware.parallels = {
    enable = true;
    package = (config.boot.kernelPackages.callPackage ../modules/parallels-unfree/prl-tools.nix {});
  };
}

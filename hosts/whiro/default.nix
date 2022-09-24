# System configuration for my dev VMs
{ config, pkgs, lib, system, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/users/keithschulze.nix
    ../common/optional/quietboot.nix
    # ../common/optional/greetd.nix
    ../common/optional/xserver.nix
  ];

  # use unstable nix so we can access flakes
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

  # We expect to run the VM on hidpi machines.
  hardware.video.hidpi.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_5_15;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Pacific/Auckland";
  services.ntp.enable = true;

  # Global fonts
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;
  security.polkit.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "no";

  services.logind ={
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  hardware.opengl.enable = true;

  programs.dconf.enable = true;
  programs.ssh.startAgent = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Disable the firewall since we're in a VM and we want to make it
  # easy to visit stuff in here. We only use NAT networking anyways.
  networking.firewall.enable = false;
  networking.interfaces.enp0s5.useDHCP = true;

  # Enable parallel guest mode with prl-tools
  hardware.parallels = {
    enable = true;
  };
}

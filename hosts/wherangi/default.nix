# System configuration for my dev VMs
{ config, pkgs, lib, system, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/users/keithschulze.nix
    ../common/optional/greetd.nix
  ];

  # use unstable nix so we can access flakes
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0
  '';
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  hardware.asahi.peripheralFirmwareDirectory = /etc/nixos/firmware;
  hardware.asahi.useExperimentalGPUDriver = true;

  environment.systemPackages = with pkgs; [
    pinentry-curses
  ];

  # Global fonts
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  programs.git.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  programs.ssh.startAgent = true;
  programs.zsh.enable = true;

  services.logind ={
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
  };

  security.pam.services.swaylock = {};

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "no";

  # Set your time zone.
  services.ntp.enable = true;
  time.timeZone = "Pacific/Auckland";
}

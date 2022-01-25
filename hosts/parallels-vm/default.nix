# System configuration for my dev VMs
{ config, pkgs, system, inputs, ... }:
{
  disabledModules = [ "virtualisation/parallels-guest.nix" ];
  imports = [
    ./hardware-configuration.nix
    ../../modules/parallels-unfree/parallels-guest.nix
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
  time.timeZone = "Australia/Sydney";

  # Global fonts
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    xclip
    (writeShellScriptBin "xrandr-27" ''
      xrandr -s 2560x1440
    '')
    (writeShellScriptBin "xrandr-mbp" ''
      xrandr -s 2560x1600
    '')
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "no";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Disable the firewall since we're in a VM and we want to make it
  # easy to visit stuff in here. We only use NAT networking anyways.
  networking.firewall.enable = false;
  networking.interfaces.enp0s5.useDHCP = true;

  services.xserver = {
    enable = true;
    layout = "us";
    dpi = 220;

    desktopManager = {
      xterm.enable = true;
    };

    displayManager = {
      lightdm = {
        enable = true;
      };
      autoLogin = {
        enable = true;
        user = "keithschulze";
      };
      defaultSession = "hm";
      session = [
        {
          name = "hm";
          manage = "desktop";
          start = "${pkgs.runtimeShell} $HOME/.xsession &
      waitPID=$!";
        }
      ];
      # sessionCommands = ''
      #   ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      #     Xcursor.size: 64;
      #     Xft.dpi: 220;
      #   EOF
      # '';
    };
  };

  # Enable parallel guest mode with prl-tools
  hardware.parallels = {
    enable = true;
    package = (config.boot.kernelPackages.callPackage ../../modules/parallels-unfree/prl-tools.nix {});
  };
}

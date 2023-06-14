{ config, pkgs, system, inputs, ... }:

{
  nix.package = pkgs.nixVersions.stable;

  programs.zsh = {
    enable = true;  # default shell on catalina
    promptInit = "";
  };

  homebrew = {
    enable = true;

    brews = [
      "colima"
      "hyperfine"
      "awscli"
      "jq"
      "curl"
      "unzip"
      "ubuntu/microk8s/microk8s"
    ];

    casks = [
      "1password"
      "arc"
      "datagrip"
      "iterm2"
      "keybase"
      "microsoft-teams"
      "multipass"
      "obsidian"
      "rectangle"
      "zoom"
    ];

    taps = [
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "ubuntu/microk8s"
    ];

    global.autoUpdate = false;
    onActivation = {
      cleanup = "uninstall";
      upgrade = true;
    };
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      roboto
    ];
  };

  system.stateVersion = 4;

  users.users.kschulze = {
    name = "kschulze";
    home = "/Users/kschulze";
  };

  services = {
    nix-daemon.enable = true;
  };

  nix.extraOptions = ''
    system = ${system}
    extra-platforms = x86_64-darwin aarch64-darwin
    keep-outputs = true
    keep-derivations = true
  '';
}

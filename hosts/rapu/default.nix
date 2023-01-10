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
      "docker"
      "docker-compose"
      "hyperfine"
      "awscli"
      "jq"
      "curl"
      "unzip"
    ];

    casks = [
      "arc"
      "1password"
      "datagrip"
      "iterm2"
      "keybase"
      "obsidian"
      "rectangle"
    ];

    taps = [
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
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

{ config, pkgs, system, inputs, ... }:

{
  imports = [
    ../common/global
  ];

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
      "glew"
      "glfw"
      "hyperfine"
    ];

    casks = [
      "1password"
      "fiji"
      "firefox-developer-edition"
      "font-fontawesome"
      "google-chrome"
      "insomnia"
      "iterm2"
      "keybase"
      "microsoft-teams"
      "miniforge"
      "nordvpn"
      "obsidian"
      "ollama"
      "pastebot"
      "rectangle"
      "steam"
      "vnc-viewer"
      "zed"
      "zoom"
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

  users.users.keithschulze = {
    name = "keithschulze";
    home = "/Users/keithschulze";
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

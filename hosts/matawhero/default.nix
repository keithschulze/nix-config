{ pkgs, system, ... }:

{
  imports = [
    ../common/global
  ];

  nix.package = pkgs.nixVersions.latest;

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
      "nvm"
    ];

    casks = [
      "1password"
      "firefox"
      "flutter"
      "font-fontawesome"
      "ghostty"
      "keybase"
      "miniforge"
      "nordvpn"
      "ollama"
      "pastebot"
      "zoom"
    ];

    global.autoUpdate = false;
    onActivation = {
      cleanup = "uninstall";
      upgrade = true;
    };
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      roboto
    ];
  };

  system.stateVersion = 4;

  users.users.keithschulze = {
    name = "keithschulze";
    home = "/Users/keithschulze";
  };

  nix.extraOptions = ''
    system = ${system}
    extra-platforms = x86_64-darwin aarch64-darwin
    keep-outputs = true
    keep-derivations = true
  '';

  nix.settings.trusted-users = [
    "root"
    "keithschulze"
  ];
}

{ pkgs, system, username, ... }:

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
    user = username;

    brews = [
      "docker"
      "docker-compose"
      "glew"
      "glfw"
      "hyperfine"
      "nvm"
    ];

    casks = [
      "1password"
      "fastmail"
      "firefox"
      "flutter"
      "font-fontawesome"
      "ghostty"
      "keybase"
      "miniforge"
      "orion"
      "steam"
      "zen"
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

  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
  };

  nix.extraOptions = ''
    system = ${system}
    extra-platforms = x86_64-darwin aarch64-darwin
    keep-outputs = true
    keep-derivations = true
  '';

  nix.settings.trusted-users = [
    "root"
    "${username}"
  ];
}

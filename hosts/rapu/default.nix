{ pkgs, system, ... }:

let
  user = "kschulze";
in {
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
    user = user;

    brews = [
      "curl"
      "duckdb"
      "hyperfine"
      "jq"
      "poetry"
      "pybind11"
      "unzip"
      "virtualenv"
    ];

    casks = [
      "ghostty"
      "miniforge"
      "ollama"
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

  system.stateVersion = 5;

  users.users.kschulze = {
    name = "${user}";
    home = "/Users/${user}";
  };

  nix.extraOptions = ''
    system = ${system}
    extra-platforms = x86_64-darwin aarch64-darwin
    keep-outputs = true
    keep-derivations = true
  '';
}

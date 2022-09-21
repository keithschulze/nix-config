{ config, pkgs, lib, system, inputs, ... }:

let
  inherit (pkgs) lorri;
in {
  system.stateVersion = 4;

  nix.package = pkgs.nixFlakes;

  programs.zsh = {
    enable = true;  # default shell on catalina
    promptInit = "";
  };

  services.nix-daemon.enable = true;

  launchd.user.agents = {
    "lorri" = {
      serviceConfig = {
        WorkingDirectory = (builtins.getEnv "HOME");
        EnvironmentVariables = { };
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/var/tmp/lorri.log";
        StandardErrorPath = "/var/tmp/lorri.log";
      };
      script = ''
        source ${config.system.build.setEnvironment}
        exec ${lorri}/bin/lorri daemon
      '';
    };
  };
}

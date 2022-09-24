{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    xclip
  ];

  services.xserver = {
    enable = true;
    layout = "us";
    dpi = 220;
    resolutions = lib.mkOverride 10 [
      { x = 2560; y = 1600; }
      { x = 3840; y = 2160; }
    ];

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
    };
  };
}

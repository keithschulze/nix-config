{ config, lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      wofi
    ];
  };

  xdg.configFile."wofi/config".text = ''
    image_size=48
    columns=3
    allow_images=true
    insensitive=true
    term=alacritty

    run-always_parse_args=true
    run-cache_file=/dev/null
    run-exec_search=true
  '';
}

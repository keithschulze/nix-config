{ pkgs, config, inputs, hostname, ... }:

with inputs.nix-colors.lib { inherit pkgs; };

let
  currentScheme.parallels-vm = "tokyonight";
in
{
  imports = [ inputs.nix-colors.homeManagerModule ];

  colorscheme =
    if currentScheme.${hostname} != null then
      inputs.nix-colors.colorSchemes.${currentScheme.${hostname}}
    else
      colorschemeFromPicture {
        path = config.wallpaper;
        kind = currentMode;
      };
}

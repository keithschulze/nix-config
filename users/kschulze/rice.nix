{ inputs, colorscheme, ... }:

{
  imports = [ inputs.nix-colors.homeManagerModule ];

  colorscheme =
    if colorscheme != null then
      inputs.nix-colors.colorSchemes.${colorscheme}
    else
      inputs.nix-colors.colorSchemes.tokyonight;

    home.sessionVariables = {
      SCHEME = colorscheme;
      LIBSEAT_BACKEND = "logind";
    };
}

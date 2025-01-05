{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.aerospace;
  tomlFormat = pkgs.formats.toml { };
in {
  options = {
    programs.aerospace = {
      enable = mkEnableOption "Aerospace";

      package = mkOption {
        type = types.package;
        default = pkgs.aerospace;
        defaultText = literalExpression "pkgs.aerospace";
        description = "The aerospace package to install.";
      };

      settings = mkOption {
        type = tomlFormat.type;
        default = { };
        example = literalExpression ''
          {
            accordion-padding = 30;
            default-root-container-layout = "tiles";

            gaps = {
              inner = {
                horizontal = 10;
                vertical = 10;
              };
              outer = {
                bottom = 10;
                left = 10;
                right = 10;
                top = 10;
              };
            };
          }
        '';
        description = ''
          Configuration written to
          {file}`$XDG_CONFIG_HOME/aerospace/aerospace.toml`
          See <https://nikitabobko.github.io/AeroSpace/guide#configuring-aerospace>
          for more info.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."aerospace/aerospace.toml" = mkIf (cfg.settings != { }) {
      source = tomlFormat.generate "aerospace" cfg.settings;
    };
  };
}

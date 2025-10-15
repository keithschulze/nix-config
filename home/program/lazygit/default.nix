{ colors, ... }:

{
  enable = true;
  settings = {
    gui = {
      theme = {
        lightTheme = false;
        activeBorderColor = [ "#${colors.base0D}" "bold" ];
        inactiveBorderColor = [ "#${colors.base00}" ];
        optionsTextColor = [ "#${colors.base0D}" ];
        selectedLineBgColor = [ "#${colors.base02}" ];
        cherryPickedCommitBgColor = [ "#${colors.base03}" ];
        cherryPickedCommitFgColor = [ "#${colors.base0D}" ];
        unstagedChangesColor = [ "#${colors.base08}" ];
        defaultFgColor = [ "#${colors.base05 }" ];
        searchingActiveBorderColor = [ "#${colors.base0A}" ];
      };

      authorColors = {
        "*" = "#${colors.base0A}";
      };
    };
  };
}

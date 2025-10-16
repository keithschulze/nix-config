{
  extraPackages ? [ ],
  languages ? { },
  ...
}:

{
  enable = true;
  extraPackages = extraPackages;
  languages = languages;
  settings = {
    theme = "catppuccin_macchiato";
    editor = {
      file-picker = {
        hidden = false;
      };
      line-number = "relative";
      mouse = true;
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      soft-wrap = {
        enable = true;
      };
    };
    keys = {
      insert = {
        f = {
          d = "normal_mode";
        };
      };
      normal = {
        "C-g" = [
          ":write-all"
          ":new"
          ":insert-output lazygit"
          ":set mouse false"
          ":set mouse true"
          ":buffer-close!"
          ":redraw"
          ":reload-all"
        ];
      };
    };
  };
}

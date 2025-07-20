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
      line-number = "relative";
      mouse = true;
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
    };
    keys = {
      insert = {
        f = {
          d = "normal_mode";
        };
      };
    };
  };
}

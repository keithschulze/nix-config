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
        C-y = [
          ":sh rm -f /tmp/unique-file"
          ":set mouse false"
          ":insert-output yazi \"%{buffer_name}\" --chooser-file=/tmp/unique-file"
          ":sh printf \"\\x1b[?1049h\\x1b[?2004h\" > /dev/tty"
          ":set mouse true"
          ":open %sh{cat /tmp/unique-file}"
          ":redraw"
        ];
      };
    };
  };
}

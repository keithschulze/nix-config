{ extraExtensions ? [], ... }:

{
  enable = true;
  extensions = [
    "catppuccin"
    "dockerfile"
    "scss"
    "nix"
  ] ++ extraExtensions;
  userKeymaps = builtins.fromJSON(builtins.readFile ./keymap.json);
  userSettings = builtins.fromJSON(builtins.readFile ./settings.json);
}

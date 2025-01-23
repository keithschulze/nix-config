{ extraExtensions ? [], ... }:

{
  enable = true;
  extensions = [
    "catppuccin"
    "dockerfile"
    "docker-compose"
    "scss"
    "nix"
    "terraform"
  ] ++ extraExtensions;
  userKeymaps = builtins.fromJSON(builtins.readFile ./keymap.json);
  userSettings = builtins.fromJSON(builtins.readFile ./settings.json);
}

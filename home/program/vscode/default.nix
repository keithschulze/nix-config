{ pkgs, extraExtensions ? [], extraUserSettings ? {}, ... }:

{
  enable = true;
  enableUpdateCheck = false;
  enableExtensionUpdateCheck = false;
  mutableExtensionsDir = false;
  extensions = with pkgs; [
    vscode-extensions.arrterian.nix-env-selector
    vscode-extensions.bbenoist.nix
    vscode-extensions.catppuccin.catppuccin-vsc
    vscode-extensions.github.copilot
    vscode-extensions.github.copilot-chat
    vscode-extensions.jebbs.plantuml
    vscode-extensions.ms-azuretools.vscode-docker
    vscode-extensions.redhat.vscode-yaml
    vscode-extensions.vscodevim.vim
  ] ++ extraExtensions;

  userSettings = builtins.fromJSON(builtins.readFile ./settings.json) // extraUserSettings;
}

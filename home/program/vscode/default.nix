{ config, pkgs, extraExtensions ? [], ... }:

{
  enable = true;
  enableUpdateCheck = false;
  enableExtensionUpdateCheck = false;
  mutableExtensionsDir = false;
  extensions = with pkgs; [
    vscode-extensions.bbenoist.nix
    vscode-extensions.arrterian.nix-env-selector
    vscode-extensions.ms-azuretools.vscode-docker
    vscode-extensions.redhat.vscode-yaml
    vscode-extensions.vscodevim.vim
    vscode-extensions.github.copilot
    vscode-extensions.github.github-vscode-theme
    vscode-extensions.jebbs.plantuml
  ] ++ extraExtensions;

  userSettings = builtins.fromJSON(builtins.readFile ./settings.json);
}

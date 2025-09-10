{ pkgs, enable ? true, extraExtensions ? [], extraUserSettings ? {}, ... }:

let
  vscode-helix-emulation = (pkgs.vscode-utils.extensionFromVscodeMarketplace
    {
      name = "vscode-helix-emulation";
      publisher = "jasew";
      version = "0.7.0";
      sha256 = "818c885675c6f40b668a4d1cd45b1128eda27459ee7f0976ea73a21f70d83cb6";
    }
  );
in {
  enable = enable;
  mutableExtensionsDir = false;
  profiles = {
    default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs; [
        vscode-extensions.arrterian.nix-env-selector
        vscode-extensions.bbenoist.nix
        vscode-extensions.catppuccin.catppuccin-vsc
        vscode-extensions.github.copilot
        vscode-extensions.github.copilot-chat
        vscode-extensions.jebbs.plantuml
        vscode-extensions.ms-azuretools.vscode-docker
        vscode-extensions.redhat.vscode-yaml
        vscode-helix-emulation
      ] ++ extraExtensions;

      userSettings = builtins.fromJSON(builtins.readFile ./settings.json) // extraUserSettings;
    };
  };
}

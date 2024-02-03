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

  userSettings = {
    "breadcrumbs.enabled" = false;
    "editor.fontFamily" = "JetBrainsMono Nerd Font, Menlo, 'Courier New', monospace";
    "editor.fontSize" = 15;
    "editor.formatOnSave" = false;
    "editor.minimap.enabled" = false;
    "editor.renderControlCharacters" = false;
    "editor.renderWhitespace" = "none";
    "editor.rulers" = [
        100
    ];
    "editor.semanticHighlighting.enabled" = true;
    "editor.suggestSelection" = "first";
    "files.exclude" = {
        "**/.git" = true;
        "**/.svn" = true;
        "**/.hg" = true;
        "**/CVS" = true;
        "**/.DS_Store" = true;
        "**/*.pyc" = true;
        "**/.classpath" = true;
        "**/.project" = true;
        "**/.settings" = true;
        "**/.factorypath" = true;
    };
    "files.insertFinalNewline" = true;
    "files.trimTrailingWhitespace" = true;
    "git.path" = "/Users/keithschulze/.nix-profile/bin/git";
    "markdown.preview.fontSize" = 15;
    "terminal.integrated.fontSize" = 15;
    "terminal.integrated.inheritEnv" = false;
    "terminal.integrated.minimumContrastRatio" = 1;
    "vim.easymotion" = true;
    "vim.enableNeovim" = true;
    "vim.gdefault" = true;
    "vim.leader" = "<space>";
    "vim.neovimPath" = "/Users/keithschulze/.nix-profile/bin/nvim";
    "vim.overrideCopy" = true;
    "vim.sneak" = true;
    "vim.textwidth" = 100;
    "vim.useSystemClipboard" = true;
    "window.restoreWindows" = "none";
    "window.titleBarStyle" = "custom";
    "workbench.activityBar.visible" = true;
    "workbench.colorTheme" = "GitHub Dark";
    "workbench.editor.enablePreviewFromQuickOpen" = false;
    "workbench.editor.showTabs" = "single";
    "workbench.panel.defaultLocation" = "right";
    "workbench.panel.opensMaximized" = "never";
    "workbench.statusBar.visible" = true;
    "vim.insertModeKeyBindings" = [
        {
            "before" = [
                "f"
                "d"
            ];
            "after" = [
                "<Esc>"
            ];
        }
        {
            "before" = [
                "j"
                "k"
            ];
            "after" = [
                "<Esc>"
            ];
        }
    ];
    "vim.normalModeKeyBindingsNonRecursive" = [
        {
            "before" = [
                "<C-l>"
            ];
            "after" = [
                "<C-w>"
                "l"
            ];
        }
        {
            "before" = [
                "<C-h>"
            ];
            "after" = [
                "<C-w>"
                "h"
            ];
        }
        {
            "before" = [
                "<C-j>"
            ];
            "after" = [
                "<C-w>"
                "j"
            ];
        }
        {
            "before" = [
                "<C-k>"
            ];
            "after" = [
                "<C-w>"
                "k"
            ];
        }
        {
            "before" = [
                "leader"
                "w"
                "v"
            ];
            "after" = [
                "<C-w>"
                "v"
            ];
        }
        {
            "before" = [
                "leader"
                "w"
                "h"
            ];
            "after" = [];
            "commands" = [
                {
                    "command" = "workbench.action.splitEditorDown";
                    "args" = [];
                }
            ];
        }
        {
            "before" = [
                "leader"
                "p"
                "t"
            ];
            "after" = [];
            "commands" = [
                {
                    "command" = "workbench.action.toggleSidebarVisibility";
                    "args" = [];
                }
            ];
        }
        {
            "before" = [
                "leader"
                "b"
                "c"
            ];
            "after" = [];
            "commands" = [
                {
                    "command" = "workbench.action.closeActiveEditor";
                    "args" = [];
                }
            ];
        }
        {
            "before" = [
                "leader"
                "f"
            ];
            "after" = [];
            "commands" = [
                {
                    "command" = "workbench.action.quickOpen";
                    "args" = [];
                }
            ];
        }
        {
            "before" = [
                "leader"
                "b"
            ];
            "after" = [];
            "commands" = [
                {
                    "command" = "workbench.action.quickOpen";
                    "args" = [
                        "edt "
                    ];
                }
            ];
        }
        {
            "before" = [
                "leader"
                "t"
            ];
            "after" = [];
            "commands" = [
                {
                    "command" = "workbench.action.terminal.toggleTerminal";
                    "args" = [];
                }
            ];
        }
        {
            "before" = [
                "g"
                "d"
            ];
            "after" = [];
            "commands" = [
                {
                    "command" = "editor.action.revealDefinition";
                    "args" = [];
                }
            ];
        }
        {
            "before" = [
                "g"
                "r"
            ];
            "after" = [];
            "commands" = [
                {
                    "command" = "editor.action.goToReferences";
                    "args" = [];
                }
            ];
        }
        {
            "before" = [
                "leader"
                "c"
                "a"
            ];
            "after" = [];
            "commands" = [
                {
                    "command" = "editor.action.quickFix";
                    "args" = [];
                }
            ];
        }
        {
            "before" = [
                "leader"
                "r"
                "n"
            ];
            "after" = [];
            "commands" = [
                {
                    "command" = "editor.action.rename";
                    "args" = [];
                }
            ];
        }
        {
            "before" = [
                "Shift+k"
            ];
            "after" = [];
            "commands" = [
                {
                    "command" = "editor.action.showHover";
                    "args" = [];
                }
            ];
        }
    ];
    "vim.visualModeKeyBindingsNonRecursive" = [
        {
            "before" = [
                ">"
            ];
            "commands" = [
                "editor.action.indentLines"
            ];
        }
        {
            "before" = [
                "<"
            ];
            "commands" = [
                "editor.action.outdentLines"
            ];
        }
    ];
  };
}

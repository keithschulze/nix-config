{ config, pkgs, ... }:

{
  enable = true;
  extensions = with pkgs; [
    vscode-extensions.bbenoist.nix
    vscode-extensions.arrterian.nix-env-selector
    vscode-extensions.ms-azuretools.vscode-docker
    vscode-extensions.redhat.vscode-yaml
    vscode-extensions.vscodevim.vim
    vscode-extensions.github.github-vscode-theme
    vscode-extensions.matklad.rust-analyzer
    vscode-extensions.jebbs.plantuml
  ];
  userSettings = {
    "workbench.colorTheme" = "GitHub Dark Dimmed";
    "vim.easymotion" = true;
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
                "leader"
                "l"
                "d"
            ];
            "after" = [];
            "commands" = [
                {
                    "command" = "editor.action.peekDefinition";
                    "args" = [];
                }
            ];
        }
        {
            "before" = [
                "leader"
                "l"
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
                "l"
                "q"
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
                "l"
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
                "leader"
                "l"
                "h"
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
    "vim.leader" = "<space>";
    "editor.fontFamily" = "JetBrainsMono Nerd Font, Menlo, 'Courier New', monospace";
    "editor.fontSize" = 15;
    "editor.minimap.enabled" = false;
    "editor.rulers" = [
        80
    ];
    "vim.enableNeovim" = true;
    "vim.textwidth" = 80;
    "vim.neovimPath" = "/Users/keithschulze/.nix-profile/bin/nvim";
    "git.path" = "/Users/keithschulze/.nix-profile/bin/git";
    "vim.gdefault" = true;
    "vim.sneak" = true;
    "vim.useSystemClipboard" = true;
    "vim.overrideCopy" = true;
    "editor.renderWhitespace" = "none";
    "workbench.editor.enablePreviewFromQuickOpen" = false;
    "files.trimTrailingWhitespace" = true;
    "window.restoreWindows" = "none";
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
    "editor.renderControlCharacters" = false;
    "terminal.integrated.fontSize" = 15;
    "terminal.integrated.inheritEnv" = false;
    "markdown.preview.fontSize" = 15;
    "editor.formatOnSave" = true;
    "breadcrumbs.enabled" = true;
    "editor.suggestSelection" = "first";
    "python.languageServer" = "Pylance";
    "python.venvPath" = "/Users/keithschulze/Library/Caches/pypoetry/virtualenvs";
    "workbench.activityBar.visible" = true;
    "workbench.editor.showTabs" = false;
    "files.insertFinalNewline" = true;
  };
}

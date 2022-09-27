{ config, pkgs, ... }:

{
  enable = true;
  extensions = with pkgs; [
    vscode-extensions.bbenoist.nix
    vscode-extensions.ms-azuretools.vscode-docker
    vscode-extensions.redhat.vscode-yaml
    vscode-extensions.vscodevim.vim
    vscode-extensions.matklad.rust-analyzer
  ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "github-vscode-theme";
      publisher = "Github";
      version = "1.1.3";
      sha256 = "a09df93744c400807a8418d110e8b12c480c8c129f439a0996a90159938d618d";
    }
    {
      name = "material-palenight-theme";
      publisher = "whizkydee";
      version = "2.0.2";
      sha256 = "1lh4bz8nfxshi90h1dbliw3mi9sh5m5z46f2dhm5lam4xxfjkwgz";
    }
    {
      name = "plantuml";
      publisher = "jebbs";
      version = "2.15.1";
      sha256 = "030rrzadp39byjh792r0wz4mms622plsf9amkics843nf09zzgkv";
    }
    {
      name = "python";
      publisher = "ms-python";
      version = "2020.8.106424";
      sha256 = "80b7f5704ff8f8094d700bf74cc375d6cc1a753a4ce36a62fb4e46c4d00436bc";
    }
    {
      name = "vscode-pylance";
      publisher = "ms-python";
      version = "2020.11.2";
      sha256 = "0n2dm21vgzir3hx1m3pmx7jq4zy3hdxfsandd2wv5da4fs9b5g50";
    }
    {
      name = "vsliveshare-pack";
      publisher = "MS-vsliveshare";
      version = "0.4.0";
      sha256 = "c5375f3aa772a40696a66b5820cd07ee0c02cb58d7365e7e1daaef556ff70226";
    }
    {
      name = "elixir-ls";
      publisher = "JakeBecker";
      version = "0.6.1";
      sha256 = "1rrbn4vyx033jcbgqhfpqjqahr3qljawljzal8j73kk0z12kqglf";
    }
    {
      name = "nix-env-selector";
      publisher = "arrterian";
      version = "1.0.7";
      sha256 = "0mralimyzhyp4x9q98x3ck64ifbjqdp8cxcami7clvdvkmf8hxhf";
    }
  ];
  userSettings = {
    "workbench.colorTheme" = "Palenight Theme";
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

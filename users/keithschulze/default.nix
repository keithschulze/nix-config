{
  pkgs,
  config,
  lib,
  features,
  username,
  ...
}:

let
  inherit (pkgs) stdenv;
  home = if stdenv.isDarwin then "Users" else "home";
  colors = config.colorscheme.palette;
in
{
  imports = [
    ./rice.nix
  ] ++ map (f: ../../home/features/${f}) features;
  # Import each feature requested

  # Needed for basic operations
  programs = {
    home-manager.enable = true;
  };

  home = {
    inherit username;
    homeDirectory = "/${home}/${username}";
    stateVersion = "22.05";
  };

  home.packages = with pkgs; [
    # utils
    cheat
    htop
    jq
    fd
    fzf
    ripgrep
    vips
    yazi

    # dev
    devenv
    graphviz
    shellcheck
    tmux
    tmuxinator

    # tools
    bun
    cookiecutter
    coursier
    flamelens
    github-cli
    poetry
    sqlite
    terraform
    uv

    # lang servers
    nil
    nixd
    pyright
    rust-analyzer
    terraform-ls

    # Scala
    coursier
    metals
    sbt
  ];

  news.display = "silent";

  programs.aerospace = (import ../../home/program/aerospace/default.nix);

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      nix-aws = {
        hostname = "13.239.106.150";
        user = "root";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
        identityFile = "~/.ssh/id_rsa";
        localForwards = [
          {
            bind.port = 8888;
            host.address = "127.0.0.1";
            host.port = 8888;
          }
        ];
      };
    };
  };

  programs.gpg = {
    enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Keith Schulze";
        email = "keith@schulze.co.nz";
      };
      alias = {
        co = "checkout";
        up = "!git pull --rebase --prune $@";
        cob = "checkout -b";
        cm = "!git add --all && git commit -m";
        save = "!git add --all && git commit -m 'savepoint'";
        wip = "!git add -u && git commit -m 'wip'";
        undo = "reset head~1 --mixed";
        amend = "commit --all --amend";
        wipe = "!git add --all && git commit -qm 'wipe savepoint' && git reset head~1 --hard";
      };
      github.user = "keithschulze";
      color.ui = true;
      push.default = "simple";
      pull.rebase = true;
      merge.conflictstyle = "diff3";
      credential.helper = "osxkeychain";
      diff.tool = "vimdiff";
      difftool.prompt = false;
      core.commitGraph = true;
      gc.writeCommitGraph = true;
      init.defaultBranch = "main";
    };
    signing = {
      key = "D18B101053EEC8C9";
      signByDefault = true;
    };
  };

  programs.lazygit = (import ../../home/program/lazygit/default.nix) { inherit colors; };

  programs.gitui = (import ../../home/program/gitui/default.nix) {
    inherit colors;

    enable = true;
  };

  programs.gemini-cli = {
    enable = true;
    settings = {
      context = {
        fileName = ["AGENT.md"];
        loadMemoryFromIncludeDirectories = true;
      };
      general = {
        preferredEditor = "hx";
        previewFeatures = true;
        vimMode = true;
      };
      mcp = {
        allowed = ["container-use"];
      };
      mcpServers = {
        container-use = {
          command = "container-use";
          args = ["stdio"];
          timeout = 300000;
        };
      };
      privacy = {
        usageStatisticsEnabled = false;
      };
      security = {
        auth = {
          selectedType = "oauth-personal";
        };
      };
      tools = {
        autoAccept = true;
        exclude = [
          "read_file"
          "write_file"
          "replace"
          "run_shell_command"
        ];
        useRipgrep = true;
      };
      ui = {
        theme = "Default";
      };
    };
  };

  programs.java = {
    enable = true;
    package = pkgs.temurin-bin-17;
  };

  programs.helix = (import ../../home/program/helix/default.nix) {
    inherit config pkgs lib;
    extraPackages=[
      pkgs.deno
      pkgs.harper
      pkgs.marksman
      pkgs.ruff
      pkgs.rumdl
      pkgs.ty
      pkgs.typescript-language-server
    ];
    languages = {
      language = [
        {
          name = "javascript";
          auto-format = true;
          roots = ["deno.json" "deno.jsonc" "package.json"];
          file-types = ["js" "jsx"];
          language-servers = ["deno-lsp"];
        }
        {
          name = "markdown";
          auto-format = true;
          language-servers = ["marksman" "harper-ls" "rumdl"];
          soft-wrap = {
            enable = true;
            wrap-at-text-width = true;
          };
          text-width = 100;
        }
        {
          name = "python";
          auto-format = true;
          formatter = {
            command = "ruff";
            args = ["format" "--quiet" "-"];
          };
          language-servers = ["ty"];
          roots = ["pyproject.toml"];
        }
        {
          name = "rust";
          auto-format = true;
        }
        {
          name = "typescript";
          auto-format = true;
          roots = ["deno.json" "deno.jsonc" "package.json"];
          file-types = ["ts" "tsx"];
          language-servers = ["deno-lsp"];
        }
      ];

      language-server.deno-lsp = {
        command = "deno";
        args = ["lsp"];
        config.deno.enable = true;
      };

      language-server.harper-ls = {
        command = "harper-ls";
        args = ["--stdio"];
      };

      language-server.rumdl = {
        command = "rumdl";
        args = ["server"];
      };

      language-server.rust-analyzer = {
        config = {
          checkOnSave = {
            command = "clippy";
          };
          cargo = {
            allFeatures = true;
          };
        };
      };

      language-server.ty = {
        command = "ty";
        args = ["server"];
      };
    };
  };

  programs.opencode = {
    enable = true;

    settings = {
      autoshare = false;
      autoupdate = false;
      theme = "catppuccin-macchiato";

      agent = {
        build = {
          mode = "primary";
          model = "google/gemini-3-pro-preview";
          prompt = ''
            ALWAYS use ONLY Environments for ANY and ALL file, code, or shell operations—NO EXCEPTIONS—even for simple or generic requests.

            DO NOT install or use the git cli with the environment_run_cmd tool. All environment tools will handle git operations for you. Changing ".git" yourself will compromise the integrity of your environment.

            You MUST inform the user how to view your work using `container-use log <env_id>` AND `container-use checkout <env_id>`. Failure to do this will make your work inaccessible to others.
          ''; 
          tools = {
            bash = false;
            write = false;
            edit = false;
            read = false;
            list = false;
            lsp = false;
            patch = false;
            skill = false;
        
            "mcp__container-use*" = true;
          };
        };
      };

      mcp = {
        container-use = {
          enabled = true;
          type = "local";
          command = ["container-use" "stdio"];
          timeout = 300000;
        };
      };
      plugin = [
        "opencode-gemini-auth@1.3.8"
      ];
    };
  };

  programs.vscode = (import ../../home/program/vscode/default.nix) {
    inherit config pkgs;
    enable = false;
    extraExtensions = with pkgs; [
      vscode-extensions.hashicorp.terraform
      vscode-extensions.ms-python.python
      vscode-extensions.ms-pyright.pyright
      vscode-extensions.rust-lang.rust-analyzer
      vscode-extensions.tomoki1207.pdf
      vscode-extensions.dart-code.dart-code
      vscode-extensions.dart-code.flutter
    ];
    extraUserSettings = builtins.fromJSON (builtins.readFile ./config/vscode/settings.json);
  };

  programs.zed-editor = (import ../../home/program/zed/default.nix) {
    inherit config pkgs;
  };

  programs.zsh = lib.attrsets.recursiveUpdate (import ../../home/program/zsh/default.nix) {
    shellAliases = {
      cu = "container-use";
    };

    initContent = ''
      if [ -n "''\${commands[fzf-share]}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi

      # >>> conda initialize >>>
      # !! Contents within this block are managed by 'conda init' !!
      __conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
      if [ $? -eq 0 ]; then
          eval "$__conda_setup"
      else
          if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
              . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
          else
              export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
          fi
      fi
      unset __conda_setup
      # <<< conda initialize <<<

      export NVM_DIR="$HOME/.nvm"
      [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
      [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

      PATH=/Users/keithschulze/.cargo/bin:/Users/keithschulze/.docker/bin:/Users/keithschulze/.local/bin:/opt/homebrew/bin:/opt/homebrew/opt/openjdk/bin:$PATH
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker-compose"
        "fzf"
        "gcloud"
        "terraform"
        "tmux"
        "kubectl"
      ];
    };
    sessionVariables = {
      DAGGER_NO_NAG = "1";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = false;

    nix-direnv = {
      enable = true;
    };
  };

  home.file.".config/nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  home.file.".config/tmuxinator/home.yml".text =
    builtins.readFile ../../home/config/tmuxinator/home.yml;
  home.file.".config/ghostty/config".text = builtins.readFile ../../home/config/ghostty/config;
}

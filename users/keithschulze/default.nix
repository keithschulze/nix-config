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
  extraVimPlugins = with pkgs.vimPlugins; [
    parinfer-rust
    copilot-vim
    {
      plugin = nvim-metals;
      type = "lua";
      config = ''
        local metals_config = require("metals").bare_config()

        metals_config.settings = {
          showImplicitArguments = true,
          excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        }
        metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

        local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
          -- NOTE: You may or may not want java included here. You will need it if you
          -- want basic Java support but it may also conflict if you are using
          -- something like nvim-jdtls which also works on a java filetype autocmd.
          pattern = { "scala", "sbt", "java" },
          callback = function()
            require("metals").initialize_or_attach(metals_config)
          end,
          group = nvim_metals_group,
        })
      '';
    }
  ];
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
    htop
    jq
    ripgrep
    fzf
    fd
    cheat
    # hurl

    # dev
    devenv
    shellcheck
    tmux
    tmuxinator
    graphviz

    # tools
    coursier
    github-cli
    poetry
    cookiecutter
    terraform
    podman
    sqlite
    uv

    # lang servers
    nil
    nixd
    pyright
    rust-analyzer
    terraform-ls

    # Scala
    coursier
    sbt
    metals
  ];

  news.display = "silent";

  programs.aerospace = {
    enable = false;

    userSettings = {
      start-at-login = false;

      gaps = {
        inner = {
          horizontal = 5;
          vertical = 5;
        };
        outer = {
          bottom = 5;
          left = 5;
          right = 5;
          top = 5;
        };
      };

      after-login-command = [ ];
      after-startup-command = [ ];

      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";

      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      automatically-unhide-macos-hidden-apps = false;

      key-mapping.preset = "qwerty";

      mode.main.binding = {
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";

        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
        alt-f = "fullscreen";

        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        alt-shift-minus = "resize smart -50";
        alt-shift-equal = "resize smart +50";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";

        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";

        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        alt-shift-semicolon = "mode service";
        alt-b = "exec-and-forget open -n -a 'Firefox' --args '--new-window'";
      };

      mode.service.binding = {
        esc = [
          "reload-config"
          "mode main"
        ];
        r = [
          "flatten-workspace-tree"
          "mode main"
        ]; # reset layout
        f = [
          "layout floating tiling"
          "mode main"
        ]; # Toggle between floating and tiling layout
        backspace = [
          "close-all-windows-but-current"
          "mode main"
        ];

        alt-shift-h = [
          "join-with left"
          "mode main"
        ];
        alt-shift-j = [
          "join-with down"
          "mode main"
        ];
        alt-shift-k = [
          "join-with up"
          "mode main"
        ];
        alt-shift-l = [
          "join-with right"
          "mode main"
        ];

        down = "volume down";
        up = "volume up";
        shift-down = [
          "volume set 0"
          "mode main"
        ];
      };
      on-window-detected = [
        {
          "if".app-id = "com.mitchellh.ghostty";
          run = [ "layout tiling" ];
        }
      ];
    };
  };

  programs.ssh = {
    enable = true;
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
    userName = "Keith Schulze";
    userEmail = "keith@schulze.co.nz";
    aliases = {
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
    extraConfig = {
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

  programs.gitui = {
    enable = true;
    keyConfig = ''
      (
        open_help: Some(( code: F(1), modifiers: "")),
        move_left: Some(( code: Char('h'), modifiers: "")),
        move_right: Some(( code: Char('l'), modifiers: "")),
        move_up: Some(( code: Char('k'), modifiers: "")),
        move_down: Some(( code: Char('j'), modifiers: "")),
        popup_up: Some(( code: Char('p'), modifiers: "CONTROL")),
        popup_down: Some(( code: Char('n'), modifiers: "CONTROL")),
        page_up: Some(( code: Char('b'), modifiers: "CONTROL")),
        page_down: Some(( code: Char('f'), modifiers: "CONTROL")),
        home: Some(( code: Char('g'), modifiers: "")),
        end: Some(( code: Char('G'), modifiers: "SHIFT")),
        shift_up: Some(( code: Char('K'), modifiers: "SHIFT")),
        shift_down: Some(( code: Char('J'), modifiers: "SHIFT")),
        edit_file: Some(( code: Char('I'), modifiers: "SHIFT")),
        status_reset_item: Some(( code: Char('U'), modifiers: "SHIFT")),
        diff_reset_lines: Some(( code: Char('u'), modifiers: "")),
        diff_stage_lines: Some(( code: Char('s'), modifiers: "")),
        stashing_save: Some(( code: Char('w'), modifiers: "")),
        stashing_toggle_index: Some(( code: Char('m'), modifiers: "")),
        stash_open: Some(( code: Char('l'), modifiers: "")),
        abort_merge: Some(( code: Char('M'), modifiers: "SHIFT")),
      )
    '';
    theme = ''
      (
        selected_tab: Some("Reset"),
        selection_bg: Some("#${colors.base00}"),
        selection_fg: Some("#${colors.base0D}"),
        command_fg: Some("#${colors.base0D}"),
        cmdbar_bg: Some("#${colors.base00}"),
        cmdbar_extra_lines_bg: Some("#${colors.base00}"),
        disabled_fg: Some("#${colors.base04}"),
        diff_line_add: Some("#${colors.base0B}"),
        diff_line_delete: Some("#${colors.base08}"),
        diff_file_added: Some("#${colors.base0B}"),
        diff_file_removed: Some("#${colors.base08}"),
        diff_file_moved: Some("#${colors.base0E}"),
        diff_file_modified: Some("#${colors.base0A}"),
        commit_hash: Some("#${colors.base0E}"),
        commit_time: Some("#${colors.base0C}"),
        commit_author: Some("#${colors.base0B}"),
        danger_fg: Some("#${colors.base08}"),
        push_gauge_bg: Some("#${colors.base00}"),
        push_gauge_fg: Some("Reset"),
        tag_fg: Some("#${colors.base0E}"),
        branch_fg: Some("#${colors.base0A}"),
      )
    '';
  };

  programs.java = {
    enable = true;
    package = pkgs.temurin-bin-17;
  };

  programs.helix = (import ../../home/program/helix/default.nix) {
    inherit config pkgs lib;
    languages = {
      language = [
        {
          name = "rust";
          auto-format = true;
        }
      ];

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
    };
  };

  programs.neovim = (import ../../home/program/neovim/default.nix) {
    inherit config pkgs lib;
    lsps = [
      "nixd"
      "pyright"
      "rust_analyzer"
      "terraformls"
    ];
    extraPlugins = extraVimPlugins;
  };

  programs.tmux = (import ../../home/program/tmux/default.nix) { inherit pkgs; };

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

      PATH=/Users/keithschulze/.cargo/bin:/opt/homebrew/bin:/opt/homebrew/opt/openjdk/bin:$PATH
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
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

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

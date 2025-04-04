{ pkgs, config, lib, features, username, ... }:

let
  inherit (pkgs) stdenv;
  home = if stdenv.isDarwin then "Users" else "home";
  gantry = (import ../../modules/gantry) { inherit stdenv; inherit pkgs; };
  aws-auth = (import ../../modules/aws-auth) { inherit stdenv; inherit pkgs; };
  colors = config.colorscheme.palette;

  extraVimPlugins = with pkgs.vimPlugins; [
    copilot-vim
    {
      plugin = avante-nvim;
      type = "lua";
      config = ''
        require("avante_lib").load()
        require("avante").setup({
          provider = "copilot"
        })
      '';
    }
  ];
  dbt-vscode = (pkgs.vscode-utils.extensionFromVscodeMarketplace
    {
      name = "vscode-dbt-power-user";
      publisher = "innoverio";
      version = "0.47.4";
      sha256 = "d6643b32d75eae68d001bb6623f2ae1de71016ed02c9da813305c53f27e5b944";
    }
  );
in {
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
    stateVersion = "23.05";
  };

  home.packages = with pkgs; [
    # utils
    cloc
    coreutils
    fzf
    jq
    gettext
    htop
    ripgrep
    tree

    # dev
    shellcheck
    tmux
    tmuxinator

    # languages
    nodejs
    python312

    # tools
    aws-auth
    docker
    docker-buildx
    docker-compose
    gantry
    github-cli
    ssm-session-manager-plugin
    terraform
    jetbrains.datagrip

    # lang clients
    terraform-ls
    pyright
  ];

  news.display = "silent";

  programs.aerospace = {
    enable = true;

    userSettings = {
      start-at-login = true;

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

      after-login-command = [];
      after-startup-command = [];

      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";

      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
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
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";

        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";

        # alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        alt-shift-semicolon = "mode service";
        alt-b = "exec-and-forget open -n -a 'Google Chrome' --args '--new-window'";
      };

      mode.service.binding = {
        esc = ["reload-config" "mode main"];
        r = ["flatten-workspace-tree" "mode main"]; # reset layout
        f = ["layout floating tiling" "mode main"]; # Toggle between floating and tiling layout
        backspace = ["close-all-windows-but-current" "mode main"];

        alt-shift-h = ["join-with left" "mode main"];
        alt-shift-j = ["join-with down" "mode main"];
        alt-shift-k = ["join-with up" "mode main"];
        alt-shift-l = ["join-with right" "mode main"];

        down = "volume down";
        up = "volume up";
        shift-down = ["volume set 0" "mode main"];
      };

      on-window-detected = [
        {
          "if".app-id = "com.mitchellh.ghostty";
          run = ["layout tiling"];
        }
      ];
    };
  };

  programs.awscli = {
    enable = true;
    settings = {
      default = {
        region = "ap-southeast-2";
        output = "json";
      };

      "profile au-dev-priv" = {
        region = "ap-southeast-2";
        output = "json";
        credential_process = "${aws-auth}/bin/aws-auth -a 'Amazon Web Services (Unified)' -f seek-hirer-ad-usage-dev-sso-priv --credential-process";
      };

      "profile au-prod-ro" = {
        region = "ap-southeast-2";
        output = "json";
        credential_process = "${aws-auth}/bin/aws-auth -a 'Amazon Web Services (Unified)' -f seek-hirer-ad-usage-prod-sso-read --credential-process";
      };

      "profile au-prod-priv" = {
        region = "ap-southeast-2";
        output = "json";
        credential_process = "${aws-auth}/bin/aws-auth -a 'Amazon Web Services (Unified)' -f seek-hirer-ad-usage-prod-sso-priv --credential-process";
      };

      "profile tsu-dev-priv" = {
        region = "ap-southeast-2";
        output = "json";
        credential_process = "${aws-auth}/bin/aws-auth -a 'Amazon Web Services (Unified)' -f seek-hirer-talent-search-usage-dev-sso-priv --credential-process";
      };

      "profile tsu-prod-ro" = {
        region = "ap-southeast-2";
        output = "json";
        credential_process = "${aws-auth}/bin/aws-auth -a 'Amazon Web Services (Unified)' -f seek-hirer-talent-search-usage-prod-sso-read --credential-process";
      };

      "profile tsu-prod-priv" = {
        region = "ap-southeast-2";
        output = "json";
        credential_process = "${aws-auth}/bin/aws-auth -a 'Amazon Web Services (Unified)' -f seek-hirer-talent-search-usage-prod-sso-priv --credential-process";
      };

      "profile ir-dev-priv" = {
        region = "ap-southeast-2";
        output = "json";
        credential_process = "${aws-auth}/bin/aws-auth -a 'Amazon Web Services (Unified)' -f seek-hirer-insights-role-dev-sso-priv --credential-process";
      };

      "profile ir-prod-ro" = {
        region = "ap-southeast-2";
        output = "json";
        credential_process = "${aws-auth}/bin/aws-auth -a 'Amazon Web Services (Unified)' -f seek-hirer-insights-role-prod-sso-read --credential-process";
      };

      "profile ir-prod-priv" = {
        region = "ap-southeast-2";
        output = "json";
        credential_process = "${aws-auth}/bin/aws-auth -a 'Amazon Web Services (Unified)' -f seek-hirer-insights-role-prod-sso-priv --credential-process";
      };

      "profile data-dev-priv" = {
        region = "ap-southeast-2";
        output = "json";
        credential_process = "${aws-auth}/bin/aws-auth -a 'Amazon Web Services (Unified)' -f seek-hirer-insights-data-dev-sso-priv --credential-process";
      };

      "profile data-prod-ro" = {
        region = "ap-southeast-2";
        output = "json";
        credential_process = "${aws-auth}/bin/aws-auth -a 'Amazon Web Services (Unified)' -f seek-hirer-insights-data-prod-sso-read --credential-process";
      };

      "profile data-prod-priv" = {
        region = "ap-southeast-2";
        output = "json";
        credential_process = "${aws-auth}/bin/aws-auth -a 'Amazon Web Services (Unified)' -f seek-hirer-insights-data-prod-sso-priv --credential-process";
      };

      "profile dp-prod" = {
        region = "ap-southeast-2";
        output = "json";
        credential_process = "${aws-auth}/bin/aws-auth -a 'Amazon Web Services (Classic)' -f adfs-data-platform-prod-seek-analytics --credential-process";
      };
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
        identityFile = "~/.ssh/id_ed25519";
      };
   };
  };

  programs.gpg = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Keith Schulze";
    userEmail = "kschulze@seek.co.nz";
    aliases = {
      co = "checkout";
      up = "!git pull --rebase --prune $@";
      cob = "checkout -b";
      cm = "!git add -a && git commit -m";
      save = "!git add -a && git commit -m 'savepoint'";
      wip = "!git add -u && git commit -m 'wip'";
      undo = "reset head~1 --mixed";
      amend = "commit -a --amend";
      wipe = "!git add -a && git commit -qm 'wipe savepoint' && git reset head~1 --hard";
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
      key = "85AD7BCF4C5D6105";
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

  programs.neovim = (import ../../home/program/neovim/default.nix) {
    inherit config pkgs lib;
    lsps = [
      "pyright"
      "terraformls"
    ];
    extraPlugins = extraVimPlugins;
  };

  programs.tmux = (import ../../home/program/tmux/default.nix) { inherit pkgs; };

  programs.vscode = (import ../../home/program/vscode/default.nix) {
    inherit config pkgs;
    extraExtensions = with pkgs; [
      dbt-vscode
      vscode-extensions.ms-vscode-remote.remote-containers
      vscode-extensions.hashicorp.terraform
      vscode-extensions.ms-python.python
      vscode-extensions.ms-pyright.pyright
      vscode-extensions.samuelcolvin.jinjahtml
    ];

    extraUserSettings = builtins.fromJSON (builtins.readFile ./config/vscode/settings.json);
  };

  programs.zsh = lib.attrsets.recursiveUpdate (import ../../home/program/zsh/default.nix) {
    initExtra = ''
      if [ -n "''\${commands[fzf-share]}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi

      if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
          . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
      else
          export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
      fi

      function auth-aws-env { eval "$(aws configure export-credentials --profile $1 --format env)"; }

      function timezsh() {
        shell=''\${1-$SHELL}
        for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
      }
    '';

    shellAliases = {
      nixconf = "cd ~/Development/github/nix-config";
      hisi = "cd ~/Development/github/hirer-insights-shared-infra";
      hard = "cd ~/Development/github/hirer-ad-rating-data";
      haud = "cd ~/Development/github/hirer-ad-usage-data";
      hapd = "cd ~/Development/github/hirer-ad-performance-data";
      hird = "cd ~/Development/github/hirer-insights-role-data";
      htsud = "cd ~/Development/github/hirer-talent-search-usage-data";
      hidi = "cd ~/Development/github/hirer-insights-data-interchange";
      hdbt = "cd ~/Development/github/dataplatform-dbt-hirer-analytics";

      auth-okta = "${aws-auth}/bin/aws-auth --auth-only -a 'Amazon Web Services (Unified)'";

      auth-au-dev-priv = "auth-aws-env au-dev-priv";
      auth-au-prod-ro = "auth-aws-env au-prod-ro";
      auth-au-prod-priv = "auth-aws-env au-prod-priv";

      auth-tsu-dev-priv = "auth-aws-env tsu-dev-priv";
      auth-tsu-prod-ro = "auth-aws-env tsu-prod-ro";
      auth-tsu-prod-priv = "auth-aws-env tsu-prod-priv";

      auth-ir-dev-priv = "auth-aws-env ir-dev-priv";
      auth-ir-prod-ro = "auth-aws-env ir-prod-ro";
      auth-ir-prod-priv = "auth-aws-env ir-prod-priv";

      auth-data-dev-priv = "auth-aws-env data-dev-priv";
      auth-data-prod-ro = "auth-aws-env data-prod-ro";
      auth-data-prod-priv = "auth-aws-env data-prod-priv";

      auth-dp-prod = "auth-aws-env dp-prod";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker-compose"
        "terraform"
        "tmux"
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

  home.file.".config/tmuxinator/seek.yml".text = builtins.readFile ../../home/config/tmuxinator/seek.yml;
  home.file.".config/ghostty/config".text = builtins.readFile ../../home/config/ghostty/config;
}

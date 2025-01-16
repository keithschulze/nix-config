{ pkgs, config, lib, features, username, ... }:

let
  inherit (pkgs) stdenv;
  home = if stdenv.isDarwin then "Users" else "home";
  gantry = (import ../../modules/gantry) { inherit stdenv; inherit pkgs; };
  aws-auth = (import ../../modules/aws-auth) { inherit stdenv; inherit pkgs; };
  colors = config.colorscheme.palette;

  extraVimPlugins = with pkgs.vimPlugins; [
    copilot-vim
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
    ../../modules/aerospace
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
    htop
    ripgrep
    jump
    tree

    # editors
    helix

    # dev
    shellcheck
    tmux
    tmuxinator

    # languages
    nodejs

    # tools
    aws-auth
    awscli2
    # dbt
    docker
    docker-buildx
    docker-compose
    gantry
    github-cli
    ssm-session-manager-plugin
    terraform

    # lang clients
    terraform-ls
    pyright

    # Scala
    coursier
    sbt
    metals
  ];

  news.display = "silent";

  programs.aerospace = {
    enable = true;

    settings = {
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

        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";

        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        alt-shift-semicolon = "mode service";
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

  programs.zed-editor = (import ../../home/program/zed/default.nix) {
    inherit config pkgs;
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

      function awsauth { aws-auth "$@"; [[ -r "$HOME/.aws/sessiontoken" ]] && . "$HOME/.aws/sessiontoken"; }

      function timezsh() {
        shell=''\${1-$SHELL}
        for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
      }
    '';

    shellAliases = {
      auth-unified = "awsauth --app 'Amazon Web Services (Unified)'";
      auth-classic = "awsauth --app 'Amazon Web Services (Classic)'";

      auth-au-dev-priv = "awsauth --app 'Amazon Web Services (Unified)' -f apac-hirer-analytics-adusage-dev-sso-priv";
      auth-au-prod-ro = "awsauth --app 'Amazon Web Services (Unified)' -f apac-hirer-analytics-adusage-prod-sso-read";
      auth-au-prod-priv = "awsauth --app 'Amazon Web Services (Unified)' -f apac-hirer-analytics-adusage-prod-sso-priv";

      auth-tsu-dev-priv = "awsauth --app 'Amazon Web Services (Unified)' -f apac-hirer-analytics-talent-search-usage-dev-sso-priv";
      auth-tsu-prod-ro = "awsauth --app 'Amazon Web Services (Unified)' -f apac-hirer-analytics-talent-search-usage-prod-sso-read";
      auth-tsu-prod-priv = "awsauth --app 'Amazon Web Services (Unified)' -f apac-hirer-analytics-talent-search-usage-prod-sso-priv";

      auth-ir-dev-priv = "awsauth --app 'Amazon Web Services (Unified)' -f seek-apac-hirer-insights-role-dev-sso-priv";
      auth-ir-prod-ro = "awsauth --app 'Amazon Web Services (Unified)' -f seek-apac-hirer-insights-role-prod-sso-read";
      auth-ir-prod-priv = "awsauth --app 'Amazon Web Services (Unified)' -f seek-apac-hirer-insights-role-prod-sso-priv";

      auth-data-dev-priv = "awsauth --app 'Amazon Web Services (Unified)' -f apac-hirer-analytics-data-dev-sso-priv";
      auth-data-prod-ro = "awsauth --app 'Amazon Web Services (Unified)' -f apac-hirer-analytics-data-prod-sso-read";
      auth-data-prod-priv = "awsauth --app 'Amazon Web Services (Unified)' -f apac-hirer-analytics-data-prod-sso-priv";

      auth-dp-prod = "awsauth --app 'Amazon Web Services (Classic)' -f adfs-data-platform-prod-seek-analytics";
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

  home.file.".config/helix/config.toml".text = builtins.readFile ../../home/config/helix/config.toml;
  home.file.".config/tmuxinator/seek.yml".text = builtins.readFile ../../home/config/tmuxinator/seek.yml;
}

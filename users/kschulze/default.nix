{ pkgs, config, lib, features, username, colorscheme, ... }:

let
  inherit (pkgs) stdenv;
  home = if stdenv.isDarwin then "Users" else "home";
  gantry = (import ../../modules/gantry) { inherit stdenv; inherit pkgs; };
  aws-auth = (import ../../modules/aws-auth) { inherit stdenv; inherit pkgs; };
  jump = (import ../../modules/jump) { inherit stdenv; inherit pkgs; inherit lib; };
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
    argocd
    aws-auth
    awscli2
    # dbt
    docker
    docker-buildx
    docker-compose
    gantry
    github-cli
    kubectl
    kubernetes-helm
    kubeseal
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
  };

  programs.zsh = lib.attrsets.recursiveUpdate (import ../../home/program/zsh/default.nix) {
    initExtra = ''
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

      function awsauth { aws-auth "$@"; [[ -r "$HOME/.aws/sessiontoken" ]] && . "$HOME/.aws/sessiontoken"; }
    '';

    shellAliases = {
      auth-unified = "awsauth --app 'Amazon Web Services (Unified)'";
      auth-classic = "awsauth --app 'Amazon Web Services (Classic)'";

      auth-analytics-dev-priv = "awsauth --app 'Amazon Web Services (Unified)' -f seek-analytics-dev-sso-priv";
      auth-analytics-prod-ro = "awsauth --app 'Amazon Web Services (Unified)' -f seek-analytics-prod-sso-read";
      auth-analytics-prod-priv = "awsauth --app 'Amazon Web Services (Unified)' -f seek-analytics-prod-sso-priv";

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

      jump-adusage-search = "jump -t adusage-search -e prod -p 10000";

      jump-argocd-dev-primary-green = "jump -t argocd.data -e dev -p 9997";
      jump-argocd-prod-primary-green = "jump -t argocd.data -e prod -p 9996";

      jump-airflow-dev-primary-green = "jump -t airflow.data -e dev -p 9998";
      jump-airflow-prod-primary-green = "jump -t airflow.data -e prod -p 9995";
      jump-airflow-prod-dark-green = "jump -t airflow-dark.data -e prod -p 9994";
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
  home.file.".config/zed/keymap.json".text = builtins.readFile ../../home/config/zed/keymap.json;
  home.file.".config/zed/settings.json".text = builtins.readFile ../../home/config/zed/settings.json;
}

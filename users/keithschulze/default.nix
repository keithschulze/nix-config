{ pkgs, config, lib, features, username, colorscheme, ... }:

let
  inherit (pkgs) stdenv;
  home = if stdenv.isDarwin then "Users" else "home";
  extraVimPlugins = with pkgs.vimPlugins; [
    parinfer-rust
    copilot-vim
  ];
  colors = config.colorscheme.palette;
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
    stateVersion = "22.05";
  };

  home.packages = with pkgs; [
    # utils
    jq
    ripgrep
    fzf
    fd
    cheat
    hurl

    # editors
    helix

    # dev
    devenv
    shellcheck
    tmux
    tmuxinator
    graphviz

    # tools
    github-cli
    poetry
    cookiecutter
    terraform
    podman
    sqlite
    uv

    # lang clients
    terraform-ls
    rust-analyzer
    pyright

    # Scala
    coursier
    sbt
    metals
  ];

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

  programs.neovim = (import ../../home/program/neovim/default.nix) {
    inherit config pkgs lib;
    lsps = [
      "pyright"
      "rust_analyzer"
      "terraformls"
      "hls"
    ];
    extraPlugins = extraVimPlugins;
  };

  programs.tmux = (import ../../home/program/tmux/default.nix) { inherit pkgs; };

  programs.vscode = (import ../../home/program/vscode/default.nix) {
    inherit config pkgs;
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

  home.file.".config/helix/config.toml".text = builtins.readFile ../../home/config/helix/config.toml;
  home.file.".config/tmuxinator/home.yml".text = builtins.readFile ../../home/config/tmuxinator/home.yml;
}

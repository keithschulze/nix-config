{ pkgs, config, lib, features, username, colorscheme, ... }:

let
  inherit (pkgs) stdenv;
  home = if stdenv.isDarwin then "Users" else "home";
  extraVimPlugins = with pkgs.vimPlugins; [
    parinfer-rust
    copilot-vim
  ];
  autodeskAutolisp = (pkgs.vscode-utils.extensionFromVscodeMarketplace
     {
       name = "autolispext";
       publisher = "Autodesk";
       version = "1.6.2";
       sha256 = "6a58a6718775ad5c5ff71d05c5c7f8d714f794538d552dc5de6ed9b68c592592";
     })
     .overrideAttrs (_: {
       sourceRoot = "extension";
     });
  rocExtension = (pkgs.vscode-utils.extensionFromVscodeMarketplace
     {
       name = "roc-lang-unofficial";
       publisher = "IvanDemchenko";
       version = "1.2.0";
       sha256 = "94c37a1a550cdb4a6d83573a7cda7c8f04b3942cc4d54d2e811ca144b6063c61";
     });
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
    htop
    fzf
    ripgrep
    fd
    cheat

    # editors
    helix

    # dev
    shellcheck
    tmux
    tmuxinator
    graphviz

    # languages
    nodejs

    # tools
    github-cli
    poetry
    cookiecutter
    terraform
    devbox
    podman
    sqlite

    # lang clients
    ocamlPackages.ocaml-lsp
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

  programs.neovim = (import ../../home/program/neovim/default.nix) {
    inherit config pkgs lib;
    lsps = [
      "pyright"
      "rust_analyzer"
      "terraformls"
      "ocamllsp"
      "hls"
    ];
    extraPlugins = extraVimPlugins;
  };

  programs.tmux = (import ../../home/program/tmux/default.nix) { inherit pkgs; };

  programs.vscode = (import ../../home/program/vscode/default.nix) {
    inherit config pkgs;
    extraExtensions = with pkgs; [
      vscode-extensions.matklad.rust-analyzer
      autodeskAutolisp
      rocExtension
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

      PATH=/Users/keithschulze/.cargo/bin:/opt/homebrew/bin:/opt/homebrew/opt/openjdk/bin:$PATH
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker-compose"
        "gcloud"
        "ripgrep"
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

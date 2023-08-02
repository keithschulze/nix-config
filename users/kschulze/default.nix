{ pkgs, config, lib, features, username, colorscheme, ... }:

let
  inherit (pkgs) stdenv;
  home = if stdenv.isDarwin then "Users" else "home";
  gantry = (import ../../modules/gantry) { inherit stdenv; inherit pkgs; };
  jump = (import ../../modules/jump) { inherit stdenv; inherit pkgs; inherit lib; };

  extraVimPlugins = with pkgs.vimPlugins; [
    copilot-vim
  ];
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
    fzf
    jq
    htop
    ripgrep
    jump

    # editors
    helix

    # dev
    shellcheck
    tmux
    tmuxinator

    # tools
    docker
    docker-buildx
    docker-compose
    awscli2
    ssm-session-manager-plugin
    gantry
    terraform
    kubectl
    kubernetes-helm
    argocd
    kubeseal

    # lang clients
    terraform-ls
    pyright

    # Scala
    coursier
  ];

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

  programs.neovim = (import ../../home/program/neovim/default.nix) {
    inherit config pkgs lib;
    lsps = [
      "pyright"
      "terraformls"
    ];
    extraPlugins = extraVimPlugins;
  };

  programs.tmux = (import ../../home/program/tmux/default.nix) { inherit pkgs; };

  programs.vscode = (import ../../home/program/vscode/default.nix) { inherit config; inherit pkgs; };

  programs.zsh = lib.attrsets.recursiveUpdate (import ../../home/program/zsh/default.nix) {
    initExtra = ''
      if [ -n "''\${commands[fzf-share]}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi

      function awsauth { /Users/kschulze/Development/github/aws-auth-bash/auth.sh "$@"; [[ -r "$HOME/.aws/sessiontoken" ]] && . "$HOME/.aws/sessiontoken"; }
    '';

    shellAliases = {
      analytics-prod-ro = "awsauth --app 'Amazon Web Services (Unified)' --role ***REMOVED***";
      analytics-prod-eng = "awsauth --app 'Amazon Web Services (Unified)' --role ***REMOVED***";
      analytics-prod-data = "awsauth --app 'Amazon Web Services (Unified)' --role ***REMOVED***";
      analytics-prod-priv = "awsauth --app 'Amazon Web Services (Unified)' --role ***REMOVED***";
      analytics-dev = "awsauth --app 'Amazon Web Services (Unified)' --role ***REMOVED***";
      data-prod = "awsauth --app 'Amazon Web Services (Classic)' --role ***REMOVED***";

      jump-argocd-prod-primary = "jump -o -t argocd.workflow-services -e prod -p 9997";
      jump-airflow-prod-primary = "jump -t airflow.workflow-services -e prod -p 9998";
      jump-airflow-prod-dark = "jump -t airflow-dark.workflow-services -e prod -p 9999";
      jump-adusage-search = "jump -t adusage-search -e prod -p 10000";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker-compose"
        "gcloud"
        "ripgrep"
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

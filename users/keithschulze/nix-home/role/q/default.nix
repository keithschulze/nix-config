
{ config, lib, pkgs, ... }:
let
  vscodeBase = (import ../../program/vscode/default.nix) { inherit config; inherit pkgs; };
  vscodeBaseExts = vscodeBase.extensions;
  extraVimPlugins = with pkgs.vimPlugins; [
    # Clojure
    conjure
    vim-jack-in
    parinfer-rust
  ];
in {

  home.packages = with pkgs; [
    # utils
    jq
    htop
    fzf
    ripgrep
    fd

    # dev
    shellcheck
    tmux
    tmuxinator
    graphviz

    # editors
    helix

    # languages
    nodejs

    # tools
    terraform
    poetry
    black
    cookiecutter
    awscli2

    # lang servers
    terraform-ls
    clojure-lsp
    pyright
  ];

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
        identityFile = "~/.ssh/id_ed25519_qantas";
      };

      "personal.github.com" = {
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
    userEmail = "keith.schulze@qantashotels.com";
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
      pager.log = true;
    };
    signing = {
      key = "590798CAC6DB53F3";
      signByDefault = true;
    };
  };

  programs.neovim = (import ../../program/neovim/default.nix) {
    inherit config pkgs lib;
    lsps = ["terraformls" "clojure_lsp" "pyright"];
    extraPlugins = extraVimPlugins;
  };

  programs.tmux = (import ../../program/tmux/default.nix) { inherit pkgs; };

  programs.starship = import ../../program/starship/default.nix;

  programs.vscode = lib.attrsets.overrideExisting vscodeBase {
    extensions = vscodeBaseExts ++ [
      pkgs.vscode-extensions.hashicorp.terraform
      pkgs.vscode-extensions.betterthantomorrow.calva
    ];
  };

  programs.zsh = lib.attrsets.recursiveUpdate (import ../../program/zsh/default.nix) {

    initExtra = ''
      if [ -n "''\${commands[fzf-share]}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi

      # >>> conda initialize >>>
      # !! Contents within this block are managed by 'conda init' !!
      __conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
      if [ $? -eq 0 ]; then
          eval "$__conda_setup"
      else
          if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
              . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
          else
              export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
          fi
      fi
      unset __conda_setup
      # <<< conda initialize <<<

      PATH=$HOME/.bin:$PATH
    '';
    sessionVariables = {
      AWS_DEFAULT_PROFILE = "nonprod";
      TALISMAN_HOME = "/Users/keithschulze/.talisman/bin";
    };
    shellAliases = {
      talisman = "/Users/keithschulze/.talisman/bin/talisman_darwin_amd64";
    };
    oh-my-zsh = {
      plugins = [
        "git"
        "vi-mode"
        "docker-compose"
        "ripgrep"
        "tmux"
      ];
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  # home.file.".config/tmuxinator/hotdoc.yml".source = ./config/tmux/hotdoc.yml;
  home.file.".config/nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  home.file.".config/helix/config.toml".text = builtins.readFile ../../config/helix/config.toml;
}

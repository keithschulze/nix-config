{ config, lib, pkgs, ... }:
{
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

    # tools
    poetry
    black
    cookiecutter
    awscli2
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
        identityFile = "~/.ssh/id_ed25519";
      };
      "thoughtworks.github.com" = {
        hostname = "github.com";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
        identityFile = "~/.ssh/id_ed25519_thoughtworks";
      };
    };
  };

  programs.gpg = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Keith Schulze";
    userEmail = "keith.schulze@thoughtworks.com";
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
      pager.log = false;
    };
  };

  programs.neovim = (import ../../program/neovim/default.nix) { inherit config; inherit pkgs; inherit lib; };

  programs.tmux = (import ../../program/tmux/default.nix) { inherit pkgs; };

  programs.starship = import ../../program/starship/default.nix;

  programs.zsh = lib.attrsets.recursiveUpdate (import ../../program/zsh/default.nix) {

    initExtra = ''
      if [ -n "''\${commands[fzf-share]}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi

      PATH=$HOME/.bin:$PATH
    '';
    sessionVariables = {
      AWS_DEFAULT_PROFILE = "beach";
    };
    shellAliases = {};
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

  home.file.".background-image".source = ./wallpaper.jpg;
}

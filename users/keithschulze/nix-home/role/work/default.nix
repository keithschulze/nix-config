{ config, lib, pkgs, ... }:
let
  vscodeBase = (import ../../program/vscode/default.nix) { inherit config; inherit pkgs; };
  vscodeBaseExts = vscodeBase.extensions;
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

    # languages
    nodejs
    adoptopenjdk-hotspot-bin-16

    # tools
    poetry
    black
    cookiecutter
    awscli2
    # saml2aws
    geckodriver
  ];

  programs.ssh = {
    enable = true;
    matchBlocks = {
      # keychain = {
      #   host = "*";
      #   extraOptions = {
      #     UseKeychain    = "yes";
      #     AddKeysToAgent = "yes";
      #     IgnoreUnknown  = "UseKeychain";
      #   };
      #   identityFile = "~/.ssh/id_ed25519";
      # };
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
    signing = {
      key = "9E570B3D76B11770";
      signByDefault = true;
    };
  };

  programs.neovim = (import ../../program/neovim/default.nix) { inherit config; inherit pkgs; inherit lib; };

  programs.tmux = (import ../../program/tmux/default.nix) { inherit pkgs; };

  programs.starship = import ../../program/starship/default.nix;

  programs.vscode = lib.attrsets.overrideExisting vscodeBase {
    extensions = vscodeBaseExts ++ [
      pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
      pkgs.vscode-extensions.mechatroner.rainbow-csv
      pkgs.vscode-extensions.hashicorp.terraform
      pkgs.vscode-extensions.scalameta.metals
      pkgs.vscode-extensions.scala-lang.scala
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vsliveshare";
        publisher = "ms-vsliveshare";
        version = "1.0.4498";
        sha256 = "01gg9jqkq9z05ckw0mnqfr769359j6h3z8ay6r17jj6m4mhy2m5g";
      }
      {
        name = "vscode-java-pack";
        publisher = "vscjava";
        version = "0.16.0";
        sha256 = "182gqg683v5w83vpcxbxicy4cs8xpafwxq88gr6v2zj9j0qhz40i";
      }
      {
        name = "java";
        publisher = "redhat";
        version = "0.79.2";
        sha256 = "08dcy108gnhq5z0i7fhgclwq67p956l4csl5xrmsa2vsqfn00q4z";
      }
      {
        name = "vscode-java-debug";
        publisher = "vscjava";
        version = "0.34.0";
        sha256 = "0yjm39r5f8b0d1gb4xswk82wf05dryqq0dssa20j4klm9yhygz14";
      }
      {
        name = "vscode-java-test";
        publisher = "vscjava";
        version = "0.30.0";
        sha256 = "0vzkm0r4lz1cbf4z3zxysqgwxs7qfgq498isxmil033dbav9iy0j";
      }
      {
        name = "vscode-maven";
        publisher = "vscjava";
        version = "0.31.0";
        sha256 = "1yyyf1zkwbba8kxpwcg7kibsv3jxnyh95h4i2kzavklrrkl1xpyf";
      }
      {
        name = "vscode-java-dependency";
        publisher = "vscjava";
        version = "0.18.4";
        sha256 = "1wr0r8banrlhkdfhgwrgcd63ig56bycz6fzdw6qcwfmp0qs12shn";
      }
      {
        name = "vscodeintellicode";
        publisher = "VisualStudioExptTeam";
        version = "1.2.14";
        sha256 = "1j72v6grwasqk34m1jy3d6w3fgrw0dnsv7v17wca8baxrvgqsm6g";
      }
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
      AWS_DEFAULT_PROFILE = "beach";
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

  programs.alacritty = {
    enable = true;
    settings = import ../../program/alacritty/default-settings.nix;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  # home.file.".config/tmuxinator/hotdoc.yml".source = ./config/tmux/hotdoc.yml;
  home.file.".config/nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';
}

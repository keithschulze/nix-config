{ pkgs, config, lib, features, username, ... }:

let
  inherit (pkgs) stdenv;
  home = if stdenv.isDarwin then "Users" else "home";
  gantry = (import ../../modules/gantry) { inherit stdenv; inherit pkgs; };
  aws-auth = (import ../../modules/aws-auth) { inherit stdenv; inherit pkgs; };
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

    #editors
    jetbrains.datagrip

    # languages
    nodejs
    (python312.withPackages(ps: [
      ps.pip
    ]))
    # tools
    aws-auth
    coursier
    docker
    docker-buildx
    docker-compose
    gantry
    github-cli
    ssm-session-manager-plugin
    terraform

    # package managers
    uv

    # lang clients
    metals
    nil
    nixd
    pyright
    terraform-ls
  ];

  news.display = "silent";

  programs.aerospace = (import ../../home/program/aerospace/default.nix);

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
    enableDefaultConfig = false;
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
    settings = {
      user = {
        name = "Keith Schulze";
        email = "kschulze@seek.co.nz";
      };
      alias = {
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

  programs.lazygit = (import ../../home/program/lazygit/default.nix) { inherit colors; };

  programs.gitui = (import ../../home/program/gitui/default.nix) { inherit colors; };

  programs.java = {
    enable = true;
    package = pkgs.temurin-bin-17;
  };

  programs.helix = (import ../../home/program/helix/default.nix) {
    inherit config pkgs lib;
    extraPackages = with pkgs; [
      black
      harper
      marksman
      pyright
      ruff
      rumdl
      sqlfluff
    ];
    
    languages = {
      language = [
        {
          name = "markdown";
          auto-format = true;
          language-servers = ["marksman" "harper-ls" "rumdl"];
          soft-wrap = {
            enable = true;
            wrap-at-text-width = true;
          };
          text-width = 100;
        }
        {
          name = "python";
          auto-format = true;
          formatter = {
            command = "black";
            args = ["--quiet" "-"];
          };
          language-servers = ["pyright" "ruff"];
          roots = ["pyproject.toml"];
        }
        {
          name = "sql";
          auto-format = true;
          formatter = {
            command = "sqlfluff";
            args = ["format" "--dialect" "trino" "-"];
          };
        }
      ];

      language-server.harper-ls = {
        command = "harper-ls";
        args = ["--stdio"];
      };

      language-server.pyright = {
        command = "pyright-langserver";
        args = ["--stdio"];
      };

      language-server.rumdl = {
        command = "rumdl";
        args = ["server"];
      };
    };
  };

  programs.vscode = (import ../../home/program/vscode/default.nix) {
    inherit config pkgs;
    extraExtensions = with pkgs; [
      vscode-extensions.ms-vscode-remote.remote-containers
      vscode-extensions.hashicorp.terraform
      vscode-extensions.ms-pyright.pyright
      vscode-extensions.ms-python.black-formatter
      vscode-extensions.ms-python.flake8
      vscode-extensions.ms-python.mypy-type-checker
      vscode-extensions.ms-python.python
      vscode-extensions.ms-python.pylint
      vscode-extensions.samuelcolvin.jinjahtml
    ];

    extraUserSettings = builtins.fromJSON (builtins.readFile ./config/vscode/settings.json);
  };

  programs.zed-editor = (import ../../home/program/zed/default.nix) {
    inherit config pkgs;
    extraExtensions = [
      "env"
    ];
  };

  programs.zsh = lib.attrsets.recursiveUpdate (import ../../home/program/zsh/default.nix) {
    initContent = ''
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
      hisp = "cd ~/Development/github/hirer-insights-shared-packages";
      hard = "cd ~/Development/github/hirer-ad-rating-data";
      haud = "cd ~/Development/github/hirer-ad-usage-data";
      hapd = "cd ~/Development/github/hirer-ad-performance-data";
      hird = "cd ~/Development/github/hirer-insights-role-data";
      htsud = "cd ~/Development/github/hirer-talent-search-usage-data";
      hidi = "cd ~/Development/github/hirer-insights-data-interchange";
      hidbt = "cd ~/Development/github/dataplatform-dbt-hirer-insights";
      hirer-ci = "cd ~/Development/github/hirer-ci";

      data-platform = "cd ~/Development/github/data-platform";
      uda = "cd ~/Development/github/unified-data-access";

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

  home.file.".config/ghostty/config".text = builtins.readFile ../../home/config/ghostty/config;
}

{
  description = "NixOS systems and tools";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";

      # We want home-manager to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
    };

    utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { nixpkgs, home-manager, utils, ... }@inputs:
    let
      lib = nixpkgs.lib // home-manager.lib // (import ./lib { inherit inputs; });
      inherit (lib) mkDarwin mkHome forAllSystems;
    in
    rec {
      inherit lib;

      overlays = {
      };

      legacyPackages = forAllSystems (system:
        import inputs.nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        }
      );

      darwinConfigurations = {
        matawhero = mkDarwin {
          hostname = "matawhero";
          system = "aarch64-darwin";
          username = "keithschulze";
          pkgs = legacyPackages."aarch64-darwin";
        };

        rapu = mkDarwin {
          hostname = "rapu";
          system = "aarch64-darwin";
          username = "kschulze";
          pkgs = legacyPackages."aarch64-darwin";
        };
      };

      homeConfigurations = {
        "keithschulze@matawhero" = mkHome {
          username = "keithschulze";
          hostname = "matawhero";
          features = [
            "alacritty"
            "starship"
          ];
          colorscheme = "catppuccin-mocha";
          pkgs = legacyPackages."aarch64-darwin";
        };

        "kschulze@rapu" = mkHome {
          username = "kschulze";
          hostname = "rapu";
          features = [
            "alacritty"
            "starship"
          ];
          colorscheme = "catppuccin-macchiato";
          pkgs = legacyPackages."aarch64-darwin";
        };
      };
    } // utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };
        hm = home-manager.packages."${system}".default;
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ nixVersions.latest hm ];
        };
      });
}

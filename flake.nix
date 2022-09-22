{
  description = "NixOS systems and tools";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";

      # We want home-manager to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:narutoxy/nix-colors/5ae8ab6b2ccad1b9f3ca3135ab805ac440174940";

    utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    let
      lib = import ./lib { inherit inputs; };
      inherit (lib) mkSystem mkHome forAllSystems;
      # Overlays is the list of overlays we want to apply from flake inputs.
    in
    rec {
      inherit lib;

      overlays = {};

      legacyPackages = forAllSystems (system:
        import inputs.nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        }
      );

      nixosConfigurations = {
        wheru = mkSystem {
          hostname = "wheru";
          pkgs = legacyPackages."aarch64-linux";
        };
        kopu = mkSystem {
          hostname = "kopu";
          system = legacyPackages."x86_64-linux";
        };
      };

      homeConfigurations = {
        "keithschulze@wheru" = mkHome {
          username = "keithschulze";
          hostname = "wheru";
          role = "personal-vm";
          features = [ "desktop-i3" "alacritty" ];
          colorscheme = "tokyonight";
        };
        "keithschulze@kopu" = mkHome {
          username = "keithschulze";
          hostname = "kopu";
          role = "work-vm";
          features = [ "desktop-i3" "alacritty" ];
          colorscheme = "tokyonight";
        };
      };
    } // inputs.utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ nixUnstable hm ];
        };
      });
}

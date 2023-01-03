{ inputs, ... }:

let
  inherit (inputs) self home-manager nixpkgs darwin;
  inherit (self) outputs;
  inherit (nixpkgs.lib) genAttrs;
in
  rec {
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "i686-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    forAllSystems = genAttrs systems;

    mkSystem =
      { hostname
      , pkgs }:
      nixpkgs.lib.nixosSystem {
        inherit pkgs;
        specialArgs = {
          inherit inputs outputs hostname;
        };
        modules = [
          ../hosts/${hostname}
        ];
      };

    mkDarwin =
      { hostname
      , system
      , pkgs
      }:
      darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ../hosts/${hostname}
        ];
        specialArgs = { inherit inputs outputs pkgs system; };
      };

    mkHome =
      { username
      , hostname
      , pkgs ? outputs.nixosConfigurations.${hostname}.pkgs
      , features ? [ ]
      , colorscheme ? "tokyonight"
      }:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs outputs username hostname features colorscheme;
        };
        modules = [
          ../modules/home-manager
          ../users/${username}
        ];
      };
  }

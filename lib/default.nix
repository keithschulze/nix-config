{ inputs, ... }:

let
  inherit (inputs) self home-manager nixpkgs;
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

    mkHome =
      { username
      , hostname
      , role
      , pkgs ? outputs.nixosConfigurations.${hostname}.pkgs
      , features ? [ ]
      , colorscheme ? "tokyonight"
      }:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs outputs username hostname role features colorscheme;
        };
        modules = [
          ../modules/home-manager
          ../users/${username}
        ];
      };

    # mkDarwin =
    #   { hostname
    #   , system
    #   , users
    #   , role
    #   , features ? [ ]
    #   }:
    #   darwin.lib.darwinSystem {
    #     inherit system;
    #     modules = [
    #       ./hosts/darwin
    #     ];
    #   };
  }

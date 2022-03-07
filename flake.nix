{
  description = "NixOS systems and tools";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";

      # We want home-manager to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:narutoxy/nix-colors/5ae8ab6b2ccad1b9f3ca3135ab805ac440174940";

    utils.url = "github:numtide/flake-utils";
    # Other packages
    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { nixpkgs, home-manager, utils, ... }@inputs:
    let
      overlay = (import ./overlays);
      # Overlays is the list of overlays we want to apply from flake inputs.
      overlays = [
        #inputs.neovim-nightly-overlay.overlay
        (self: super: {
          alacritty = super.alacritty.overrideAttrs (
            o: rec {
              doCheck = false;
            }
          );
        })
      ];

      mkSystem = { hostname, system, users }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs system;
          };
          modules = [
            # ./modules/nixos
            (./hosts + "/${hostname}")
            {
              networking.hostName = hostname;
              # Apply overlay and allow unfree packages
              nixpkgs = {
                inherit overlays;
                config.allowUnfree = true;
              };
              # Add each input as a registry
              nix.registry = nixpkgs.lib.mapAttrs'
                (n: v:
                  nixpkgs.lib.nameValuePair (n) ({ flake = v; }))
                inputs;
            }
            # System wide config for each user
          ] ++ nixpkgs.lib.forEach users
            (u: ./users + "/${u}" + /system-wide.nix);
        };

      # Make home configuration, given username, required features, and system type
      mkHome = { username, system, hostname, role, features ? [ ] }:
        home-manager.lib.homeManagerConfiguration {
          inherit username system;
          extraSpecialArgs = {
            inherit features hostname role inputs system;
          };
          homeDirectory = "/home/${username}";
          configuration = ./users + "/${username}";
          extraModules = [
            ./modules/home-manager
            {
              nixpkgs = {
                inherit overlays;
                config.allowUnfree = true;
              };
            }
          ];
        };
    in {
      inherit overlay overlays;

      nixosConfigurations = {
        parallels-vm = mkSystem {
          hostname = "parallels-vm";
          system = "aarch64-linux";
          users = [ "keithschulze" ];
        };
      };

      homeConfigurations = {
        "keithschulze@parallels-vm" = mkHome {
          username = "keithschulze";
          hostname = "parallels-vm";
          role = "personal-vm";
          features = [ "desktop-i3" "alacritty" ];
          system = "aarch64-linux";
        };
      };
    } // utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system overlays; };

        hm = home-manager.defaultPackage."${system}";
        gtkThemeFromScheme = (inputs.nix-colors.lib { inherit pkgs; }).gtkThemeFromScheme;
        generated-gtk-themes =  builtins.mapAttrs (name: value: gtkThemeFromScheme { scheme = value; }) inputs.nix-colors.colorSchemes;
      in
      {
        packages = pkgs // {
          inherit generated-gtk-themes;
          home-manager = hm;
        };

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ nixUnstable nixfmt rnix-lsp hm ];
        };
      });
}

# My personal Nix system config

This is my personal Nix system configuration. Mostly I use this to manage my
environments for my Mac systems using nix-darwin.

Generally speaking, the configuration of the host and home environment are
separated such that we can define, build and apply these configs separately.I
find that I need to more frequently update home configs that host configs, so I
think it's useful to separate them.

These configs use [Nix flakes](https://nixos.wiki/wiki/Flakes).

The structure of this repo was inspired by
the excellent [Misterio77/nix-config](https://github.com/Misterio77/nix-config) repo, though the two repos have subsequently diverged.

## TLDR Getting started

1. Install Nix:

  ```sh
  sh <(curl -L https://nixos.org/nix/install)
  ```
  Note: this has only really been tested for multi-user installation.

2. Enable flakes:

  ```sh
  echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
  ```

3. Bootstrap/install [nix-darwin](https://github.com/LnL7/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager):

  nix-darwin:

  ```sh
  nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  ./result/bin/darwin-installer
  ```

  home-manager (standalone):

  ```sh
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
  ```

4. Clone this repo:

  ```sh
  git clone git@github.com:keithschulze/nixos-config.git
  ```

5. Build and apply host config

  ```sh
  darwin-rebuild switch --flake .#matawhero
  ```
  __note:__ in this case we are applying the `matawhero` host configuration as
  an example. Other hosts are/can be defined in `flake.nix`.

6. Build and apply the home configuration

  ```sh
  home-manager switch --flake .#keithschulze@matawhero
  ```
  __note:__ in this case we are applying the `keithschulze@matawhero` home configuration as an
  example. Other home configrations are/can be defined in `flake.nix`.


## Updating

In order to update packages, we need to update the locked versions:

```sh
nix flake update
```

Before applying or committing this, we should check that it builds correctly
with update versions:

```sh
darwin-rebuild build --flake .#matawhero
home-manager build --flake .#keithschulze@matawhero
```
Note: this example only builds host and home configs for a single host and
user. We should do this for all that matter.


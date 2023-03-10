# My personal Nix system config

This is my personal Nix system configuration. Mostly I use this to manage my
environments for my Mac systems using nix-darwin; however, I have also experimented with
creating
developer NixOS VMs that run on Parallels (see below).

Generally speaking, the configuration of the host and home environment are
separated.

The structure of this repo was inspired by
the excellent [Misterio77/nix-config](https://github.com/Misterio77/nix-config) repo, though the two repos have subsequently diverged.

## TLDR Getting started

1. Install Nix:

  ```sh
  sh <(curl -L https://nixos.org/nix/install)
  ```
  Note: this has only really been tested for multi-user installation.

2. Bootstrap/install nix-darwin and home-manager:

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

2. Clone this repo:

  ```sh
  git clone git@github.com:keithschulze/nixos-config.git
  ```

3. Build and apply host config

  ```sh
  darwin-rebuild switch --flake .#matawhero
  ```
  __note:__ in this case we are applying the `matawhero` host configuration as
  an example. Other hosts are/can be defined in `flake.nix`.

4. Build and apply the home configuration

  ```sh
  home-manager switch --flake .#keithschulze@matawhero
  ```
  __note:__ in this case we are applying the `keithschulze@matawhero` home configuration as an
  example. Other home configrations are/can be defined in `flake.nix`.

# Parallels developer VM setup [no actively used]

This is my NixOS Parallels developer VM setup. This is adapted from Mitchell Hashimoto's excellent NixOS VM repo.

## Setup

If you need an ISO for NixOS, you can build your own in the `iso` folder.
For x86-64, I usually just download the official ISO, but I build the
ISO from scratch for aarch64. There is a make target `iso/nixos.iso` you can use for
building an ISO. You'll also need a `docker` running on your machine for building an ISO.

```
$ make iso/nixos.iso
```

Create a Parallels VM with the following settings:

  * ISO: NixOS 21.05 or later.
  * Disk: SATA 150 GB+
  * CPU/Memory: I give at least half my cores and half my RAM, as much as you can.
  * Graphics: Full acceleration, full resolution, maximum graphics RAM.
  * Network: Shared with my Mac.
  * Remove sound card, remove video camera.
  * Profile: Disable almost all keybindings

Boot the VM, and using the graphical console, change the root password to "root":

```
$ sudo su
$ passwd
# change to root
```

Run `ifconfig` and get the IP address of the first device. It is probably
`192.168.58.XXX`, but it can be anything. In a terminal with this repository
set this to the `NIXADDR` env var:

```
$ export NIXADDR=<VM ip address>
```

Perform the initial bootstrap. This will install NixOS on the VM disk image
but will not setup any other configurations yet. This prepares the VM for
any NixOS customization:

```
$ make vm/bootstrap0
```

After the VM reboots, this is usually a good time to take a VM Snapshot because
you might want to return to this point while you stuff around with configs. Run
the full bootstrap, this will finalize the NixOS customization using this
configuration:

```
$ make vm/bootstrap
```

At this point, the core will be setup; however, you still need to run
`home-manager` to setup the full Desktop environment. Boot the VM and jump into `/nix-config`. Run `nix develop` and then `home-manager switch --flake .`

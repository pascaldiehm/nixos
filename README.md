# My NixOS configuration

NixOS is a fully declarative Linux distribution - and this repository contains the files required to make _my version_ of NixOS.

![Screenshot](resources/screenshot.png)

> [!IMPORTANT]
> This is _my_ configuration, containing _my_ secrets and requiring _my_ password to install.
> You are more than welcome to take inspiration from this project, but installing as is probably won't work for you.

## Inputs

- [Home Manager](https://github.com/nix-community/home-manager) - they say not to let them in your home
- [Impermanence](https://github.com/nix-community/impermanence) - `rm -rf --no-preserve-root /`
- [Lanzaboote](https://github.com/nix-community/lanzaboote) - an island of security in a sea of unknown hardware
- [Nixpkgs (unstable)](https://github.com/NixOS/nixpkgs/tree/nixos-unstable) - all your packages are belong to us
- [Nixvim](https://github.com/nix-community/nixvim) - who needs lua when you have nix
- [SOPS Nix](https://github.com/Mic92/sops-nix) - they built a wall around infinity, separated all the infinite values from all the infinite values nobody should know
- [Stylix](https://github.com/danth/stylix) - one tool to style them all, one file to declare them, one command to apply them all and in dark themes reside

## Components

| Component         | Desktop        | Server              |
| ----------------- | -------------- | ------------------- |
| Boot loader       | Lanzaboote     | systemd-boot / GRUB |
| Filesystem        | btrfs + LUKS   | btrfs               |
| Networking        | NetworkManager | systemd-networkd    |
| Display manager   | SDDM           |                     |
| Window manager    | Hyprland       |                     |
| Audio server      | pipewire       |                     |
| Terminal emulator | kitty          |                     |
| Shell             | ZSH            | ZSH                 |
| Editor            | neovim         | vim                 |

## Structure

- [flake.nix](flake.nix): Entry point
- [lib.nix](lib.nix): Additional library functions
- [machines.json](machines.json): List of defined machines and their type
- [apps](apps/): Scripts that are exported as apps by [flake.nix](flake.nix)
- [base](base/): Common configuration shared between machines
- [extra](extra/): Additional modules
- [machines](machines/): Machine-specific configuration
- [modules](modules/): Custom option definitions
- [overlay](overlay/): Nixpkgs overlay
- [resources](resources/): Additional resources and non-nix configuration files
  - [extensions](resources/extensions/): List of extensions not provided by nixpkgs
  - [scripts](resources/scripts/): Outsourced shell scripts
  - [secrets](resources/secrets/): Sops stores containing secret values

## Why?

Here are _my_ reasons, why I think NixOS is awesome:

1. **NixOS is like dotfiles, only on steroids.** As soon as you use more than one device, like a desktop computer at home and a laptop on the go, a non-negligible amount of your sadly very finite time is going to be used to synchronize data and configurations between your devices. Most people use a dotfiles repository to combat this, and NixOS is just an incredibly powerful dotfiles manager.
2. **NixOS is declarative.** I know, this is like the main selling point of NixOS, but having all your system configuration in a single place makes it easy to read through and know what you've changed.
3. **The NixOS ecosystem.** This mainly refers to the [impermanence](https://github.com/nix-community/impermanence) module that allows you to keep your system clean between reboots. This is not directly a feature of NixOS, but is made possible by its unique way of handling packages and system configurations.
4. **A NixOS system is up and running in no time.** Using NixOS you don't have to care about broken installs. Just reinstall the system and your entire configuration is already there. If you store all your data in some kind of cloud solution (e.g. GitHub), you literally have nothing to loose. I've already managed to break the LUKS header on my laptop one day - the system was fully back up and running in 15 minutes.
5. **The NixOS repository.** According to [repology](https://repology.org/repositories/graphs), the nixpkgs repository is by far the largest and most up-to-date Linux package repository. And their way of handling packages makes it incredibly easy to add custom packages or patches for existing ones.
6. **NixOS is great for tinkering.** This might be a weird point to make, but NixOS is really fun to play around with.

That being said, NixOS is definitely not the solution for everyone.
It has a steep learning curve and requires the use of a full-blown programming language to configure.
Before trying NixOS, I would definitely recommend you have a solid understanding of the Linux ecosystem and (declarative) programming languages.

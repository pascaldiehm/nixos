# My NixOS configuration

NixOS is a fully declarative Linux distribution - and this repository contains the files required to make _my version_ of NixOS.

![Screenshot](resources/screenshot.png)

> [!IMPORTANT]
> This is _my_ configuration, containing _my_ secrets and requiring _my_ password to install.
> You are more than welcome to take inspiration from this project, but installing as is probably won't work for you.

## Inputs

- [Nixpkgs (unstable)](https://github.com/NixOS/nixpkgs/tree/nixos-unstable) - all your packages are belong to us
- [Home Manager](https://github.com/nix-community/home-manager) - they say not to let them in your home
- [Plasma Manager](https://github.com/nix-community/plasma-manager) - one tool to manage them all
- [SOPS Nix](https://github.com/Mic92/sops-nix) - they built a wall around infinity, separated all the infinite values from all the infinite values nobody should know
- [Impermanence](https://github.com/nix-community/impermanence) - `rm -rf --no-preserve-root /`

## Components

| Component           | Desktop              | Server           |
| ------------------- | -------------------- | ---------------- |
| Boot manager        | systemd-boot         | systemd-boot     |
| Filesystem          | btrfs + LUKS         | btrfs            |
| Networking          | NetworkManager       | systemd-networkd |
| Display manager     | SDDM                 |                  |
| Desktop environment | KDE Plasma (Wayland) |                  |
| Audio server        | pipewire             |                  |
| Terminal emulator   | Konsole              |                  |
| Shell               | ZSH                  | ZSH              |
| Text editor         | VSCodium, vim        | vim              |

## Tools

This project contains a few tools to make my life a little easier.

For starters, the flake exports 3 apps:

- [`install`](apps/install.sh) should be run from a NixOS installer. It guides the user through installing one of the machines.
- [`update`](apps/update.sh) should be run from an installed system. It ensures that the config repository is up-to-date and then calls `nixos-rebuild switch` with the necessary flags to rebuild the system.
- [`upgrade`](apps/upgrade.sh) can be run from any system. It updates the system flake and [extensions](resources/extensions/).

Also, the [zshrc](resources/zshrc.zsh) defines 4 helper functions:

- `nixos-iso` builds a customized [NixOS installer image](extra/installer.nix).
- `nixos-secrets` opens the sops editor for the specified [subdirectory](resources/secrets/).
- `nixos-test` runs `nixos-rebuild test` with the necessary flags to test a modified system configuration.
- `nixos-update` runs the `update` app provided by the system flake.

Last but not least, the repository contains a nightly [workflow](.github/workflows/upgrade.yaml) that runs the `upgrade` app, makes sure all machines compile and commits the changes to the repository.

## Structure

- [flake.nix](flake.nix): Entry point
- [lib.nix](lib.nix): Helper functions used through the configuration
- [machines.json](machines.json): Lists defined machines and their type
- [apps](apps/): Scripts that are exported as apps by [flake.nix](flake.nix)
- [base](base/): Common configuration shared between machines
- [extra](extra/): Additional modules
- [machines](machines/): Machine-specific configuration
- [patches](patches/): Custom patch files
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
5. **The NixOS repository.** According to [repology](https://repology.org/repositories/graphs), the nixpkgs repository is by far the largest and most up-to-date Linux package repository.
6. **NixOS is great for tinkering.** This might be a weird point to make, but NixOS is really fun to play around with.

That being said, NixOS is definitely not the solution for everyone.
It has a steep learning curve and requires the use of a full-blown programming language to configure.
Before trying NixOS, I would definitely recommend you have a solid understanding of the Linux ecosystem and (declarative) programming languages.

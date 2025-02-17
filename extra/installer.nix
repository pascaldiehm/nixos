{ lib, modulesPath, pkgs, ... }: {
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];
  console.keyMap = "de";
  nix.settings.experimental-features = [ "flakes" "nix-command" "pipe-operators" ];
  nixpkgs.hostPlatform = "x86_64-linux";
  services.getty.helpLine = lib.mkAfter "Run 'nixinstall' to install NixOS.";

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "nixinstall";
      text = builtins.readFile ../resources/scripts/install.sh;

      runtimeInputs = [
        pkgs.btrfs-progs
        pkgs.cryptsetup
        pkgs.git
        pkgs.gnupg
        pkgs.jq
        pkgs.parted
        pkgs.pinentry-tty
        pkgs.sbctl
        (pkgs.writeShellScriptBin "machines" "cat ${../machines.json}")
      ];
    })
  ];

  users.users.nixos.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMVpBDeuHacnZcYsM06F+ktipogjcLNZrL6rjYwZIV51 pascal"
  ];
}

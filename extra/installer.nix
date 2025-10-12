{ lib, modulesPath, pkgs, ... }: {
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ../base/desktop/nixcache.nix ];
  console.keyMap = "de";
  environment.systemPackages = [ (pkgs.writeShellScriptBin "nixinstall" "nix run github:pascaldiehm/nixos#install") ];
  nix.settings.experimental-features = [ "flakes" "nix-command" "pipe-operators" ];
  nixpkgs.hostPlatform = "x86_64-linux";
  services.getty.helpLine = lib.mkAfter "Run 'nixinstall' to install NixOS.";

  users.users.nixos.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMVpBDeuHacnZcYsM06F+ktipogjcLNZrL6rjYwZIV51 pascal"
  ];
}

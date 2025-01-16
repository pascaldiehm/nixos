{ lib, modulesPath, pkgs, ... }: {
  console.keyMap = "de";
  environment.systemPackages = [ (pkgs.writeShellScriptBin "install-nixos" "nix run github:pascaldiehm/nixos#install") ];
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];
  nix.settings.experimental-features = [ "flakes" "nix-command" "pipe-operators" ];
  nixpkgs.hostPlatform = "x86_64-linux";
  services.getty.helpLine = lib.mkAfter "Run 'install-nixos' to install nixos.";

  users.users.nixos.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMVpBDeuHacnZcYsM06F+ktipogjcLNZrL6rjYwZIV51 pascal"
  ];
}

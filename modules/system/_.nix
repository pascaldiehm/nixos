{ ... }: {
  imports = [
    ./audio.nix
    ./boot.nix
    ./firmware.nix
    ./home-manager.nix
    ./home.nix
    ./localisation.nix
    ./network.nix
    ./nix.nix
    ./plasma.nix
    ./sddm.nix
    ./sops.nix
    ./user.nix
    ./yubikey.nix
  ];
}

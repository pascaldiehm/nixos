{ inputs, ... }: {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
    ../../extra/university
    ./boot.nix
    ./development.nix
    ./email.nix
    ./firefox.nix
    ./locale.nix
    ./networking.nix
    ./persistence.nix
    ./programs.nix
    ./ssh.nix
    ./thunderbird.nix
    ./xdg.nix
    ./yubikey.nix
  ];
}

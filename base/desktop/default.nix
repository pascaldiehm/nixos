{ inputs, ... }: {
  imports = [
    ./boot.nix
    ./development.nix
    ./email.nix
    ./firefox.nix
    ./locale.nix
    ./misc.nix
    ./networking.nix
    ./persistence.nix
    ./plasma.nix
    ./programs.nix
    ./sddm.nix
    ./ssh.nix
    ./thunderbird.nix
    ./vscode.nix
    ./xdg.nix
    ./yubikey.nix
    ../../extra/university
    inputs.lanzaboote.nixosModules.lanzaboote
  ];
}

{ ... }: {
  imports = [
    ./desktop.nix
    ./nix.nix
    ./secrets.nix
    ./system.nix
    ./user.nix
  ];
}

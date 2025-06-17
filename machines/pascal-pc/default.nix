{
  imports = [
    ../_shared/amdgpu.nix
    ../_shared/bluetooth.nix
    ./audio.nix
    ./misc.nix
    ./networking.nix
    ./printer.nix
    ./programs.nix
  ];
}

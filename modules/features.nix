{ config, lib, pkgs, ... }: {
  options.features = {
    amdgpu.enable = lib.mkEnableOption "AMD GPU";
    bluetooth.enable = lib.mkEnableOption "Bluetooth";
  };

  config = lib.mkMerge [
    (lib.mkIf config.features.amdgpu.enable {
      hardware.graphics.extraPackages = [ pkgs.rocmPackages.clr.icd ];
      nixpkgs.config.rocmSupport = true;
    })

    (lib.mkIf config.features.bluetooth.enable {
      environment.persistence."/perm".directories = [ "/var/lib/bluetooth" ];
      hardware.bluetooth.enable = true;
    })
  ];
}

{ pkgs, ... }: {
  hardware.graphics.extraPackages = [ pkgs.rocmPackages.clr.icd ];
}

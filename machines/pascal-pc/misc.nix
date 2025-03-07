{ pkgs, ... }: {
  environment.persistence."/perm".users.pascal.directories = [ ".local/share/PrismLauncher" ];
  hardware.graphics.extraPackages = [ pkgs.rocmPackages.clr.icd ];
}

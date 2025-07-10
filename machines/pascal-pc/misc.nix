{ pkgs, ... }: {
  environment.persistence."/perm".users.pascal.directories = [ ".config/retroarch" ".local/share/PrismLauncher" ];

  hardware = {
    bluetooth.enable = true;
    graphics.extraPackages = [ pkgs.rocmPackages.clr.icd ];
  };
}

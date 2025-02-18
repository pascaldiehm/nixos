{ pkgs, ... }: {
  environment.persistence."/perm".users.pascal.directories = [ ".local/share/PrismLauncher" ];
  hardware.graphics.extraPackages = [ pkgs.rocmPackages.clr.icd ];
  home-manager.users.pascal.systemd.user.services.music.Install.WantedBy = [ "graphical-session.target" ];
}

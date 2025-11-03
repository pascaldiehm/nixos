{ pkgs, ... }: {
  home-manager.users.pascal.home.packages = [ pkgs.prismlauncher pkgs.retroarch-free pkgs.superTuxKart ];

  environment.persistence."/perm".users.pascal.directories = [
    ".config/retroarch"
    ".config/supertuxkart"
    ".local/share/PrismLauncher"
    ".local/share/supertuxkart"
  ];

  services.duplicity.include = [
    "/home/pascal/.config/retroarch/saves"
    "/home/pascal/.config/supertuxkart"
    "/home/pascal/.local/share/PrismLauncher/instances"
  ];
}

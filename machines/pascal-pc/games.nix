{ pkgs, ... }: {
  home-manager.users.pascal.home.packages = [ pkgs.prismlauncher pkgs.retroarch-free pkgs.superTuxKart ];

  environment.persistence."/perm".users.pascal.directories = [
    ".config/retroarch"
    ".config/supertuxkart"
    ".local/share/PrismLauncher"
    ".local/share/supertuxkart"
  ];

  services.backup = {
    "/home/pascal/.config/retroarch".include = [ "saves" ];
    "/home/pascal/.config/supertuxkart".excludeGlob = [ "**.log" ];
    "/home/pascal/.local/share/PrismLauncher".include = [ "instances/*/minecraft/saves" ];
  };
}

{ pkgs, ... }: {
  # FIXME: Add supertuxkart and retroarch-free once CMake errors are fixed
  home-manager.users.pascal.home.packages = [ pkgs.prismlauncher ];

  environment.persistence."/perm".users.pascal.directories = [
    ".config/retroarch"
    ".config/supertuxkart"
    ".local/share/PrismLauncher"
    ".local/share/supertuxkart"
  ];
}

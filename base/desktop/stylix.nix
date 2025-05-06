{ inputs, pkgs, ... }: {
  imports = [ inputs.stylix.nixosModules.stylix ];
  home-manager.users.pascal.stylix.targets.firefox.profileNames = [ "default" ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/colors.yaml";
    image = ../../resources/wallpaper.jpg;

    cursor = {
      name = "Quintom_Ink";
      package = pkgs.quintom-cursor-theme;
      size = 32;
    };

    fonts = {
      monospace = {
        name = "Fira Code";
        package = pkgs.fira-code;
      };

      sansSerif = {
        name = "Ubuntu";
        package = pkgs.nerd-fonts.ubuntu;
      };

      serif = {
        name = "Ubuntu";
        package = pkgs.nerd-fonts.ubuntu;
      };
    };
  };
}

{ inputs, pkgs, ... }: {
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/colors.yaml";
    image = ../../resources/wallpaper.jpg;

    cursor = {
      name = "Quintom_Ink";
      package = pkgs.quintom-cursor-theme;
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

{ inputs, pkgs, ... }: {
  imports = [ inputs.stylix.nixosModules.stylix ];
  home-manager.users.pascal.stylix.targets.firefox.profileNames = [ "default" ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/default-dark.yaml";
    image = ../../resources/wallpaper.jpg;

    cursor = {
      name = "Quintom_Ink";
      package = pkgs.quintom-cursor-theme;
      size = 32;
    };

    fonts = {
      monospace = {
        name = "FiraCode Nerd Font Mono";
        package = pkgs.nerd-fonts.fira-code;
      };

      sansSerif = {
        name = "NotoSans Nerd Font";
        package = pkgs.nerd-fonts.noto;
      };

      serif = {
        name = "NotoSerif Nerd Font";
        package = pkgs.nerd-fonts.noto;
      };
    };
  };
}

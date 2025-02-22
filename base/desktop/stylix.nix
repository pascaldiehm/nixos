{ inputs, lib, pkgs, ... }: {
  imports = [ inputs.stylix.nixosModules.stylix ];
  home-manager.users.pascal.nixpkgs.overlays = lib.mkForce null; # FIXME: Remove after github:danth/stylix#866 is merged

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

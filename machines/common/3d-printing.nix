{ pkgs, ... }: {
  home-manager.users.pascal = {
    home.packages = [ pkgs.freecad-wayland pkgs.prusa-slicer ];

    xdg.configFile = {
      "PrusaSlicer/filament/PLA.ini".source = ../../resources/prusa/PLA.ini;
      "PrusaSlicer/print/Normal.ini".source = ../../resources/prusa/Normal.ini;
      "PrusaSlicer/printer/AnycubicKobra2.ini".source = ../../resources/prusa/AnycubicKobra2.ini;
    };
  };
}

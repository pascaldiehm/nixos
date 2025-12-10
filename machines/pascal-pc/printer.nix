{ lib, pkgs, ... }: {
  users.users.pascal.extraGroups = [ "lp" "scanner" ];

  hardware = {
    sane.enable = true;

    printers = {
      ensureDefaultPrinter = "Brother_DCP-J1050DW";

      ensurePrinters = lib.singleton {
        deviceUri = "ipp://localhost:60000/ipp/print";
        model = "Brother_DCP-J1050DW";
        name = "Brother_DCP-J1050DW";

        ppdOptions = {
          Duplex = "DuplexNoTumble";
          PageSize = "A4";
        };
      };
    };
  };

  home-manager.users.pascal = {
    home.packages = [ pkgs.prusa-slicer pkgs.simple-scan pkgs.system-config-printer ];

    xdg.configFile = {
      "PrusaSlicer/filament/PLA.ini".source = ../../resources/prusa/PLA.ini;
      "PrusaSlicer/print/Normal.ini".source = ../../resources/prusa/Normal.ini;
      "PrusaSlicer/printer/AnycubicKobra2.ini".source = ../../resources/prusa/AnycubicKobra2.ini;
    };
  };

  services = {
    avahi.enable = lib.mkForce false;
    ipp-usb.enable = true;

    printing = {
      enable = true;

      drivers = lib.readFile ../../resources/Brother_DCP-J1050DW.ppd
        |> pkgs.writeTextDir "share/cups/model/Brother_DCP-J1050DW"
        |> lib.singleton;
    };
  };
}

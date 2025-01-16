{ pkgs, ... }: {
  hardware.sane.enable = true;
  users.users.pascal.extraGroups = [ "lp" "scanner" ];

  home-manager.users.pascal = {
    home.packages = [ pkgs.kdePackages.skanlite pkgs.prusa-slicer pkgs.system-config-printer ];

    xdg.configFile = {
      "PrusaSlicer/filament/PLA.ini".source = ../../resources/prusa/PLA.ini;
      "PrusaSlicer/print/Normal.ini".source = ../../resources/prusa/Normal.ini;
      "PrusaSlicer/printer/AnycubicKobra2.ini".source = ../../resources/prusa/AnycubicKobra2.ini;
    };
  };

  services = {
    ipp-usb.enable = true;
    printing.enable = true;
  };

  systemd.services.ensure-printer = {
    after = [ "cups.service" ];
    description = "Add printer without failing if it is not connected";
    wantedBy = [ "multi-user.target" ];
    wants = [ "cups.service" ];

    script = ''
      while ! ${pkgs.curl}/bin/curl "localhost:60000/ipp/print" 2> /dev/null; do sleep 10; done

      ${pkgs.cups}/bin/lpadmin -D "Brother DCP-J1050DW" -m everywhere -o ColorMode=Gray -o Duplex=DuplexNoTumble -o PageSize=A4 -p Brother_DCP-J1050DW -v ipp://localhost:60000/ipp/print -E || true
      ${pkgs.cups}/bin/lpadmin -d Brother_DCP-J1050DW
      systemctl stop cups.service
    '';
  };
}

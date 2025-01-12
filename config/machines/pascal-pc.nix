{ pkgs, ... }: {
  users.users.pascal.extraGroups = [ "lp" "scanner" ];

  hardware = {
    graphics.extraPackages = [ pkgs.rocmPackages.clr.icd ];
    sane.enable = true;
  };

  home-manager.users.pascal = {
    home.packages = [
      pkgs.freecad-wayland
      pkgs.kdePackages.skanlite
      pkgs.krita
      pkgs.prusa-slicer
      pkgs.system-config-printer
    ];

    xdg.configFile = {
      "PrusaSlicer/filament/PLA.ini".source = ../../resources/prusa/PLA.ini;
      "PrusaSlicer/print/Normal.ini".source = ../../resources/prusa/Normal.ini;
      "PrusaSlicer/printer/AnycubicKobra2.ini".source = ../../resources/prusa/AnycubicKobra2.ini;
    };
  };

  networking.networkmanager.ensureProfiles.profiles.wired = {
    connection = {
      autoconnect-priority = 90;
      id = "Wired connection";
      type = "ethernet";
    };

    ipv4 = {
      address1 = "192.168.1.90/16,192.168.1.1";
      method = "manual";
    };
  };

  services = {
    ipp-usb.enable = true;
    printing.enable = true;
  };

  systemd.services = {
    disable-auto-mute = {
      after = [ "sound.target" ];
      description = "Disable auto-mute";
      script = "${pkgs.alsa-utils}/bin/amixer -c 2 sset 'Auto-Mute Mode' Disabled";
      wantedBy = [ "multi-user.target" ];
      wants = [ "sound.target" ];
    };

    ensure-printer = {
      after = [ "cups.service" ];
      description = "Add printer without failing if it is not connected";
      wantedBy = [ "multi-user.target" ];
      wants = [ "cups.service" ];

      script = ''
        ${pkgs.cups}/bin/lpadmin -D "Brother DCP-J1050DW" -m everywhere -o "ColorMode=Gray" -o "Duplex=DuplexNoTumble" -o "PageSize=A4" -p Brother_DCP-J1050DW -v "ipp://localhost:60000/ipp/print" -E || true
        ${pkgs.cups}/bin/lpadmin -d Brother_DCP-J1050DW
        systemctl stop cups.service
      '';
    };
  };
}

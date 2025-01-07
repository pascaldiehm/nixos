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

  systemd.services.disableAutoMute = {
    after = [ "sound.target" ];
    description = "Disable auto-mute";
    script = "${pkgs.alsa-utils}/bin/amixer -c 2 sset 'Auto-Mute Mode' Disabled";
    wantedBy = [ "multi-user.target" ];
  };
}

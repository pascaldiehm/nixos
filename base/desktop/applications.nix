{ pkgs, ... }: {
  programs.wireshark.enable = true;
  users.users.pascal.extraGroups = [ "wireshark" ];

  home-manager.users.pascal = {
    home.packages = [
      pkgs.gimp
      pkgs.inkscape
      pkgs.kdePackages.dolphin
      pkgs.kdePackages.ffmpegthumbs
      pkgs.kdePackages.gwenview
      pkgs.kdePackages.k3b
      pkgs.kdePackages.kdegraphics-thumbnailers
      pkgs.kdePackages.okular
      pkgs.networkmanagerapplet
      pkgs.pdfpc
      pkgs.pwvucontrol
      pkgs.tenacity
      pkgs.vlc
      pkgs.wireshark
    ];

    xdg.configFile = {
      dolphinrc.source = ../../resources/kde/dolphin.toml;
      gwenviewrc.source = ../../resources/kde/gwenview.toml;
      "menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
      okularpartrc.source = ../../resources/kde/okular.toml;
    };
  };
}

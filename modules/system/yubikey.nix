{ hmcfg, pkgs, ... }: {
  services.pcscd.enable = true;

  home-manager.users.pascal = {
    home.packages = [ pkgs.yubioath-flutter ];
    programs.gpg.scdaemonSettings.disable-ccid = true;
  };

  security.pam.u2f = {
    enable = true;

    settings = {
      cue = true;
      origin = "pam://pascal";
    };
  };

  sops.secrets.u2f_keys = {
    owner = "pascal";
    path = "${hmcfg.xdg.configHome}/Yubico/u2f_keys";
  };
}

{ hmcfg, ... }: {
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

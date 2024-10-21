{ hmcfg, ... }: {
  # Setup U2F login
  security.pam.u2f = {
    enable = true;

    settings = {
      cue = true;
      origin = "pam://pascal";
    };
  };

  # Setup U2F keys
  sops.secrets.u2f_keys = {
    owner = "pascal";
    path = "${hmcfg.xdg.configHome}/Yubico/u2f_keys";
  };
}

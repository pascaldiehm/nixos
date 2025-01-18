{ pkgs, ... }: {
  home-manager.users.pascal.home.packages = [ pkgs.yubioath-flutter ];

  security.pam.u2f = {
    enable = true;

    settings = {
      cue = true;
      origin = "pam://pascal";
    };
  };

  services = {
    pcscd.enable = true;

    udev.extraRules = ''
      ACTION=="remove", SUBSYSTEM=="usb", ENV{PRODUCT}=="1050/407/543", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"

      ACTION=="add", SUBSYSTEM=="usb", ENV{PRODUCT}=="1050/407/543", RUN+="${pkgs.writeShellScript "yubikey-unlock" ''
        [ -n "$(${pkgs.yubikey-manager}/bin/ykman list --serials | grep '16869449')" ] && ${pkgs.systemd}/bin/loginctl unlock-sessions
      ''}"
    '';
  };

  sops.secrets.u2f_keys = {
    owner = "pascal";
    path = "/home/pascal/.config/Yubico/u2f_keys";
  };
}

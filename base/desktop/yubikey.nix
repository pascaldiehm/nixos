{ lib, pkgs, ... }: {
  home-manager.users.pascal.home.packages = [ pkgs.yubikey-manager ];

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
      ACTION=="add", SUBSYSTEM=="usb", ENV{PRODUCT}=="1050/407/543", RUN+="${pkgs.writeShellScript "yubikey-unlock" ''
        ${lib.getExe pkgs.yubikey-manager} list --serials | grep -q 16869449 && ${lib.getExe' pkgs.systemd "loginctl"} unlock-sessions || exit 0
      ''}"

      ACTION=="remove", SUBSYSTEM=="usb", ENV{PRODUCT}=="1050/407/543", RUN+="${pkgs.writeShellScript "yubikey-lock" ''
        for DEVICE in /dev/input/event*; do
          ${lib.getExe pkgs.evtest} --query "$DEVICE" EV_KEY KEY_LEFTCTRL || exit 0
        done

        ${lib.getExe' pkgs.systemd "loginctl"} lock-sessions
      ''}"
    '';
  };

  sops.secrets.u2f_keys = {
    owner = "pascal";
    path = "/home/pascal/.config/Yubico/u2f_keys";
  };
}

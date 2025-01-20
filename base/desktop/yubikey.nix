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
        if "${pkgs.yubikey-manager}/bin/ykman" list --serials | grep "16869449" > /dev/null; then
          ${pkgs.systemd}/bin/loginctl unlock-sessions
          WAYLAND_DISPLAY=wayland-0 XDG_RUNTIME_DIR=/run/user/1000 ${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor --dpms on
        fi
      ''}"
    '';
  };

  sops.secrets.u2f_keys = {
    owner = "pascal";
    path = "/home/pascal/.config/Yubico/u2f_keys";
  };
}

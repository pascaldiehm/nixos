{ config, lib, pkgs, ... }: {
  home-manager.users.pascal = {
    programs.thunderbird = {
      enable = true;
      profiles.default.isDefault = true;
      settings."mail.collect_email_address_outgoing" = false;

      package = pkgs.thunderbird.override {
        extraPolicies.ExtensionSettings = lib.mkMozillaExtensions ../../resources/extensions/thunderbird.json;
      };
    };

    systemd.user.services.thunderbird-notify = {
      Install.WantedBy = [ "default.target" ];
      Service.ExecStart = "${lib.getExe config.home-manager.users.pascal.programs.thunderbird.package} --headless";
      Unit.Description = "Thunderbird notification daemon";
    };
  };
}

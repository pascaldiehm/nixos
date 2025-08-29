{ lib, pkgs, ... }: {
  environment.persistence."/perm".users.pascal.directories = [ ".thunderbird/default" ];

  home-manager.users.pascal = {
    accounts.email.accounts.default = {
      address = "pdiehm8@gmail.com";
      flavor = "gmail.com";
      primary = true;
      realName = "Pascal Diehm";
      thunderbird.enable = true;
      userName = "pdiehm8@gmail.com";
    };

    programs.thunderbird = {
      enable = true;
      profiles.default.isDefault = true;
      settings."mail.collect_email_address_outgoing" = false;

      package = pkgs.thunderbird.override {
        extraPolicies.ExtensionSettings = lib.mkMozillaExtensions ../../resources/extensions/thunderbird.json { };
      };
    };
  };
}

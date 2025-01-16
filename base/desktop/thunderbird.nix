{ libx, pkgs, ... }: {
  home-manager.users.pascal.programs.thunderbird = {
    enable = true;

    package = pkgs.thunderbird.override {
      extraPolicies.ExtensionSettings = libx.mkMozillaExtensions ../../resources/extensions/thunderbird.json;
    };

    profiles.default = {
      isDefault = true;
      withExternalGnupg = true;
    };

    settings = {
      "mail.collect_email_address_outgoing" = false;
      "mail.openpgp.fetch_pubkes_from_gnupg" = true;
    };
  };
}

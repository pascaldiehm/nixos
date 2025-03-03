{ config, ... }: {
  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ config.sops.secrets."university/eduroam/network".path ];

    profiles = {
      bayern-wlan = {
        connection = {
          autoconnect-priority = 25;
          id = "BayernWLAN";
          type = "wifi";
        };

        wifi = {
          mode = "infrastructure";
          ssid = "@BayernWLAN";
        };
      };

      eduroam = {
        wifi-security.key-mgmt = "wpa-eap";

        "802-1x" = {
          ca-cert = config.sops.secrets."university/eduroam/ca-cert".path;
          client-cert = config.sops.secrets."university/eduroam/client-cert".path;
          eap = "tls";
          identity = "$EDUROAM_IDENTITY";
          private-key = config.sops.secrets."university/eduroam/private-key".path;
          private-key-password = "$EDUROAM_PASSWORD";
        };

        connection = {
          autoconnect-priority = 50;
          id = "eduroam";
          type = "wifi";
        };

        wifi = {
          mode = "infrastructure";
          ssid = "eduroam";
        };
      };

      university = {
        connection = {
          id = "University";
          type = "vpn";
        };

        vpn = {
          authtype = "password";
          cookie-flags = 2;
          gateway = "vpngw.uni-wuerzburg.de";
          gateway-flags = 2;
          gwcert-flags = 2;
          protocol = "anyconnect";
          service-type = "org.freedesktop.NetworkManager.openconnect";
        };
      };
    };
  };

  sops.secrets = {
    "university/eduroam/ca-cert" = { };
    "university/eduroam/client-cert" = { };
    "university/eduroam/network".restartUnits = [ "NetworkManager-ensure-profiles.service" ];
    "university/eduroam/private-key" = { };
  };
}

{ config, pkgs, ... }: {
  networking.networkmanager = {
    plugins = [ pkgs.networkmanager-openconnect ];

    ensureProfiles.profiles = {
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
          autoconnect = false;
          id = "@university";
          type = "vpn";
        };

        vpn = {
          authtype = "password";
          autoconnect-flags = 0;
          certsigs-flags = 0;
          cookie-flags = 2;
          disable_udp = "no";
          enable_csd_trojan = "no";
          gateway = "vpngw.uni-wuerzburg.de";
          gateway-flags = 2;
          gwcert-flags = 2;
          lasthost-flags = 0;
          pem_passphrase_fsid = "no";
          prevent_invalid_cert = "no";
          protocol = "anyconnect";
          resolve-flags = 2;
          service-type = "org.freedesktop.NetworkManager.openconnect";
          stoken_source = "disabled";
          useragent = "AnyConnect";
          xmlconfig-flags = 0;
        };
      };
    };
  };

  sops.secrets = {
    "university/eduroam/ca-cert" = { };
    "university/eduroam/client-cert" = { };
    "university/eduroam/private-key" = { };
  };
}

{ config, lib, ... }: {
  options.nix.cache = lib.mkOption {
    default = null;
    type = lib.types.nullOr lib.types.str;
  };

  config = lib.mkIf (config.nix.cache != null) {
    nix.settings.substituters = lib.mkForce [ "http://127.0.0.1:5778" ];

    services.nginx = {
      enable = true;

      virtualHosts.nix-substituter-proxy = {
        locations = {
          "/" = {
            proxyPass = config.nix.cache;

            extraConfig = ''
              add_header X-Upstream ${config.nix.cache};
              error_page 502 504 = @fallback;
              proxy_connect_timeout 100ms;
              proxy_read_timeout 100ms;
            '';
          };

          "@fallback" = {
            proxyPass = "https://cache.nixos.org";

            extraConfig = ''
              add_header X-Upstream https://cache.nixos.org;
              proxy_ssl_server_name on;
              proxy_ssl_trusted_certificate /etc/ssl/certs/ca-certificates.crt;
              proxy_ssl_verify on;
            '';
          };
        };

        listen = lib.singleton {
          addr = "127.0.0.1";
          port = 5778;
        };
      };
    };

    systemd.services.nginx = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };
  };
}

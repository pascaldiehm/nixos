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
          "@fallback".proxyPass = "https://cache.nixos.org";

          "/" = {
            proxyPass = config.nix.cache;

            extraConfig = ''
              error_page 502 504 = @fallback;
              proxy_connect_timeout 100ms;
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

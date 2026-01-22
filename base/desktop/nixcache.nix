{ lib, ... }: {
  nix.settings = {
    substituters = lib.mkForce [ "http://127.0.0.1:5777" ];
    trusted-public-keys = [ "private:Gj04okCf2KAYVNSQ5vwXCgOLRz+ESUGi/YlvT1rsnpQ=" ];
  };

  services.nginx = {
    enable = true;
    proxyResolveWhileRunning = true;
    resolver.addresses = [ "127.0.0.53" ];

    virtualHosts.nix-cache = {
      extraConfig = "recursive_error_pages on;";

      locations = {
        "/" = {
          proxyPass = "http://192.168.1.88:5779";

          extraConfig = ''
            error_page 404 = @cache;
            error_page 502 504 = @upstream;
            proxy_connect_timeout 100ms;
            proxy_intercept_errors on;
          '';
        };

        "@cache" = {
          proxyPass = "http://192.168.1.88:5778";

          extraConfig = ''
            error_page 502 504 = @upstream;
            proxy_connect_timeout 100ms;
            proxy_intercept_errors on;
          '';
        };

        "@upstream" = {
          proxyPass = "https://cache.nixos.org";

          extraConfig = ''
            proxy_ssl_server_name on;
            proxy_ssl_trusted_certificate /etc/ssl/certs/ca-certificates.crt;
            proxy_ssl_verify on;
          '';
        };
      };

      listen = lib.singleton {
        addr = "127.0.0.1";
        port = 5777;
      };
    };
  };
}

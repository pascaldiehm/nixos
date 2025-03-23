{ inputs, lib, ... }: {
  nix = {
    channel.enable = false;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    registry.nixpkgs.flake = inputs.nixpkgs;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = [ "flakes" "nix-command" "pipe-operators" ];
      substituters = lib.mkForce [ "http://127.0.0.1:5778" ];
      use-xdg-base-directories = true;
    };
  };

  services.nginx = {
    enable = true;

    virtualHosts.nix-subsituter-proxy = {
      locations = {
        "@fallback".proxyPass = "https://cache.nixos.org";

        "/" = {
          proxyPass = "http://bowser:5779";

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
}

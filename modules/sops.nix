{ config, lib, ... }: {
  options.sops.common = lib.mkOption {
    default = { };

    type = lib.types.attrsOf (
      lib.types.submodule (
        { config, ... }: {
          options = {
            key = lib.mkOption {
              default = config._module.args.name;
              type = lib.types.str;
            };

            name = lib.mkOption {
              default = "common/${config._module.args.name}";
              type = lib.types.str;
            };

            neededForUsers = lib.mkOption {
              default = false;
              type = lib.types.bool;
            };

            owner = lib.mkOption {
              default = null;
              type = lib.types.nullOr lib.types.str;
            };

            path = lib.mkOption {
              default = "/run/secrets/${config.name}";
              type = lib.types.str;
            };
          };
        }
      )
    );
  };

  config.sops.secrets = lib.mapAttrs' (name: value: {
    inherit (value) name;

    value = value // {
      sopsFile = ../resources/secrets/common/store.yaml;
    };
  }) config.sops.common;
}

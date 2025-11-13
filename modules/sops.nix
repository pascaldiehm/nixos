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
              default = "/run/secrets${lib.optionalString config.neededForUsers "-for-users"}/${config.name}";
              type = lib.types.str;
            };

            sopsFile = lib.mkOption {
              default = ../resources/secrets/common/store.yaml;
              type = lib.types.path;
            };
          };
        }
      )
    );
  };

  config.sops.secrets = lib.mapAttrs' (name: value: {
    inherit (value) name;
    inherit value;
  }) config.sops.common;
}

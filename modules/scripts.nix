{ config, lib, ... }: {
  options.programs.scripts = lib.mkOption {
    default = { };

    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          text = lib.mkOption { type = lib.types.lines; };

          deps = lib.mkOption {
            default = [ ];
            type = lib.types.listOf lib.types.package;
          };
        };
      }
    );
  };

  config.nixpkgs.overlays = [
    (pkgs: prev: {
      scripts = lib.mapAttrs (
        name: config: pkgs.writeShellApplication {
          inherit name;
          inherit (config) text;
          runtimeInputs = config.deps;
        }
      ) config.programs.scripts;
    })
  ];
}

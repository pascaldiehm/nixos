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
      pd = lib.mapAttrs (
        name: cfg: pkgs.writeShellApplication {
          inherit name;
          inherit (cfg) text;
          runtimeInputs = cfg.deps;
        }
      ) config.programs.scripts;
    })
  ];
}

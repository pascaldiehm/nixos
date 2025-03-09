{ config, lib, ... }: let
  cfg = config.programs.scripts;

  scriptType.options = {
    text = lib.mkOption { type = lib.types.lines; };

    deps = lib.mkOption {
      default = [ ];
      type = lib.types.listOf lib.types.package;
    };
  };
in
{
  options.programs.scripts = lib.mkOption {
    default = { };
    type = lib.types.attrsOf (lib.types.submodule scriptType);
  };

  config.nixpkgs.overlays = [
    (pkgs: prev: {
      scripts = lib.mapAttrs (
        name: config:
        pkgs.writeShellApplication {
          inherit name;
          inherit (config) text;
          runtimeInputs = config.deps;
        }
      ) cfg;
    })
  ];
}

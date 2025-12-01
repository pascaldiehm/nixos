{ config, lib, machine, pkgs, ... }: {
  options.services.backup = lib.mkOption {
    default = { };

    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          excludeGlob = lib.mkOption {
            default = [ ];
            type = lib.types.listOf lib.types.str;
          };

          excludeRegex = lib.mkOption {
            default = [ ];
            type = lib.types.listOf lib.types.str;
          };

          include = lib.mkOption {
            default = null;
            type = lib.types.nullOr (lib.types.listOf lib.types.str);
          };
        };
      }
    );
  };

  config = {
    environment.persistence."/perm".directories = [ "/var/lib/duplicity" ];
    home-manager.users.pascal.home.packages = [ pkgs.scripts.backup ];

    programs.scripts.backup = {
      deps = [ pkgs.duplicity ];

      text = let
        paths = lib.mapAttrsToList (
          path: cfg: lib.map (glob: [ "--exclude '${path}/${glob}'" ]) cfg.excludeGlob
          ++ lib.map (re: [ "--exclude-regexp '${lib.escapeRegex path}/${re}'" ]) cfg.excludeRegex
          ++ (if cfg.include == null then [ "--include '${path}'" ] else lib.map (sub: "--include '${path}/${sub}'") cfg.include)
        ) config.services.backup;
      in lib.templateString {
        BACKUP_ENV = config.sops.common."backup/env".path;
        BACKUP_KEY = config.sops.common."backup/key".path;
        MACHINE = machine.name;
        SPEC = lib.flatten paths;
        TARGET = "sftp://pascal@bowser:1970/archive/Backups";
      } (lib.readFile ../resources/scripts/backup.sh);
    };

    systemd = {
      timers.backup.timerConfig.Persistent = true;

      services.backup = {
        enable = false; # TODO: Enable this once WireGuard is set up
        after = [ "network-online.target" ];
        description = "Backup local files";
        requires = [ "network-online.target" ];
        startAt = "daily";

        serviceConfig = {
          ExecStart = lib.getExe pkgs.scripts.backup;
          Type = "oneshot";
        };
      };
    };

    sops.common = {
      "backup/env" = { };
      "backup/key" = { };
    };
  };
}

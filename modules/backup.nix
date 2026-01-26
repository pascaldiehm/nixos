{ config, lib, machine, pkgs, ... }: let
  cfg = config.services.backup;
in {
  options.services.backup = {
    postStart = lib.mkOption {
      default = "";
      type = lib.types.lines;
    };

    preStart = lib.mkOption {
      default = "";
      type = lib.types.lines;
    };

    targets = lib.mkOption {
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
  };

  config = {
    environment.persistence."/perm".directories = [ "/var/lib/duplicity" ];
    home-manager.users.pascal.home.packages = [ pkgs.scripts.backup ];

    programs.scripts.backup = {
      deps = [ pkgs.duplicity ];

      text = let
        paths = lib.mapAttrsToList (
          loc: cfg: lib.map (glob: [ "--exclude" "${loc}/${glob}" ]) cfg.excludeGlob
          ++ lib.map (re: [ "--exclude-regexp" "${lib.escapeRegex loc}/${re}" ]) cfg.excludeRegex
          ++ (if cfg.include == null then [ "--include" loc ] else lib.map (inc: [ "--include" "${loc}/${inc}" ]) cfg.include)
        ) cfg.targets;
      in lib.readFile ../resources/scripts/backup.sh
      |> lib.templateString {
        BACKUP_KEY = config.sops.common."backup/key".path;
        BACKUP_PASS = config.sops.common."backup/pass".path;
        MACHINE = machine.name;
        POST_START = pkgs.writeShellScript "backup-post" cfg.postStart;
        PRE_START = pkgs.writeShellScript "backup-pre" cfg.preStart;
        SPEC = lib.flatten paths |> lib.escapeShellArgs;
        TARGET = "sftp://pascal@bowser:1970/archive/Backups";
      };
    };

    systemd = {
      timers.backup.timerConfig.Persistent = true;

      services.backup = {
        after = [ "network-online.target" ];
        description = "Backup local files";
        preStart = "until ${lib.getExe pkgs.netcat} -z bowser 1970; do sleep 1; done";
        requires = [ "network-online.target" ];
        startAt = "Mon 00:30";

        serviceConfig = {
          ExecStart = lib.getExe pkgs.scripts.backup;
          Type = "oneshot";
        };
      };
    };

    sops.common = {
      "backup/key" = { };
      "backup/pass" = { };
    };
  };
}

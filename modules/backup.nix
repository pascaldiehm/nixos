{ config, lib, machine, pkgs, ... }: {
  options.services.backup = lib.mkOption {
    default = { };

    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          excludeExtension = lib.mkOption {
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

      text =
        let
          args = "--archive-dir /var/lib/duplicity --ssh-options '-i \"${config.sops.common."backup/key".path}\"'";
          include = lib.flatten paths |> lib.concatStringsSep " ";
          target = "sftp://pascal@bowser:1970/archive/Backups";

          paths = lib.mapAttrsToList (
            path: cfg:
            lib.map (ext: [ "--exclude '${path}/**.${ext}'" ]) cfg.excludeExtension
            ++ lib.map (re: [ "--exclude-regexp '${lib.escapeRegex path}/${re}'" ]) cfg.excludeRegex
            ++ (if cfg.include == null then [ "--include '${path}'" ] else lib.map (sub: "--include '${path}/${sub}'") cfg.include)
          ) config.services.backup;
        in
        ''
          test "$UID" = 0 || exec sudo "$0" "$@"
          set -a

          # shellcheck disable=SC1091
          source "${config.sops.common."backup/env".path}"

          if [ "$#" = 0 ]; then
            duplicity ${args} cleanup --force "${target}/${machine.name}"
            duplicity ${args} remove-all-but-n-full --force 2 "${target}/${machine.name}"
            duplicity ${args} incremental --full-if-older-than 1M / "${target}/${machine.name}" ${include} --exclude "**"
          elif [ "$1" = "status" ]; then
            duplicity ${args} collection-status "${target}/''${2:-${machine.name}}"
          elif [ "$1" = "list" ]; then
            duplicity ${args} list-current-files "${target}/''${2:-${machine.name}}"
          elif [ "$1" = "restore" ]; then
            if [ "$#" = 2 ]; then
              duplicity ${args} restore "${target}/${machine.name}" "$2"
            elif [ "$#" = 3 ]; then
              duplicity ${args} restore --path-to-restore "$2" "${target}/${machine.name}" "$3"
            elif [ "$#" = 4 ]; then
              duplicity ${args} restore --path-to-restore "$3" "${target}/$2" "$4"
            else
              echo "Usage: backup restore [[machine] path] <target>"
              exit 1
            fi
          else
            echo "Unknown command: $1"
            exit 1
          fi
        '';
    };

    systemd = {
      timers.backup.timerConfig.Persistent = true;

      services.backup = {
        enable = false; # TODO: Enable this once WireGuard is set up
        after = [ "network-online.target" ];
        description = "Backup local files";
        requires = [ "network-online.target" ];
        serviceConfig.ExecStart = lib.getExe pkgs.scripts.backup;
        startAt = "daily";
      };
    };

    sops.common = {
      "backup/env" = { };
      "backup/key" = { };
    };
  };
}

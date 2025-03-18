{ config, lib, ... }: {
  environment.persistence."/perm" = {
    directories = [ "/etc/nixos" "/etc/ssh" "/var/lib/docker" "/var/lib/nixos" "/var/lib/systemd" ];
    files = [ "/etc/machine-id" ];

    users.pascal.directories = lib.mapAttrsToList (directory: mode: { inherit directory mode; }) {
      ".config/nixos" = "0755";
      ".ssh" = "0700";
    };
  };

  system.activationScripts.cleanPerm =
    let
      cfg = config.environment.persistence."/perm";
      dirs = lib.map (dir: "/perm${dir.dirPath}") cfg.directories;
      files = lib.map (file: "/perm${file.filePath}") cfg.files;
      paths = lib.map (path: "-path ${path}") (dirs ++ files);
    in
    ''
      find /perm \( ${lib.concatStringsSep " -o " paths} \) -prune -o -type f -exec rm "{}" \;
      find /perm \( ${lib.concatStringsSep " -o " paths} \) -prune -o -type d -empty -exec rmdir "{}" \;
    '';
}

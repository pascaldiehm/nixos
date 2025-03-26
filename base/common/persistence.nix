{ config, lib, ... }: {
  environment.persistence."/perm" = {
    directories = [ "/etc/nixos" "/etc/ssh" "/var/lib/docker" "/var/lib/nixos" "/var/lib/systemd" ];
    files = [ "/etc/machine-id" ];

    users.pascal.directories = lib.mapAttrsToList (directory: mode: { inherit directory mode; }) {
      ".config/nixos" = "0755";
      ".ssh" = "0700";
    };
  };

  system.activationScripts.clean-perm =
    let
      cfg = config.environment.persistence."/perm";
      dirs = lib.map (dir: "-path '/perm${dir.dirPath}' -o -path '/perm${dir.dirPath}/*'") cfg.directories;
      files = lib.map (file: "-path '/perm${file.filePath}'") cfg.files;
      paths = "\\( ${lib.concatStringsSep " -o " (dirs ++ files)} \\)";
    in
    ''
      find /perm -not ${paths} -not -type d -exec rm "{}" +
      find /perm -depth -not ${paths} -type d -exec rmdir --ignore-fail-on-non-empty "{}" +
    '';
}

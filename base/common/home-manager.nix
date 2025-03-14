{ config, lib, ... }: {
  home-manager = {
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    useUserPackages = true;

    users.pascal = {
      programs.home-manager.enable = true;
      xdg.enable = true;

      home = {
        inherit (config.system) stateVersion;
        homeDirectory = "/home/pascal";
        username = "pascal";

        activation.deleteBackups = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run find /home/pascal -name "*.hm-bak" -exec rm -rf "{}" \;
        '';
      };
    };
  };
}

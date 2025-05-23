{ config, inputs, lib, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

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

        activation.delete-backups = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run find /home/pascal -name "*.hm-bak" -exec rm -rf "{}" +
        '';
      };
    };
  };
}

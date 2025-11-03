{ config, inputs, lib, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    useUserPackages = true;

    users.pascal = {
      programs.home-manager.enable = true;

      home = {
        homeDirectory = "/home/pascal";
        stateVersion = config.system.stateVersion;
        username = "pascal";

        activation.delete-backups = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run find /home/pascal -path /home/pascal/Shared -prune -o -name "*.hm-bak" -exec rm -rf "{}" +
        '';
      };
    };
  };
}

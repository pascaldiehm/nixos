{ inputs, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    backupFileExtension = "hm-bak";
    overwriteBackup = true;
    useGlobalPkgs = true;
    useUserPackages = true;

    users.pascal = {
      programs.home-manager.enable = true;

      home = {
        homeDirectory = "/home/pascal";
        stateVersion = "24.11";
        username = "pascal";
      };
    };
  };
}

{ config, ... }: {
  home-manager = {
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;

    users.pascal = {
      programs.home-manager.enable = true;

      home = {
        homeDirectory = "/home/pascal";
        stateVersion = config.system.stateVersion;
        username = "pascal";
      };
    };
  };
}

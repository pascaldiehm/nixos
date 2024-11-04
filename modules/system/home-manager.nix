{ config, helpers, ... }: {
  home-manager = {
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    useUserPackages = true;

    users.pascal = {
      programs.home-manager.enable = true;

      home = {
        activation.deleteBackups = helpers.mkHMActivation [ "writeBoundary" ] "run rm -rf $(find $HOME -name '*.hm-bak')";
        homeDirectory = "/home/pascal";
        stateVersion = config.system.stateVersion;
        username = "pascal";
      };
    };
  };
}

{ config, helpers, ... }: {
  home-manager = {
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    useUserPackages = true;

    users.pascal = {
      programs.home-manager.enable = true;

      home = {
        activation.deleteBackups = helpers.mkHMActivation [ "writeBoundary" ] "run find $HOME -name '*.hm-bak' -exec rm -rf {} \\;";
        homeDirectory = "/home/pascal";
        stateVersion = config.system.stateVersion;
        username = "pascal";
      };
    };
  };
}

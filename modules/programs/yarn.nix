{ hmcfg, pkgs, helpers, ... }: {
  home-manager.users.pascal = {
    # Install yarn
    home.packages = [ pkgs.nodejs pkgs.yarn ];

    # Setup global folder
    home.sessionVariables = {
      YARN_GLOBAL_FOLDER = "${hmcfg.xdg.configHome}/yarn/global";
      YARN_PREFIX = hmcfg.home.sessionVariables.YARN_GLOBAL_FOLDER;
    };

    xdg.configFile = {
      "yarn/global/package.json".source = ../../resources/yarn/package.json;
      "yarn/global/yarn.lock".source = ../../resources/yarn/yarn.lock;
    };

    # Install global packages
    systemd.user.services.installGlobalYarnPackages = {
      Install.WantedBy = [ "multi-user.target" ];

      Service = {
        ExecStartPre = helpers.mkScript "until ping -c 1 1.1.1.1; do sleep 1; done";

        ExecStart = helpers.mkScript ''
          cd ${hmcfg.home.sessionVariables.YARN_GLOBAL_FOLDER}
          yarn install
          rm -f bin
          ln -s node_modules/.bin bin
        '';
      };

      Unit = {
        After = [ "network-online.target" ];
        Description = "Install global yarn packages";
      };
    };

    # Add yarn packages to path
    home.sessionPath = [ "${hmcfg.home.sessionVariables.YARN_PREFIX}/bin" ];
  };
}

{ hmcfg, pkgs, ... }: {
  home-manager.users.pascal = {
    home = {
      packages = [ pkgs.nodejs pkgs.yarn ];
      sessionPath = [ "${hmcfg.home.sessionVariables.YARN_PREFIX}/bin" ];

      sessionVariables = {
        YARN_GLOBAL_FOLDER = "${hmcfg.xdg.configHome}/yarn/global";
        YARN_PREFIX = hmcfg.home.sessionVariables.YARN_GLOBAL_FOLDER;
      };
    };

    systemd.user.services.installGlobalYarnPackages = {
      Install.WantedBy = [ "multi-user.target" ];

      Service = {
        ExecStartPre = pkgs.writeShellScript "wait-for-network" "until ping -c 1 1.1.1.1; do sleep 1; done";

        ExecStart = pkgs.writeShellScript "install-global-yarn-packages" ''
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

    xdg.configFile = {
      "yarn/global/package.json".source = ../../resources/yarn/package.json;
      "yarn/global/yarn.lock".source = ../../resources/yarn/yarn.lock;
    };
  };
}

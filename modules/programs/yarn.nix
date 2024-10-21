{ hmcfg, pkgs, helpers, ... }: {
  home-manager.users.pascal = {
    # Install yarn
    home.packages = [ pkgs.nodejs pkgs.yarn ];

    # Setup global folder
    home.activation.installGlobalYarnPackages = helpers.mkHomeManagerActivation [ "writeBoundary" ] ''
      DIR="${hmcfg.home.sessionVariables.YARN_GLOBAL_FOLDER}"
      run ${pkgs.yarn}/bin/yarn --cwd "$DIR" install
      run rm -rf "$DIR/bin"
      run ln -s "$DIR/node_modules/.bin" "$DIR/bin"
    '';

    home.sessionVariables = {
      YARN_GLOBAL_FOLDER = "${hmcfg.xdg.configHome}/yarn/global";
      YARN_PREFIX = hmcfg.home.sessionVariables.YARN_GLOBAL_FOLDER;
    };

    xdg.configFile = {
      "yarn/global/package.json".source = ../../resources/yarn/package.json;
      "yarn/global/yarn.lock".source = ../../resources/yarn/yarn.lock;
    };

    # Add yarn packages to path
    home.sessionPath = [ "${hmcfg.home.sessionVariables.YARN_PREFIX}/bin" ];
  };
}

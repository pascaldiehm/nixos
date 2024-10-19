{ config, lib, pkgs, ... }: {
  # Install yarn and NodeJS
  home.packages = [
    pkgs.nodejs
    pkgs.yarn
  ];

  # Global folder
  xdg.configFile = {
    "yarn/global/package.json".source = ../../resources/yarn/package.json;
    "yarn/global/yarn.lock".source = ../../resources/yarn/yarn.lock;
  };

  # Install global packages
  home.activation.installGlobalYarnPackages = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.yarn}/bin/yarn --cwd ${config.home.sessionVariables.YARN_GLOBAL_FOLDER} install
    [ -h ${config.home.sessionVariables.YARN_GLOBAL_FOLDER}/bin ] && run rm ${config.home.sessionVariables.YARN_GLOBAL_FOLDER}/bin
    run ln -s ${config.home.sessionVariables.YARN_GLOBAL_FOLDER}/node_modules/.bin ${config.home.sessionVariables.YARN_GLOBAL_FOLDER}/bin
  '';

  # Update yarn path
  home.sessionVariables = {
    YARN_GLOBAL_FOLDER = "${config.xdg.configHome}/yarn/global";
    YARN_PREFIX = config.home.sessionVariables.YARN_GLOBAL_FOLDER;
  };

  # Add binary directory to PATH
  home.sessionPath = [ "${config.home.sessionVariables.YARN_GLOBAL_FOLDER}/bin" ];
}

{ hmcfg, helpers, ... }: {
  home-manager.users.pascal = {
    home.activation.deleteChannelLinks = helpers.mkHMActivation [ "writeBoundary" "installPackages" "linkGeneration" ] "run rm -rf $HOME/.nix-defexpr $HOME/.nix-profile";

    xdg = {
      enable = true;
      mimeApps.enable = true;

      userDirs = {
        enable = true;
        createDirectories = true;
      };
    };
  };
}

{ hmcfg, helpers, ... }: {
  home-manager.users.pascal = {
    # Delete dead channel links
    home.activation.deleteChannelLinks = helpers.mkHomeManagerActivation [ "writeBoundary" "installPackages" "linkGeneration" ] "run rm -rf $HOME/.nix-defexpr $HOME/.nix-profile";

    # Enable XDG
    xdg = {
      enable = true;
      mimeApps.enable = true;

      userDirs = {
        enable = true;
        createDirectories = true;
      };
    };
  };

  # Mount tmpfs in ~/Downloads
  systemd.mounts = [{
    description = "Mount tmpfs in ~/Downloads";
    type = "tmpfs";
    wantedBy = [ "multi-user.target" ];
    what = "tmpfs";
    where = hmcfg.xdg.userDirs.download;
  }];
}

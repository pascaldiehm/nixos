{ hmcfg, helpers, ... }: {
  home-manager.users.pascal = {
    home.activation = {
      deleteChannelLinks = helpers.mkHMActivation [ "writeBoundary" "installPackages" "linkGeneration" ] "run rm -rf $HOME/.nix-defexpr $HOME/.nix-profile";

      cleanHome = helpers.mkHMActivation [ "writeBoundary" ] ''
        run rm -rf \
          $HOME/.config/Code/User/History \
          $HOME/.config/Code/User/workspaceStorage \
          $HOME/.config/zsh/.zsh_history \
          $HOME/.docker \
          $HOME/.local/share/nix/repl-history \
          $HOME/.node_repl_history \
          $HOME/.npm \
          $HOME/.python_history \
          $HOME/.vim \
          $HOME/.yarn \
          $HOME/.yarnrc
      '';
    };

    xdg = {
      enable = true;
      mimeApps.enable = true;

      userDirs = {
        enable = true;
        createDirectories = true;
      };
    };
  };

  systemd.mounts = [{
    description = "Mount tmpfs in ~/Downloads";
    type = "tmpfs";
    wantedBy = [ "local-fs.target" ];
    what = "tmpfs";
    where = hmcfg.xdg.userDirs.download;
  }];
}

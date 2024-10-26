{ hmcfg, helpers, ... }: {
  home-manager.users.pascal = {
    # Remove unwanted files from home directory
    home.activation = {
      deleteChannelLinks = helpers.mkHomeManagerActivation [ "writeBoundary" "installPackages" "linkGeneration" ] "run rm -rf $HOME/.nix-defexpr $HOME/.nix-profile";

      cleanHome = helpers.mkHomeManagerActivation [ "writeBoundary" ] ''
        run rm -rf \
          $HOME/.config/Code/User/History \
          $HOME/.config/Code/User/workspaceStorage \
          $HOME/.config/zsh/.zsh_history \
          $HOME/.docker \
          $HOME/.gtkrc-2.0 \
          $HOME/.local/share/nix/repl-history \
          $HOME/.node_repl_history \
          $HOME/.npm \
          $HOME/.python_history \
          $HOME/.vim \
          $HOME/.yarnrc
      '';
    };

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
    wantedBy = [ "local-fs.target" ];
    what = "tmpfs";
    where = hmcfg.xdg.userDirs.download;
  }];
}

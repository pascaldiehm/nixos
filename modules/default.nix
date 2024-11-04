{ lib, config, ... }: {
  # Import modules
  imports = [
    ./extra/_.nix
    ./programs/_.nix
    ./system/_.nix
  ];

  # Custom helper functions
  _module.args.helpers = rec {
    mkFirefoxBookmarks = set: builtins.map (name: { inherit name; url = set.${name}; }) (builtins.attrNames set);

    mkFirefoxBookmarksFolder = name: set: { inherit name; bookmarks = mkFirefoxBookmarks set; };

    mkHMActivation = after: data: { inherit after data; before = [ ]; };

    mkMozillaExtensions = path: { "*".installation_mode = "blocked"; } // builtins.listToAttrs (builtins.map (ext: { name = ext.id; value = { installation_mode = "force_installed"; install_url = ext.source; }; }) (lib.importJSON path));

    mkPackageList = pkgs: builtins.concatStringsSep "\n" (lib.unique (lib.naturalSort (builtins.map (pkg: pkg.name) pkgs)));

    mkSSHSecrets = list: builtins.listToAttrs (builtins.map (name: { inherit name; value = { owner = "pascal"; restartUnits = [ "home-manager-pascal.service" ]; }; }) list);
  };

  # Shortcut to home manager configuration
  _module.args.hmcfg = config.home-manager.users.pascal;
}

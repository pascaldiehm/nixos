{ lib, config, ... }: {
  # Import modules
  imports = [
    ./extra/_.nix
    ./programs/_.nix
    ./system/_.nix
  ];

  # Custom helper functions
  _module.args.helpers =
    let
      mkFirefoxBookmarks = set: builtins.map (name: { inherit name; url = set.${name}; }) (builtins.attrNames set);

      mkFirefoxBookmarksFolder = name: set: { inherit name; bookmarks = mkFirefoxBookmarks set; };

      mkFirefoxExtensions = list: builtins.listToAttrs (builtins.map
        (id: {
          name = id;
          value = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
          };
        })
        list);

      mkHomeManagerActivation = after: data: { inherit after data; before = [ ]; };

      mkPackageList = pkgs: builtins.concatStringsSep "\n" (lib.unique (lib.naturalSort (builtins.map (pkg: pkg.name) pkgs)));
    in
    {
      inherit mkFirefoxBookmarks;
      inherit mkFirefoxBookmarksFolder;
      inherit mkFirefoxExtensions;
      inherit mkHomeManagerActivation;
      inherit mkPackageList;
    };

  # Shortcut to home manager configuration
  _module.args.hmcfg = config.home-manager.users.pascal;
}

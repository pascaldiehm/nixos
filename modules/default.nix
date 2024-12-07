{ config, lib, ... }: {
  # Import modules
  imports = [
    ./extra/_.nix
    ./programs/_.nix
    ./system/_.nix
  ];

  # Custom helper functions
  _module.args.helpers = rec {
    mapSet = getName: getValue: set: mapToSet getName getValue (builtins.attrNames set);

    mapToSet = getName: getValue: list: builtins.listToAttrs (builtins.map (elem: { name = getName elem; value = getValue elem; }) list);

    mkFirefoxBookmarks = set: builtins.map (name: { inherit name; url = set.${name}; }) (builtins.attrNames set);

    mkFirefoxBookmarksFolder = name: set: { inherit name; bookmarks = mkFirefoxBookmarks set; };

    mkFirefoxSearchEngines = set: mapSet
      (name: builtins.elemAt set.${name} 0)
      (name: {
        definedAliases = builtins.map (alias: "@${alias}") set.${name};
        urls = [{ template = builtins.replaceStrings [ "%s" ] [ "{searchTerms}" ] name; }];
      })
      set;

    mkHMActivation = after: data: { inherit after data; before = [ ]; };

    mkMozillaExtensions = path: { "*".installation_mode = "blocked"; } // mapToSet
      (ext: ext.id)
      (ext: { installation_mode = "force_installed"; install_url = ext.source; })
      (lib.importJSON path);

    mkPackageList = pkgs: builtins.concatStringsSep "\n" (lib.unique (lib.naturalSort (builtins.map (pkg: pkg.name) pkgs)));

    mkSSHSecrets = mapToSet (key: key) (_: { owner = "pascal"; restartUnits = [ "home-manager-pascal.service" ]; });
  };

  # Shortcut to home manager configuration
  _module.args.hmcfg = config.home-manager.users.pascal;
}

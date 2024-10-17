{
  mkFirefoxBookmarks = set: builtins.map (name: { name = name; url = set.${name}; }) (builtins.attrNames set);

  mkFirefoxExtensions = list: builtins.listToAttrs (builtins.map (id: {
    name = id;
    value = {
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
    };
  }) list);

  mkPkgList = pkgs: builtins.concatStringsSep "\n" (builtins.sort (a: b: a < b) (builtins.map (p: p.name) pkgs));

  secrets = builtins.fromJSON (builtins.readFile /etc/nixos/secrets.json);
}

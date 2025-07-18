lib: prev: {
  mkNvimAutoCommands = lib.mapAttrsToList (event: command: { inherit event command; });

  mkFirefoxBookmarks = lib.mapAttrsToList (
    name: value:
    if lib.isAttrs value then
      {
        inherit name;
        toolbar = (name == "_toolbar");
        bookmarks = lib.mkFirefoxBookmarks value;
      }
    else
      {
        inherit name;
        url = value;
      }
  );

  mkFirefoxSearchEngines = lib.mapAttrs (
    name: url:
    if url == null then
      { metaData.hidden = true; }
    else
      {
        urls = [ { template = lib.replaceStrings [ "%s" ] [ "{searchTerms}" ] url; } ];
        definedAliases = [ "@${name}" ];
      }
  );

  mkMozillaExtensions =
    path: settings:
    lib.importJSON path
    |> lib.map (ext: {
      name = ext.id;

      value = {
        default_area = settings.${ext.name}.area or "menupanel";
        install_url = ext.source;
        installation_mode = "force_installed";
        private_browsing = settings.${ext.name}.private or false;
      };
    })
    |> lib.listToAttrs
    |> lib.mergeAttrs { "*".installation_mode = "blocked"; };

  mkNvimFormatters = lib.mapAttrs (
    key: value: {
      command = lib.head value;
      prepend_args = lib.tail value;
    }
  );

  mkNvimKeymaps =
    maps:
    lib.mapAttrsToList (
      mode: keys:
      lib.mapAttrsToList (key: action: {
        inherit action key;
        mode = lib.stringToCharacters mode;
      }) keys
    ) maps
    |> lib.flatten;
}

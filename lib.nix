lib: prev: {
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
        urls = [ { template = lib.replaceStrings [ "%" ] [ "{searchTerms}" ] url; } ];
        definedAliases = [ "@${name}" ];
      }
  );

  mkMozillaExtensions =
    path:
    lib.importJSON path
    |> lib.map (ext: {
      name = ext.id;
      value = {
        installation_mode = "force_installed";
        install_url = ext.source;
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

  mkNvimKeymaps = lib.mapAttrsToList (
    action: value: {
      inherit action;
      key = lib.head value;
      mode = lib.tail value;
    }
  );
}

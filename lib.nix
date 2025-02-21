lib: prev: {
  mkFirefoxBookmarks = lib.mapAttrsToList (
    name: value:
    if builtins.isAttrs value then
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

  mkMozillaExtensions =
    path:
    lib.importJSON path
    |> builtins.map (ext: {
      name = ext.id;
      value = {
        installation_mode = "force_installed";
        install_url = ext.source;
      };
    })
    |> builtins.listToAttrs
    |> lib.mergeAttrs { "*".installation_mode = "blocked"; };

  mkNvimFormatters = builtins.mapAttrs (
    key: value: {
      command = builtins.head value;
      prepend_args = builtins.tail value;
    }
  );

  mkNvimKeymaps = lib.mapAttrsToList (
    action: value: {
      inherit action;
      key = builtins.head value;
      mode = builtins.tail value;
    }
  );
}

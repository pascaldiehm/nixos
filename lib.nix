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
}

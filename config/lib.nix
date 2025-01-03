{ lib, ... }: {
  _module.args.helpers = {
    mkHMActivation = after: data: { inherit after data; before = [ ]; };

    mkMozillaExtensions = path: { "*".installation_mode = "blocked"; } // builtins.listToAttrs (builtins.map
      (ext: { name = ext.id; value = { installation_mode = "force_installed"; install_url = ext.source; }; })
      (lib.importJSON path));
  };
}

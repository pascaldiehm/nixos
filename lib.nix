{ config, lib, pkgs, system, ... }: {
  _module.args.libx = rec {
    mkFirefoxBookmarks = lib.mapAttrsToList (
      name: value:
      if builtins.isAttrs value then
        {
          inherit name;
          toolbar = (name == "_toolbar");
          bookmarks = mkFirefoxBookmarks value;
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

    mkNtfy =
      channel: message:
      pkgs.writeShellScript "ntfy" ''
        TOKEN="$(cat "${config.sops.secrets."${system.name}/ntfy".path}")"
        ${lib.getExe pkgs.curl} -s -H "Authorization: Bearer $TOKEN" -d "${message}" "https://ntfy.pdiehm.dev/${system.name}-${channel}"
      '';
  };
}

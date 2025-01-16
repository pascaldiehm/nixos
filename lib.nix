{
  config,
  lib,
  pkgs,
  system,
  ...
}:
{
  _module.args.libx = {
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
      |> (extensions: { "*".installation_mode = "blocked"; } // extensions);

    mkNtfy =
      channel: message:
      pkgs.writeShellScript "ntfy" ''
        TOKEN="$(cat "${config.sops.secrets."${system.name}/ntfy".path}")"
        ${pkgs.curl}/bin/curl -s -H "Authorization: Bearer $TOKEN" -d "${message}" "https://ntfy.pdiehm.dev/${system.name}-${channel}"
      '';
  };
}

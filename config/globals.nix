{
  _glb,
  config,
  lib,
  pkgs,
  ...
}:
{
  _module.args.glb = {
    machineType = _glb.type;
    nixpkgs = _glb.nixpkgs;

    mkMozillaExtensions =
      path:
      {
        "*".installation_mode = "blocked";
      }
      // builtins.listToAttrs (
        builtins.map (ext: {
          name = ext.id;
          value = {
            installation_mode = "force_installed";
            install_url = ext.source;
          };
        }) (lib.importJSON path)
      );

    mkNtfy =
      channel: message:
      pkgs.writeShellScript "ntfy" ''
        TOKEN="$(cat "${config.sops.secrets."${config.system.name}/ntfy".path}")"
        ${pkgs.curl}/bin/curl -s -H "Authorization: Bearer $TOKEN" -d "${message}" "https://ntfy.pdiehm.dev/${config.system.name}-${channel}"
      '';
  };
}

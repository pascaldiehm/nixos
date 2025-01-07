{ config, lib, pkgs, ... }: {
  _module.args.helpers = {
    mkHMActivation = after: data: { inherit after data; before = [ ]; };

    mkMozillaExtensions = path: { "*".installation_mode = "blocked"; } // builtins.listToAttrs (builtins.map
      (ext: { name = ext.id; value = { installation_mode = "force_installed"; install_url = ext.source; }; })
      (lib.importJSON path));

    ntfy = channel: message: pkgs.writeShellScript "ntfy" ''
      TOKEN="$(cat ${config.sops.secrets."${config.networking.hostName}/ntfy".path})"
      ${pkgs.curl}/bin/curl -s -H "Authorization: Bearer $TOKEN" -d "${message}" 'https://ntfy.pdiehm.dev/${config.networking.hostName}-${channel}'
    '';
  };
}

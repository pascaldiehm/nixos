{ config, lib, machine, pkgs, ... }: {
  sops.secrets."${machine.name}/ntfy" = { };

  environment.systemPackages = lib.singleton (
    pkgs.writeShellApplication {
      name = "ntfy";
      runtimeInputs = [ pkgs.curl ];

      text = ''
        if [ $# != 2 ]; then
          echo "Usage: ntfy <channel> <message>"
          exit 1
        fi

        TOKEN="$(cat "${config.sops.secrets."${machine.name}/ntfy".path}")"
        curl -s -H "Authorization: Bearer $TOKEN" -d "$2" "https://ntfy.pdiehm.dev/${machine.name}-$1"
      '';
    }
  );
}

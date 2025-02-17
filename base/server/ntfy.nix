{ config, machine, pkgs, ... }: {
  home-manager.users.pascal.home.packages = [ pkgs.scripts.ntfy ];
  sops.secrets."${machine.name}/ntfy" = { };

  nixpkgs.overlays = [
    (self: super: {
      scripts.ntfy = self.writeShellApplication {
        name = "ntfy";
        runtimeInputs = [ self.curl ];

        text = ''
          if [ $# != 2 ]; then
            echo "Usage: ntfy <channel> <message>"
            exit 1
          fi

          TOKEN="$(cat "${config.sops.secrets."${machine.name}/ntfy".path}")"
          curl -s -H "Authorization: Bearer $TOKEN" -d "$2" "https://ntfy.pdiehm.dev/${machine.name}-$1"
        '';
      };
    })
  ];
}

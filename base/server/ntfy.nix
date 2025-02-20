{ config, machine, pkgs, ... }: {
  home-manager.users.pascal.home.packages = [ pkgs.scripts.ntfy ];
  sops.secrets."${machine.name}/ntfy".owner = "pascal";

  nixpkgs.overlays = [
    (self: super: {
      scripts.ntfy = self.writeShellApplication {
        name = "ntfy";
        runtimeInputs = [ self.curl ];

        text = ''
          TOKEN="$(cat "${config.sops.secrets."${machine.name}/ntfy".path}")"
          curl -s -H "Authorization: Bearer $TOKEN" -d "$2" "https://ntfy.pdiehm.dev/${machine.name}-$1"
        '';
      };
    })
  ];
}

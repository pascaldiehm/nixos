{ config, lib, machine, pkgs, ... }: {
  home-manager.users.pascal.home.packages = [ pkgs.scripts.ntfy ];

  programs.scripts.ntfy.text = ''
    if [ "$#" != "2" ]; then
      echo "Usage: ntfy <channel> <message>"
      exit 1
    fi

    TOKEN="$(cat ${config.sops.secrets."common/ntfy".path})"
    ${lib.getExe pkgs.curl} -s -H "Authorization: Bearer $TOKEN" -d "$2" "https://ntfy.pdiehm.dev/${machine.name}-$1"
  '';

  sops.secrets."common/ntfy" = {
    owner = "pascal";
    sopsFile = ../../resources/secrets/common/store.yaml;
  };
}

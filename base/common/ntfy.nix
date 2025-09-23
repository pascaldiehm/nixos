{ config, lib, machine, pkgs, ... }: {
  home-manager.users.pascal.home.packages = [ pkgs.scripts.ntfy ];

  programs.scripts.ntfy.text = ''
    TOKEN="$(cat ${config.sops.secrets."common/ntfy".path})"

    if [ "$#" = 1 ]; then
      ${lib.getExe pkgs.curl} --silent --show-error --header "Authorization: Bearer $TOKEN" --data "$1" https://ntfy.pdiehm.dev/default
    elif [ "$#" = 2 ]; then
      ${lib.getExe pkgs.curl} --silent --show-error --header "Authorization: Bearer $TOKEN" --data "$2" "https://ntfy.pdiehm.dev/${machine.name}-$1"
    else
      echo "Usage: ntfy [channel] <message>"
      exit 1
    fi
  '';

  sops.secrets."common/ntfy" = {
    owner = "pascal";
    sopsFile = ../../resources/secrets/common/store.yaml;
  };
}

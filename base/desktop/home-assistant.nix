{ config, lib, pkgs, ... }: {
  home-manager.users.pascal.home.packages = [ pkgs.scripts.ha ];
  sops.secrets.home-assistant-token.owner = "pascal";

  programs.scripts.ha.text = ''
    if [ "$#" != 3 ]; then
      echo "Usage: ha <domain> <action> <device>"
      exit 1
    fi

    TOKEN="$(cat ${config.sops.secrets.home-assistant-token.path})"
    ${lib.getExe pkgs.curl} -H "Authorization: Bearer $TOKEN" -d "{ \"entity_id\": \"$1.$3\" }" "http://homeassistant:8123/api/services/$1/$2"
  '';
}

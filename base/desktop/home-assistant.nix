{ config, lib, pkgs, ... }: {
  home-manager.users.pascal.home.packages = [ pkgs.scripts.ha ];
  sops.secrets.home-assistant-token.owner = "pascal";

  programs.scripts.ha = {
    deps = [ pkgs.curl ];

    text = lib.readFile ../../resources/scripts/ha.sh
      |> lib.templateString { token = config.sops.secrets.home-assistant-token.path; };
  };
}

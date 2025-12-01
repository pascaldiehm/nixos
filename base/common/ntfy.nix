{ config, lib, machine, pkgs, ... }: {
  home-manager.users.pascal.home.packages = [ pkgs.scripts.ntfy ];
  sops.common.ntfy.owner = "pascal";

  programs.scripts.ntfy = {
    deps = [ pkgs.curl ];

    text = lib.templateString {
      TOKEN = config.sops.common.ntfy.path;
      MACHINE = machine.name;
    } (lib.readFile ../../resources/scripts/ntfy.sh);
  };
}

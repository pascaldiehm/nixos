{ config, lib, machine, pkgs, ... }: {
  home-manager.users.pascal.home.packages = [ pkgs.scripts.ntfy ];
  sops.common.ntfy.owner = "pascal";

  programs.scripts.ntfy = {
    deps = [ pkgs.curl ];

    text = lib.templateString {
      token = config.sops.common.ntfy.path;
      machine = machine.name;
    } (lib.readFile ../../resources/scripts/ntfy.sh);
  };
}

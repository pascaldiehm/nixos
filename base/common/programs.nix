{ pkgs, ... }: {
  home-manager.users.pascal = {
    home.packages = [ pkgs.btrfs-progs pkgs.jq pkgs.unzip pkgs.zip ];
    programs.ssh.enable = true;
  };

  programs = {
    command-not-found.enable = false;
    nano.enable = false;
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings.log-driver = "local";
  };
}

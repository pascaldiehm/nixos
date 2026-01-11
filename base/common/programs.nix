{ config, lib, machine, pkgs, ... }: {
  sops.common.ntfy.mode = "0444";

  home-manager.users.pascal.home.packages = [
    pkgs.bat
    pkgs.btrfs-progs
    pkgs.doggo
    pkgs.duf
    pkgs.eza
    pkgs.fastfetch
    pkgs.fd
    pkgs.file
    pkgs.jq
    pkgs.lsof
    pkgs.mtr
    pkgs.ncdu
    pkgs.netcat
    pkgs.pciutils
    pkgs.pd.ntfy
    pkgs.pd.nx
    pkgs.ripgrep
    pkgs.tcpdump
    pkgs.unzip
    pkgs.usbutils
    pkgs.wireguard-tools
    pkgs.xh
    pkgs.zip
  ];

  programs = {
    nano.enable = false;

    scripts = {
      ntfy = {
        deps = [ pkgs.curl ];

        text = lib.readFile ../../resources/scripts/ntfy.sh
          |> lib.templateString {
            TOKEN = config.sops.common.ntfy.path;
            MACHINE = machine.name;
          };
      };

      nx = {
        deps = [ pkgs.sops ];
        text = lib.readFile ../../resources/scripts/nx.sh;
      };
    };

    vim = {
      enable = true;
      defaultEditor = true;
      package = pkgs.vim.override { vimrc = ../../resources/vim/vimrc.vim; };
    };
  };
}

{ pkgs, ... }: {
  environment.persistence."/perm".users.pascal.directories = [ "VMs" ];
  home-manager.users.pascal.home.packages = [ pkgs.qemu pkgs.quickemu ];
  virtualisation.spiceUSBRedirection.enable = true;
}

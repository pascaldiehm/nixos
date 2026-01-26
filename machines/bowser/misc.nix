{ config, pkgs, ... }: {
  sops.secrets."bowser/backup-key".owner = "pascal";
  systemd.tmpfiles.rules = [ "d /nix/var/nix/gcroots/ci 1777 root root -" ];

  environment = {
    persistence."/perm".users.pascal.directories = [ "shared" ];
    systemPackages = [ pkgs.nix-serve-ng ];
  };

  services = {
    backup.targets."/home/pascal/shared" = { };
    openssh.authorizedKeysFiles = [ config.sops.secrets."bowser/backup-key".path ];
  };
}

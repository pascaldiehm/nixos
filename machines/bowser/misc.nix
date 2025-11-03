{ config, pkgs, ... }: {
  sops.secrets."bowser/backup-key".owner = "pascal";

  environment = {
    persistence."/perm".users.pascal.directories = [ "shared" ];
    systemPackages = [ pkgs.nix-serve ];
  };

  services = {
    duplicity.include = [ "/home/pascal/shared" ];
    openssh.authorizedKeysFiles = [ config.sops.secrets."bowser/backup-key".path ];
  };
}

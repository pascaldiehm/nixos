{ config, pkgs, ... }: {
  sops.secrets."bowser/backup-key".owner = "pascal";

  environment = {
    systemPackages = [ pkgs.nix-serve ];

    persistence."/perm".users.pascal.directories = [
      "shared"

      {
        directory = "/nix/var/nix/gcroots/ci";
        mode = "1777";
      }
    ];
  };

  services = {
    duplicity.include = [ "/home/pascal/shared" ];
    openssh.authorizedKeysFiles = [ config.sops.secrets."bowser/backup-key".path ];
  };
}

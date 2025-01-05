{ config, pkgs, ... }: {
  users.users.pascal.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0QlzxdW4Pxbb7vcF6C88+0aySGjhFO//QRBB5rv4JY pascal" ];

  boot.swraid = {
    enable = true;

    mdadmConf = ''
      PROGRAM ${pkgs.curl}/bin/curl -s -H "Authorization: Bearer $(cat ${config.sops.secrets.ntfy.path})" -d 'A RAID drive has failed' 'https://ntfy.pdiehm.dev/bowser-raid'
      ARRAY /dev/md/0 metadata=1.2 name=bowser:0 UUID=d56224b5:9d97fe09:73ab00f5:631ed84c
    '';
  };
}

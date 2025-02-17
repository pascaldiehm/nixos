{ lib, pkgs, ... }: {
  boot.swraid = {
    enable = true;

    mdadmConf = ''
      ARRAY /dev/md/0 metadata=1.2 name=bowser:0 UUID=d56224b5:9d97fe09:73ab00f5:631ed84c
      PROGRAM ${pkgs.writeShellScript "ntfy-raid" "${lib.getExe pkgs.scripts.ntfy} raid \"$1: $2\${3:+ ($3)}\""}
    '';
  };

  fileSystems."/home/pascal/archive" = {
    device = "/dev/md/0";
    fsType = "ext4";
  };
}

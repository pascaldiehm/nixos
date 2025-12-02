{ lib, pkgs, ... }: {
  environment.etc = {
    hosts.mode = "0644";

    dynhosts.text = ''
      goomba 2a01:4f8:c0c:988b::1 91.99.52.233
    '';
  };

  networking.extraHosts = ''
    192.168.1.88 bowser
    192.168.1.89 homeassistant
    192.168.1.90 pascal-pc
    192.168.1.91 pascal-laptop
    192.168.1.99 pascal-phone
  '';

  systemd.services.dynhostmgr = {
    after = [ "network-online.target" ];
    description = "Dynamically update /etc/hosts with reachable addresses";
    requires = [ "network-online.target" ];
    serviceConfig.ExecStart = lib.getExe pkgs.dynhostmgr;
    wantedBy = [ "multi-user.target" ];
  };
}

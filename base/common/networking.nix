{ lib, pkgs, ... }: {
  environment.etc = {
    hosts.mode = "0644";

    dynhosts.text = ''
      goomba 2a01:4f8:c0c:988b::1 91.99.52.233
    '';
  };

  networking = {
    nftables.enable = true;
    useDHCP = false;

    extraHosts = ''
      192.168.1.88 bowser
      192.168.1.89 homeassistant
      192.168.1.90 pascal-pc
      192.168.1.91 pascal-laptop
      192.168.1.99 pascal-phone
    '';

    nameservers = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
      "2606:4700:4700::1111#one.one.one.one"
      "2606:4700:4700::1001#one.one.one.one"
    ];
  };

  services.resolved = {
    enable = true;
    dnsovertls = "opportunistic";
    domains = [ "~." ];
    extraConfig = "MulticastDNS=true";
  };

  systemd.services.dynhostmgr = {
    after = [ "network-online.target" ];
    description = "Dynamically update /etc/hosts with reachable addresses";
    requires = [ "network-online.target" ];
    serviceConfig.ExecStart = lib.getExe pkgs.dynhostmgr;
    wantedBy = [ "multi-user.target" ];
  };
}

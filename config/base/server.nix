{ config, ... }: {
  imports = [ ./common.nix ];
  home-manager.users.pascal.programs.ssh.matchBlocks."github.com".identityFile = config.sops.secrets.github-ssh-key.path;
  networking.firewall.enable = false;

  services.openssh = {
    enable = true;
    ports = [ 1970 ];

    settings = {
      AllowUsers = [ "pascal" ];
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  sops = {
    age.sshKeyPaths = [ ];
    defaultSopsFile = ../../resources/secrets/server/store.yml;
    secrets.github-ssh-key.owner = "pascal";

    gnupg = {
      home = "/etc/nixos/.gnupg";
      sshKeyPaths = [ ];
    };
  };
}

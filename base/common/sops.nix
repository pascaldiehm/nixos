{ machine, ... }: {
  sops = {
    age.sshKeyPaths = [ ];
    defaultSopsFile = ../../resources/secrets/${machine.type}/store.yaml;

    gnupg = {
      home = "/perm/etc/nixos/.gnupg";
      sshKeyPaths = [ ];
    };
  };
}

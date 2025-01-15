{ system, ... }:
{
  sops = {
    age.sshKeyPaths = [ ];
    defaultSopsFile = ../../resources/secrets/${system.type}/store.yaml;

    gnupg = {
      home = "/perm/etc/nixos/.gnupg";
      sshKeyPaths = [ ];
    };
  };
}

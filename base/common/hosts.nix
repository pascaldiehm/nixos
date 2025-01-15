{ config, ... }:
{
  environment.etc.hosts.mode = "0644";
  sops.secrets.hosts.sopsFile = ../../resources/secrets/common/store.yaml;

  system.activationScripts.addSecretHosts = {
    text = "cat '${config.sops.secrets.hosts.path}' >> /etc/hosts";

    deps = [
      "etc"
      "setupSecrets"
    ];
  };
}

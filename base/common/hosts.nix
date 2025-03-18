{ config, ... }: {
  environment.etc.hosts.mode = "0644";
  sops.secrets."common/hosts".sopsFile = ../../resources/secrets/common/store.yaml;

  system.activationScripts.addSecretHosts = {
    deps = [ "etc" "setupSecrets" ];
    text = "cat ${config.sops.secrets."common/hosts".path} >>/etc/hosts";
  };
}

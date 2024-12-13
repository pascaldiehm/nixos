{ config, helpers, ... }: {
  home-manager.users.pascal.home.activation.writeSSHConfig = helpers.mkHMActivation [ "writeBoundary" ] ''
    [ ! -d $HOME/.ssh ] && run mkdir -m 700 $HOME/.ssh
    run cat << EOF > $HOME/.ssh/config
    Host bowser
      HostName $(cat ${config.sops.secrets."ssh/bowser/host".path})
      IdentityFile ${config.sops.secrets."ssh/bowser/key".path}
      Port $(cat ${config.sops.secrets."ssh/bowser/port".path})
      User mario

    Host github.com
      IdentityFile ${config.sops.secrets."ssh/github/key".path}

    Host goomba
      HostName $(cat ${config.sops.secrets."ssh/goomba/host".path})
      IdentityFile ${config.sops.secrets."ssh/goomba/key".path}
      Port $(cat ${config.sops.secrets."ssh/goomba/port".path})
      User mario
    EOF

    run chmod 600 $HOME/.ssh/config
  '';

  sops.secrets = helpers.mkSSHSecrets [
    "ssh/bowser/host"
    "ssh/bowser/key"
    "ssh/bowser/port"
    "ssh/github/key"
    "ssh/goomba/host"
    "ssh/goomba/key"
    "ssh/goomba/port"
  ];
}

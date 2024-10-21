{ config, hmcfg, helpers, ... }: {
  # Setup SSH secrets
  sops.secrets = builtins.listToAttrs (builtins.map (key: { name = key; value = { owner = "pascal"; restartUnits = [ "home-manager-pascal.service" ]; }; }) [
    "ssh/github/key"
    "ssh/bowser/host" "ssh/bowser/key" "ssh/bowser/port" "ssh/bowser/user"
    "ssh/goomba/host" "ssh/goomba/key" "ssh/goomba/port" "ssh/goomba/user"
  ]);

  # Setup SSH
  home-manager.users.pascal.home.activation.writeSSHConfig = helpers.mkHomeManagerActivation [ "writeBoundary" ] ''
    cd $HOME
    [ -d .ssh ] || run mkdir -m 700 .ssh

    run cat << EOF > .ssh/config
    Host github.com
      IdentityFile ${config.sops.secrets."ssh/github/key".path}

    Host bowser
      HostName $(cat ${config.sops.secrets."ssh/bowser/host".path})
      IdentityFile ${config.sops.secrets."ssh/bowser/key".path}
      Port $(cat ${config.sops.secrets."ssh/bowser/port".path})
      User $(cat ${config.sops.secrets."ssh/bowser/user".path})

    Host goomba
      HostName $(cat ${config.sops.secrets."ssh/goomba/host".path})
      IdentityFile ${config.sops.secrets."ssh/goomba/key".path}
      Port $(cat ${config.sops.secrets."ssh/goomba/port".path})
      User $(cat ${config.sops.secrets."ssh/goomba/user".path})
    EOF

    run chmod 600 .ssh/config
  '';
}

{
  networking.extraHosts = ''
    192.168.1.88 bowser.lan bowser
    192.168.1.89 homeassistant.lan homeassistant
    192.168.1.90 pascal-pc.lan pascal-pc
    192.168.1.91 pascal-laptop.lan pascal-laptop
    192.168.1.99 pascal-phone.lan pascal-phone

    10.42.42.1 goomba.wg goomba
    10.42.42.2 bowser.wg bowser
    10.42.42.90 pascal-pc.wg pascal-pc
    10.42.42.91 pascal-laptop.wg pascal-laptop

    91.99.52.233 goomba.wan goomba
  '';

  programs.ssh.knownHosts = {
    "[bowser]:1970".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpY9HXNKIfGvwQTQ1rLidyoheecUiYaBFu6R2LSxiiG";
    "[goomba]:1970".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFyFZp8gdn4egNOAtBA/U+eCxdHEyPU/fnLvwMqOtoFR";
    "[pascal-laptop]:1970".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdTOVCs6qsCHb3TLXq0rGc7WUgUHgmjGxRxd4rHU+q1";
    "[pascal-pc]:1970".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKSmgsw6WYhO5L9HvG4nhsW+WpTAYsR5UwwOQcmte4QU";
    "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
  };
}

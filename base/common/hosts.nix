{
  networking.hosts = {
    "192.168.1.88" = [ "bowser" ];
    "192.168.1.89" = [ "homeassistant" ];
    "192.168.1.90" = [ "pascal-pc" ];
    "192.168.1.91" = [ "pascal-laptop" ];
    "192.168.1.99" = [ "pascal-phone" ];
    "91.99.52.233" = [ "goomba" ];
  };

  programs.ssh.knownHosts = {
    "[bowser]:1970".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpY9HXNKIfGvwQTQ1rLidyoheecUiYaBFu6R2LSxiiG";
    "[goomba]:1970".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFyFZp8gdn4egNOAtBA/U+eCxdHEyPU/fnLvwMqOtoFR";
    "[pascal-laptop]:1970".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdTOVCs6qsCHb3TLXq0rGc7WUgUHgmjGxRxd4rHU+q1";
    "[pascal-pc]:1970".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKSmgsw6WYhO5L9HvG4nhsW+WpTAYsR5UwwOQcmte4QU";
    "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
  };
}

{ pkgs, ... }: {
  # SDDM
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Plasma
  environment.plasma6.excludePackages = [ pkgs.kdePackages.elisa pkgs.kdePackages.krdp ];
  services.desktopManager.plasma6.enable = true;

  # Network
  networking = {
    firewall.allowedTCPPorts = [ 1234 ];
    networkmanager.enable = true;
  };

  # Audio
  services.pipewire = {
    enable = true;
    pulse.enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };
  };
}

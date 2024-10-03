{ nixpkgs, ... }: {
  # System version
  system.stateVersion = "24.05";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable nix command and flakes
  nix = { settings = { experimental-features = [ "nix-command" "flakes" ]; }; }; # Slightly convoluted syntax; thanks for that, Nix (see nixos/nix#7897)

  # Optimise store
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Disable channels
  nix.settings.nix-path = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];

  nix = {
    channel.enable = false;
    registry.nixpkgs.flake = nixpkgs;
  };
}

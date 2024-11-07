{ nixpkgs, ... }: {
  environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
  system.stateVersion = "24.11";

  nix = {
    channel.enable = false;
    registry.nixpkgs.flake = nixpkgs;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      nix-path = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
    };
  };
}

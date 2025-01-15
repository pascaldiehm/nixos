{ inputs, ... }:
{
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";

  nix = {
    channel.enable = false;
    registry.nixpkgs.flake = inputs.nixpkgs;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      auto-optimise-store = true;
      nix-path = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
      use-xdg-base-directories = true;

      experimental-features = [
        "flakes"
        "nix-command"
      ];
    };
  };
}

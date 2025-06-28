{
  nixpkgs.overlays = [ (import ../../overlay) ];

  nix = {
    channel.enable = false;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = [ "flakes" "nix-command" "pipe-operators" ];
      use-xdg-base-directories = true;
    };
  };
}

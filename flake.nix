{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = github:nix-community/plasma-manager;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { nixpkgs, home-manager, plasma-manager, ... }: {
    nixosConfigurations = let
      mkSystem = module: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Pass nixpkgs to configuration files
          { _module.args = { inherit nixpkgs; }; }

          # System configuration
          /etc/nixos/hardware-configuration.nix
          ./modules/common
          module

          # User configuration
          home-manager.nixosModules.home-manager
          { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
          { home-manager.users.pascal = import ./modules/home; }
        ];
      };
    in {
      nixos = mkSystem ./machines/nixos.nix;
    };

    apps.x86_64-linux.install = {
      type = "app";
      program = ./install.sh;
    };
  };
}

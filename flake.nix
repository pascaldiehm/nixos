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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, plasma-manager, sops-nix, ... }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = let
      mkSystem = module: nixpkgs.lib.nixosSystem {
        modules = [
          # Pass nixpkgs to configuration files
          { _module.args = { inherit nixpkgs; }; }

          # Modules
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }

          # Common configuration
          ./modules/system
          ./modules/extra
          { home-manager.users.pascal = import ./modules/user; }

          # Machine-specific configuration
          /etc/nixos/hardware.nix
          module
        ];
      };
    in {
      nixos = mkSystem ./machines/nixos.nix;
      pascal-pc = mkSystem ./machines/pascal-pc.nix;
    };

    packages.x86_64-linux.install = pkgs.stdenv.mkDerivation {
      name = "install.sh";
      src = ./.;
      nativeBuildInputs = [ pkgs.makeWrapper ];

      installPhase = ''
        install -Dt $out/bin bin/install.sh
        wrapProgram $out/bin/install.sh --prefix PATH : ${lib.makeBinPath [ pkgs.git pkgs.gnupg ]}
      '';
    };
  };
}

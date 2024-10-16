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
        modules = [
          # Pass nixpkgs to configuration files
          { _module.args = { inherit nixpkgs; }; }

          # System configuration
          /etc/nixos/hardware.nix
          ./modules/common
          ./modules/extra
          module

          # User configuration
          home-manager.nixosModules.home-manager
          { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
          { home-manager.users.pascal = import ./modules/home; }
        ];
      };
    in {
      nixos = mkSystem ./machines/nixos.nix;
      pascal-pc = mkSystem ./machines/pascal-pc.nix;
    };

    packages.x86_64-linux.install = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in pkgs.stdenv.mkDerivation {
      name = "install.sh";
      src = ./.;
      nativeBuildInputs = [ pkgs.makeWrapper ];
      buildInputs = [ pkgs.git ];

      installPhase = ''
        install -Dt $out/bin bin/install.sh
        wrapProgram $out/bin/install.sh --prefix PATH : ${pkgs.git}/bin
      '';
    };
  };
}

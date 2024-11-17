{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    impermanence.url = github:nix-community/impermanence;

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
      url = github:Mic92/sops-nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, impermanence, plasma-manager, sops-nix, ... }: {
    nixosConfigurations =
      let
        mkSystem = module: nixpkgs.lib.nixosSystem {
          modules = [
            # Libraries
            home-manager.nixosModules.home-manager
            impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops
            { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }

            # Modules
            { _module.args = { inherit nixpkgs; }; }
            ./modules

            # Machine
            /etc/nixos/hardware.nix
            module
          ];
        };
      in
      {
        nixos = mkSystem ./machines/nixos.nix;
        pascal-laptop = mkSystem ./machines/pascal-laptop.nix;
        pascal-pc = mkSystem ./machines/pascal-pc.nix;
      };

    packages.x86_64-linux =
      let
        mkScript = name: deps: pkgs.stdenv.mkDerivation {
          inherit name;
          src = ./bin;
          nativeBuildInputs = [ pkgs.makeWrapper ];

          installPhase = ''
            install -Dt $out/bin ${name}
            wrapProgram $out/bin/${name} --prefix PATH : ${pkgs.lib.makeBinPath deps}
          '';
        };

        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in
      {
        install = mkScript "install.sh" [ pkgs.git pkgs.gnupg pkgs.pinentry-tty ];
        update = mkScript "update.sh" [ pkgs.git pkgs.jq pkgs.unzip ];
      };
  };
}

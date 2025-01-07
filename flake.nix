{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
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
        mkSystems = set: builtins.mapAttrs (name: value: mkSystem name set.${name}) set;

        mkSystem = name: type: nixpkgs.lib.nixosSystem {
          modules = [
            # Libraries
            config/helpers.nix
            home-manager.nixosModules.home-manager
            impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops

            # Modules
            /etc/nixos/hardware.nix
            config/base/${type}.nix
            config/machines/${name}.nix

            # Extra
            {
              _module.args = { inherit nixpkgs; };
              home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
              networking.hostName = name;
            }
          ];
        };
      in
      mkSystems {
        bowser = "server";
        goomba = "server";
        pascal-laptop = "desktop";
        pascal-pc = "desktop";
      };

    packages.x86_64-linux =
      let
        mkScripts = set: builtins.mapAttrs (name: value: mkScript name set.${name}) set;
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        mkScript = name: deps: pkgs.stdenv.mkDerivation {
          name = "${name}.sh";
          nativeBuildInputs = [ pkgs.makeWrapper ];
          src = ./bin;

          installPhase = ''
            install -Dt $out/bin ${name}.sh
            wrapProgram $out/bin/${name}.sh --prefix PATH : ${pkgs.lib.makeBinPath deps}
          '';
        };
      in
      mkScripts {
        install = [ pkgs.btrfs-progs pkgs.cryptsetup pkgs.git pkgs.gnupg pkgs.parted pkgs.pinentry-tty ];
        update = [ pkgs.git ];
        upgrade = [ pkgs.curl pkgs.jq pkgs.unzip ];
      };
  };
}

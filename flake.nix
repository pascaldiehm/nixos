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
        mkSystems = set: builtins.listToAttrs (builtins.map (name: { inherit name; value = mkSystem name set.${name}; }) (builtins.attrNames set));

        mkSystem = name: type: nixpkgs.lib.nixosSystem {
          modules = [
            # Libraries
            modules/lib.nix
            home-manager.nixosModules.home-manager
            impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops

            # Modules
            /etc/nixos/hardware.nix
            modules/${type}.nix
            machines/${type}/${name}.nix

            # Extra
            {
              _module.args = { inherit nixpkgs; };
              home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
              networking.hostName = name;
            }
          ];
        };
      in
      {
        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ({ pkgs, modulesPath, ... }: {
              imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
              environment.systemPackages = [ (pkgs.writeShellScriptBin "install" "nix --extra-experimental-features 'nix-command flakes' run github:pascaldiehm/nixos#install") ];
            })
          ];
        };
      } // mkSystems {
        pascal-laptop = "desktop";
        pascal-pc = "desktop";
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

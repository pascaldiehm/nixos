{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      apps.x86_64-linux =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          mkScript =
            name: runtimeInputs:
            pkgs.writeShellApplication {
              inherit name runtimeInputs;
              runtimeEnv.MACHINES_FILE = "${./machines.json}";
              text = builtins.readFile bin/${name}.sh;
            };

          mkScripts =
            set:
            builtins.mapAttrs (name: value: {
              program = "${mkScript name value}/bin/${name}";
              type = "app";
            }) set;
        in
        mkScripts {
          update = [ pkgs.git ];

          install = [
            pkgs.btrfs-progs
            pkgs.cryptsetup
            pkgs.git
            pkgs.jq
            pkgs.gnupg
            pkgs.parted
            pkgs.pinentry-tty
          ];

          upgrade = [
            pkgs.curl
            pkgs.jq
            pkgs.unzip
            pkgs.vim
          ];
        };

      nixosConfigurations =
        let
          mkSystems = set: builtins.mapAttrs (name: value: mkSystem name set.${name}) set;

          mkSystem =
            name: type:
            nixpkgs.lib.nixosSystem {
              modules = [
                # Libraries
                config/lib.nix
                inputs.home-manager.nixosModules.home-manager
                inputs.impermanence.nixosModules.impermanence
                inputs.sops-nix.nixosModules.sops

                # Modules
                /etc/nixos/hardware.nix
                config/base/common.nix
                config/base/${type}.nix
                config/machines/${name}.nix
              ];

              specialArgs = {
                inherit inputs;
                lib = nixpkgs.lib.extend (self: super: inputs.home-manager.lib);
                system = { inherit name type; };
              };
            };
        in
        mkSystems (nixpkgs.lib.importJSON ./machines.json)
        // {
          installer = nixpkgs.lib.nixosSystem { modules = [ config/installer.nix ]; };
        };
    };
}

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
    {
      home-manager,
      impermanence,
      nixpkgs,
      plasma-manager,
      sops-nix,
      ...
    }:
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
                config/globals.nix
                home-manager.nixosModules.home-manager
                impermanence.nixosModules.impermanence
                sops-nix.nixosModules.sops

                # Modules
                /etc/nixos/hardware.nix
                config/base/common.nix
                config/base/${type}.nix
                config/machines/${name}.nix

                # Extra
                {
                  home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
                  networking.hostName = name;
                }
              ];

              specialArgs = {
                _glb = { inherit nixpkgs type; };
                lib = nixpkgs.lib.extend (self: super: home-manager.lib);
              };
            };
        in
        mkSystems (nixpkgs.lib.importJSON ./machines.json);
    };
}

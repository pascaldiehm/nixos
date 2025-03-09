{
  inputs = {
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };

    lanzaboote = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/lanzaboote";
    };

    nixvim = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixvim";
    };

    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };

    stylix = {
      url = "github:danth/stylix";

      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = inputs: {
    apps.x86_64-linux =
      let
        lib = inputs.nixpkgs.lib;
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

        mkScripts = lib.mapAttrs (
          name: runtimeInputs: {
            type = "app";

            program =
              pkgs.writeShellApplication {
                inherit name runtimeInputs;
                text = lib.readFile apps/${name}.sh;
              }
              |> pkgs.lib.getExe;
          }
        );
      in
      mkScripts {
        upgrade = [ pkgs.curl pkgs.jq pkgs.unzip ];

        install = [
          pkgs.btrfs-progs
          pkgs.cryptsetup
          pkgs.git
          pkgs.gnupg
          pkgs.jq
          pkgs.parted
          pkgs.pinentry-tty
          pkgs.sbctl
          (pkgs.writeShellScriptBin "machines" "cat ${./machines.json}")
        ];
      };

    nixosConfigurations =
      let
        lib = inputs.nixpkgs.lib;

        mkSystems = lib.mapAttrs (
          name: type:
          lib.nixosSystem {
            modules = [
              inputs.home-manager.nixosModules.home-manager
              inputs.impermanence.nixosModules.impermanence
              inputs.sops-nix.nixosModules.sops

              /etc/nixos/hardware.nix
              ./modules
              ./pkgs
              base/common
              base/${type}
              machines/${name}
            ];

            specialArgs = {
              inherit inputs;
              lib = lib.extend (import ./lib.nix) |> (lib: lib.extend (self: super: inputs.home-manager.lib));
              machine = { inherit name type; };
            };
          }
        );
      in
      lib.importJSON ./machines.json
      |> mkSystems
      |> lib.mergeAttrs { installer = lib.nixosSystem { modules = [ extra/installer.nix ]; }; };
  };
}

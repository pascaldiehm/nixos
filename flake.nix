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
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/stylix";
    };
  };

  outputs =
    inputs:
    let
      lib = inputs.nixpkgs.lib;
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

      mkScript =
        name: runtimeInputs:
        pkgs.writeShellApplication {
          inherit name runtimeInputs;
          text = lib.readFile apps/${name}.sh;
        };

      mkSystem =
        name: info:
        lib.nixosSystem {
          modules = [
            ./modules
            base/common
            base/${info.type}
            machines/${name}
          ]
          ++ lib.optional (lib.pathExists /etc/nixos/hardware.nix) /etc/nixos/hardware.nix;

          specialArgs = {
            inherit inputs;
            lib = (lib.extend (import ./lib.nix)).extend (self: super: inputs.home-manager.lib);

            machine = info // {
              inherit name;
            };
          };
        };
    in
    rec {
      nixosConfigurations =
        lib.importJSON ./machines.json
        |> lib.mapAttrs mkSystem
        |> lib.mergeAttrs { installer = lib.nixosSystem { modules = [ extra/installer.nix ]; }; };

      packages.x86_64-linux = lib.mapAttrs mkScript {
        nvim = [ nixosConfigurations.pascal-pc.config.home-manager.users.pascal.programs.nixvim.build.package ];
        upgrade = [ pkgs.curl pkgs.jq pkgs.nodePackages.nodejs pkgs.unzip ];

        install = [
          pkgs.btrfs-progs
          pkgs.cryptsetup
          pkgs.curl
          pkgs.dosfstools
          pkgs.git
          pkgs.gnupg
          pkgs.jq
          pkgs.parted
          pkgs.pinentry-tty
          pkgs.sbctl
          (pkgs.writeShellScriptBin "machines" "cat ${./machines.json}")
        ];
      };
    };
}

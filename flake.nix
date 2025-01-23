{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";

      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";

      inputs = {
        base16-vim.url = "github:tinted-theming/tinted-vim?rev=577fe8125d74ff456cf942c733a85d769afe58b7"; # FIXME templates/config.yaml is broken on the latest commit
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = inputs: {
    apps.x86_64-linux =
      let
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

        mkScripts = builtins.mapAttrs (
          name: runtimeInputs: {
            type = "app";

            program =
              pkgs.writeShellApplication {
                inherit name runtimeInputs;
                text = builtins.readFile apps/${name}.sh;
              }
              |> (app: "${app}/bin/${name}");
          }
        );
      in
      mkScripts {
        update = [ pkgs.git ];
        upgrade = [ pkgs.curl pkgs.jq pkgs.unzip pkgs.vim ];

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

        mkSystems = builtins.mapAttrs (
          name: type:
          lib.nixosSystem {
            modules = [
              # Libraries
              ./lib.nix
              inputs.home-manager.nixosModules.home-manager
              inputs.impermanence.nixosModules.impermanence
              inputs.sops-nix.nixosModules.sops

              # Modules
              /etc/nixos/hardware.nix
              ./patches
              base/common
              base/${type}
              machines/${name}
            ];

            specialArgs = {
              inherit inputs;
              lib = lib.extend (self: super: inputs.home-manager.lib);
              system = { inherit name type; };
            };
          }
        );
      in
      lib.importJSON ./machines.json
      |> mkSystems
      |> lib.mergeAttrs { installer = lib.nixosSystem { modules = [ extra/installer.nix ]; }; };
  };
}

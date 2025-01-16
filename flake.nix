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

          install = [
            pkgs.btrfs-progs
            pkgs.cryptsetup
            pkgs.git
            pkgs.jq
            pkgs.gnupg
            pkgs.parted
            pkgs.pinentry-tty
            (pkgs.writeShellScriptBin "machines" "cat ${./machines.json}")
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
          mkSystems = builtins.mapAttrs (
            name: type:
            nixpkgs.lib.nixosSystem {
              modules = [
                # Libraries
                ./lib.nix
                inputs.home-manager.nixosModules.home-manager
                inputs.impermanence.nixosModules.impermanence
                inputs.sops-nix.nixosModules.sops

                # Modules
                /etc/nixos/hardware.nix
                base/common
                base/${type}
                machines/${name}
              ];

              specialArgs = {
                inherit inputs;
                lib = nixpkgs.lib.extend (self: super: inputs.home-manager.lib);
                system = { inherit name type; };
              };
            }
          );
        in
        nixpkgs.lib.importJSON ./machines.json
        |> mkSystems
        |> (systems: systems // { installer = nixpkgs.lib.nixosSystem { modules = [ extra/installer.nix ]; }; });
    };
}

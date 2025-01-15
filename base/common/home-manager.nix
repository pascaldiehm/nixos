{
  config,
  inputs,
  lib,
  ...
}:
{
  home-manager = {
    backupFileExtension = "hm-bak";
    sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
    useGlobalPkgs = true;
    useUserPackages = true;

    users.pascal = {
      programs.home-manager.enable = true;

      home = {
        inherit (config.system) stateVersion;
        homeDirectory = "/home/pascal";
        username = "pascal";

        activation.deleteBackups = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run find /home/pascal -name "*.hm-bak" -exec rm -rf "{}" ";"
        '';
      };
    };
  };
}

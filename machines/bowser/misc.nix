{ pkgs, ... }: {
  environment = {
    persistence."/perm".users.pascal.directories = [ "shared" ];
    systemPackages = [ pkgs.nix-serve ];
  };
}

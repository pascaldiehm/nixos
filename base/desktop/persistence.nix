{
  environment.persistence."/perm".users.pascal.directories = [
    ".config/nixos"
    ".local/state/wireplumber"
    "Repos"

    {
      directory = ".local/share/gnupg";
      mode = "0700";
    }
  ];
}

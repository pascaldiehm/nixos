{
  environment.persistence."/perm".users.pascal.directories = [ ".config/retroarch" ".local/share/PrismLauncher" ];

  features = {
    amdgpu.enable = true;
    bluetooth.enable = true;
  };
}

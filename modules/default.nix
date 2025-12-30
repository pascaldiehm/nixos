{
  imports = [ ./backup.nix ./features.nix ./scripts.nix ./sops.nix ];
  home-manager.users.pascal.imports = [ ./godot.nix ];
}

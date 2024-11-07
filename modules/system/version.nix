{ hmcfg, ... }:
let
  head = builtins.readFile "${hmcfg.home.homeDirectory}/.config/nixos/.git/HEAD";
  ref = builtins.match "ref: (.+)\n" head;
  commit = if ref == null then head else builtins.readFile "${hmcfg.home.homeDirectory}/.config/nixos/.git/${builtins.elemAt ref 0}";
in
{
  environment.etc."nixos/commit".text = commit;
}

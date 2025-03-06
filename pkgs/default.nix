{
  nixpkgs.overlays = [
    (pkgs: prev: {
      # HACK(github:NixOS/nixfmt#206): Remove
      nixfmt-rfc-style = prev.nixfmt-rfc-style.overrideAttrs (prev: {
        patches = (prev.patches or [ ]) ++ [ nixfmt-rfc-style/compact-lists.patch nixfmt-rfc-style/compact-params.patch ];
      });

      vimPlugins = prev.vimPlugins // {
        conform-nvim = prev.vimPlugins.conform-nvim.overrideAttrs (prev: {
          postPatch = ''
            ${prev.postPatch or ""}
            rm doc/recipes.md
          '';
        });

        oil-nvim = prev.vimPlugins.oil-nvim.overrideAttrs (prev: {
          postPatch = ''
            ${prev.postPatch or ""}
            rm doc/recipes.md
          '';
        });
      };

      # HACK(github:Alexays/Waybar#3956): Remove
      waybar = prev.waybar.overrideAttrs (prev: {
        patches = (prev.patches or [ ]) ++ [ waybar/restore-ipv4.patch ];
      });
    })
  ];
}

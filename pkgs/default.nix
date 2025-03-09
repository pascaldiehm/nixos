{
  nixpkgs.overlays = [
    (pkgs: prev: {
      # HACK(github.com/NixOS/nixfmt/issues/206): Remove patch
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

      # HACK(github.com/Alexays/Waybar/issues/3956): Remove patch
      waybar = prev.waybar.overrideAttrs (prev: {
        patches = (prev.patches or [ ]) ++ [ waybar/restore-ipv4.patch ];
      });
    })
  ];
}

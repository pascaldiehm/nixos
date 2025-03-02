{
  nixpkgs.overlays = [
    (self: super: {
      # HACK(github:NixOS/nixfmt#206)
      nixfmt-rfc-style = super.nixfmt-rfc-style.overrideAttrs (prev: {
        patches = (prev.patches or [ ]) ++ [ nixfmt-rfc-style/compact-lists.patch nixfmt-rfc-style/compact-params.patch ];
      });

      vimPlugins = super.vimPlugins // {
        conform-nvim = super.vimPlugins.conform-nvim.overrideAttrs (prev: {
          postPatch = (prev.postPatch or "") + "\nrm doc/recipes.md";
        });

        oil-nvim = super.vimPlugins.oil-nvim.overrideAttrs (prev: {
          postPatch = (prev.postPatch or "") + "\nrm doc/recipes.md";
        });
      };

      # HACK(github:Alexays/Waybar#3956)
      waybar = super.waybar.overrideAttrs (prev: {
        patches = (prev.patches or [ ]) ++ [ waybar/restore-ipv4.patch ];
      });
    })
  ];
}

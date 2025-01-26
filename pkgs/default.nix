{
  nixpkgs.overlays = [
    (self: super: {
      nixfmt-rfc-style = super.nixfmt-rfc-style.overrideAttrs (prev: {
        patches = (prev.patches or [ ]) ++ [ nixfmt-rfc-style/compact-lists.patch nixfmt-rfc-style/compact-params.patch ];
      });

      vimPlugins = super.vimPlugins // {
        oil-nvim = super.vimPlugins.oil-nvim.overrideAttrs (prev: {
          postPatch = (prev.postPatch or "") + "rm -f doc/recipes.md";
        });
      };
    })
  ];
}

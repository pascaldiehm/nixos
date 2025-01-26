{
  nixpkgs.overlays = [
    (self: super: {
      nixfmt-rfc-style = super.nixfmt-rfc-style.overrideAttrs {
        patches = (super.patches or [ ]) ++ [ nixfmt-rfc-style/compact-lists.patch nixfmt-rfc-style/compact-params.patch ];
      };

      vimPlugins = super.vimPlugins // {
        oil-nvim = super.vimPlugins.oil-nvim.overrideAttrs (attrs: {
          postPatch = (attrs.postPatch or "") + "rm -f doc/recipes.md";
        });
      };
    })
  ];
}

{
  nixpkgs.overlays = [
    (self: super: {
      nixfmt-rfc-style = super.nixfmt-rfc-style.overrideAttrs {
        patches = (super.patches or [ ]) ++ [ nixfmt-rfc-style/compact-lists.patch nixfmt-rfc-style/compact-params.patch ];
      };
    })
  ];
}

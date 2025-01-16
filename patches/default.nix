{
  nixpkgs.overlays = [
    (self: super: {
      nixfmt-rfc-style = super.nixfmt-rfc-style.overrideAttrs {
        patches = [ nixfmt/compact-lists.patch nixfmt/compact-params.patch ];
      };
    })
  ];
}

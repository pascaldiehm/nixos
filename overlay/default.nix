pkgs: prev: {
  nix = prev.nixVersions.latest; # TODO: Remove once nix 3.32 is released

  nixfmt = prev.nixfmt.overrideAttrs (prev: {
    patches = (prev.patches or [ ]) ++ [ nixfmt/compact-lists.patch nixfmt/compact-params.patch ];
  });

  prettier = pkgs.importNpmLock.buildNodeModules rec {
    nodejs = pkgs.nodePackages.nodejs;
    npmRoot = ./prettier;

    derivationArgs = {
      meta.mainProgram = "prettier";
      nativeBuildInputs = [ pkgs.makeWrapper ];

      postInstall = ''
        makeWrapper "${pkgs.lib.getExe nodejs}" "$out/bin/prettier" \
          --add-flags "$out/node_modules/prettier/bin/prettier.cjs" \
          --add-flags "--plugin $out/node_modules/@prettier/plugin-php/standalone.js" \
          --add-flags "--plugin $out/node_modules/prettier-plugin-css-order/src/main.mjs" \
          --add-flags "--plugin $out/node_modules/prettier-plugin-organize-imports/index.js"
      '';
    };
  };

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

    # TODO: Remove once fixed upstream
    onedark-nvim = prev.vimPlugins.onedark-nvim.overrideAttrs (prev: {
      patches = (prev.patches or [ ]) ++ [ ./onedark.patch ];
    });
  };
}

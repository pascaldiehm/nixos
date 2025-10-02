pkgs: prev: {
  # FIXME: Remove this once released
  nix = prev.nix.overrideAttrs (prev: {
    patches = (prev.patches or [ ]) ++ [ nix/substituter-fallback.patch ];
  });

  # FIXME: Remove patch once single line lists are implemented
  nixfmt = prev.nixfmt.overrideAttrs (prev: {
    patches = (prev.patches or [ ]) ++ [ nixfmt/compact-lists.patch nixfmt/compact-params.patch ];
  });

  prettier = pkgs.importNpmLock.buildNodeModules rec {
    npmRoot = ./prettier;
    nodejs = pkgs.nodePackages.nodejs;

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
  };
}

pkgs: prev: {
  nix = prev.nixVersions.latest; # TODO: Remove once nix 3.32 is released
  nixfmt = prev.nixfmt.overrideAttrs (prev: { patches = (prev.patches or [ ]) ++ [ patches/nixfmt.patch ]; });

  dynhostmgr = pkgs.rustPlatform.buildRustPackage {
    name = "dynhostmgr";
    src = ./dynhostmgr;
    cargoLock.lockFile = dynhostmgr/Cargo.lock;
    meta.mainProgram = "dynhostmgr";
  };

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
          --add-flags "--plugin $out/node_modules/@prettier/plugin-xml/src/plugin.js" \
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

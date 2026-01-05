pkgs: prev: {
  nix = prev.nixVersions.latest; # HACK: nix >=2.32
  nixfmt = prev.nixfmt.overrideAttrs (prev: { patches = (prev.patches or [ ]) ++ [ patches/nixfmt.patch ]; });

  dynhostmgr = pkgs.rustPlatform.buildRustPackage {
    name = "dynhostmgr";
    src = ./dynhostmgr;
    cargoLock.lockFile = dynhostmgr/Cargo.lock;
    meta.mainProgram = "dynhostmgr";
  };

  # HACK: https://nixpkgs-tracker.ocfox.me/?pr=475899
  normalize = prev.normalize.overrideAttrs (prev: {
    postPatch = ''
      ${prev.postPatch or ""}

      sed -e '1i #include <string.h>' -i nid3lib/frame_desc.c
      substituteInPlace nid3lib/frame_desc.c --replace-fail "int strcmp();" ""

      sed -e '1i #include <unistd.h>' -i nid3lib/write.c
      substituteInPlace nid3lib/write.c --replace-fail "int ftruncate();" ""
    '';
  });

  prettier = pkgs.importNpmLock.buildNodeModules rec {
    nodejs = pkgs.nodePackages.nodejs;
    npmRoot = ./prettier;

    derivationArgs = {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      meta.mainProgram = "prettier";

      postInstall = ''
        makeWrapper ${pkgs.lib.getExe nodejs} "$out/bin/prettier" \
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

  waybar-ups = pkgs.rustPlatform.buildRustPackage {
    name = "waybar-ups";
    src = ./waybar-ups;
    cargoLock.lockFile = waybar-ups/Cargo.lock;
    meta.mainProgram = "waybar-ups";
  };
}

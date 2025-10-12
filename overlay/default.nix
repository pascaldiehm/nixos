pkgs: prev: {
  # FIXME: Remove this once CMake problems are fixed
  libretro.thepowdertoy = prev.libretro.thepowdertoy.overrideAttrs (prev: {
    postPatch = ''
      ${prev.postPatch or ""}
      sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" externals/zlib/CMakeLists.txt
    '';
  });

  libopenglrecorder = prev.libopenglrecorder.overrideAttrs (prev: {
    postPatch = ''
      ${prev.postPatch or ""}
      sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" CMakeLists.txt
    '';
  });

  superTuxKart = prev.superTuxKart.overrideAttrs (prev: {
    postPatch = ''
      ${prev.postPatch or ""}
      sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" CMakeLists.txt
      sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" lib/enet/CMakeLists.txt
      sed -i "s/CMAKE_MINIMUM_REQUIRED\(.*\)/CMAKE_MINIMUM_REQUIRED(VERSION 3.5)/" lib/libsquish/CMakeLists.txt
      sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" lib/graphics_utils/CMakeLists.txt
      sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" lib/tinygettext/CMakeLists.txt
      grep -v CMP0043 CMakeLists.txt | tee CMakeLists.txt
    '';
  });

  # FIXME: Remove this once fixed
  cmake-language-server = prev.cmake-language-server.overrideAttrs (prev: {
    disabledTests = (prev.disabledTests or [ ]) ++ [
      "test_parse_variable"
      "test_parse_modules"
      "test_completions_triggercharacter"
    ];
  });

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
  };
}

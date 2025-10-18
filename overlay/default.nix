pkgs: prev: {
  # FIXME: Remove this once CMake problems are fixed
  libretro = prev.libretro // {
    thepowdertoy = prev.libretro.thepowdertoy.overrideAttrs (prev: {
      postPatch = ''
        ${prev.postPatch or ""}
        sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" externals/zlib/CMakeLists.txt
      '';
    });

    tic80 = prev.libretro.tic80.overrideAttrs (prev: {
      postPatch = ''
        ${prev.postPatch or ""}
        sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" core/CMakeLists.txt
        sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" core/vendor/zip/CMakeLists.txt
        sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" core/vendor/libuv/CMakeLists.txt
      '';
    });

    citra = prev.libretro.citra.overrideAttrs (prev: {
      postPatch = ''
        ${prev.postPatch or ""}
        sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" externals/xbyak/CMakeLists.txt
        sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" externals/dynarmic/externals/robin-map/CMakeLists.txt
        sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" externals/soundtouch/CMakeLists.txt
        sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" externals/sirit/externals/SPIRV-Headers/CMakeLists.txt
        sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" externals/zstd/build/cmake/CMakeLists.txt
        sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" externals/libressl/CMakeLists.txt
      '';
    });

    dolphin = prev.libretro.dolphin.overrideAttrs (prev: {
      postPatch = ''
        ${prev.postPatch or ""}
        sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" Externals/fmt/CMakeLists.txt
        sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" Externals/pugixml/CMakeLists.txt
        sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" Externals/enet/CMakeLists.txt
        sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" Externals/cubeb/CMakeLists.txt
        sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" Externals/mbedtls/CMakeLists.txt
        sed -i "s/cmake_minimum_required\(.*\)/cmake_minimum_required(VERSION 3.5)/" Externals/gtest/CMakeLists.txt
      '';
    });
  };

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

{ pkgs, ... }: {
  home-manager.users.pascal = {
    home = {
      file = {
        ".clang-format".source = ../../resources/clang/format.yaml;
        ".clang-tidy".source = ../../resources/clang/tidy.yaml;
        ".config/clangd/config.yaml".source = ../../resources/clang/clangd.yaml;
      };

      packages = [
        pkgs.cargo
        pkgs.clippy
        pkgs.cmake
        pkgs.gcc
        pkgs.gdb
        pkgs.gnumake
        pkgs.ninja
        pkgs.nodePackages.nodejs
        pkgs.php
        pkgs.python3
        pkgs.rustc
        pkgs.sqlite
      ];

      sessionVariables = {
        CMAKE_EXPORT_COMPILE_COMMANDS = "1";
        CMAKE_GENERATOR = "Ninja";
      };
    };

    programs = {
      java.enable = true;

      texlive = {
        enable = true;

        extraPackages = tpkgs: {
          inherit (tpkgs)
            collection-basic
            collection-bibtexextra
            collection-fontsrecommended
            collection-langgerman
            collection-latexextra
            ;
        };
      };
    };
  };
}

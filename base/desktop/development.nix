{ pkgs, ... }: {
  home-manager.users.pascal = {
    home = {
      sessionVariables.CMAKE_GENERATOR = "Ninja";

      file = {
        ".clang-format".source = ../../resources/clang/format.yaml;
        ".clang-tidy".source = ../../resources/clang/tidy.yaml;
        ".config/clangd/config.yaml".source = ../../resources/clang/clangd.yaml;
      };

      packages = [
        pkgs.cmake
        pkgs.gcc
        pkgs.gdb
        pkgs.gnumake
        pkgs.ninja
        pkgs.nodejs
        pkgs.php
        pkgs.python3
        pkgs.sqlite
        pkgs.sqlitebrowser
      ];
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

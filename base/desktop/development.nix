{ pkgs, ... }: {
  home-manager.users.pascal = {
    home = {
      sessionVariables.CMAKE_GENERATOR = "Ninja";

      file = {
        ".config/clangd/config.yaml".source = ../../resources/clang/clangd.yaml;
        "Documents/.clang-format".source = ../../resources/clang/format.yaml;
        "Documents/.clang-tidy".source = ../../resources/clang/tidy.yaml;
      };

      packages = [
        pkgs.cmake
        pkgs.gcc
        pkgs.gdb
        pkgs.gnumake
        pkgs.jdk
        pkgs.ninja
        pkgs.nodejs
        pkgs.php
        pkgs.python3
        pkgs.texlive.combined.scheme-full
      ];
    };
  };
}

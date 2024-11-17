{ pkgs, ... }: {
  home-manager.users.pascal = {
    xdg.configFile."clangd/config.yaml".source = ../../resources/clang/clangd.yaml;

    home = {
      sessionVariables.CMAKE_GENERATOR = "Ninja";

      file = {
        "Documents/.clang-format".source = ../../resources/clang/format.yaml;
        "Documents/.clang-tidy".source = ../../resources/clang/tidy.yaml;
      };

      packages = [
        pkgs.cmake
        pkgs.gcc
        pkgs.ninja
      ];
    };
  };
}

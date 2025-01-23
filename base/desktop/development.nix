{ pkgs, ... }: {
  home-manager.users.pascal = {
    home = {
      packages = [ pkgs.cmake pkgs.gcc pkgs.gdb pkgs.gnumake pkgs.ninja pkgs.nodejs pkgs.php pkgs.python3 ];
      sessionVariables.CMAKE_GENERATOR = "Ninja";

      file = {
        ".config/clangd/config.yaml".source = ../../resources/clang/clangd.yaml;
        "Documents/.clang-format".source = ../../resources/clang/format.yaml;
        "Documents/.clang-tidy".source = ../../resources/clang/tidy.yaml;
      };
    };

    programs = {
      java.enable = true;
      texlive.enable = true;
    };
  };
}

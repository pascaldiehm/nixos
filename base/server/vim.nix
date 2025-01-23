{
  home-manager.users.pascal.programs.vim = {
    enable = true;
    defaultEditor = true;
    extraConfig = builtins.readFile ../../resources/vimrc.vim;
  };
}

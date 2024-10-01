{ ... }: {
    # Home manager settings
    programs.home-manager.enable = true;

    home = {
        homeDirectory = "/home/pascal";
        stateVersion = "24.05";
        username = "pascal";
    };
}

{ ... }: {
  services.displayManager = {
    autoLogin.user = "pascal";

    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}

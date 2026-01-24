{ config, ... }: let
  htop = config.home-manager.users.pascal.lib.htop;
in {
  home-manager.users.pascal.programs.htop = {
    enable = true;

    settings = {
      delay = 10;
      enable_mouse = 0;
      hide_userland_threads = 1;
      highlight_base_name = 1;
      show_cpu_frequency = 1;
      show_program_path = 0;
      tree_view = 1;
    }
    // (htop.leftMeters [
      (htop.bar "LeftCPUs2")
      (htop.bar "Memory")
      (htop.bar "Swap")
      (htop.bar "GPU")
      (htop.text "DiskIO")
      (htop.text "NetworkIO")
    ])
    // (htop.rightMeters [
      (htop.bar "RightCPUs2")
      (htop.text "Tasks")
      (htop.text "LoadAverage")
      (htop.text "Uptime")
      (htop.text "Systemd")
      (htop.text "SystemdUser")
    ]);
  };
}

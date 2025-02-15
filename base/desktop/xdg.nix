{
  home-manager.users.pascal.xdg = {
    mimeApps = {
      enable = true;

      defaultApplications = {
        "application/json" = "firefox.desktop";
        "application/pdf" = "firefox.desktop";
        "application/vnd.sqlite3" = "sqlitebrowser.desktop";
        "audio/mp4" = "vlc.desktop";
        "audio/mpeg" = "vlc.desktop";
        "audio/ogg" = "vlc.desktop";
        "audio/vnd.wav" = "vlc.desktop";
        "image/gif" = "firefox.desktop";
        "image/jpeg" = "firefox.desktop";
        "image/png" = "firefox.desktop";
        "image/svg+xml" = "firefox.desktop";
        "image/webp" = "firefox.desktop";
        "image/x-icon" = "firefox.desktop";
        "text/calendar" = "thunderbird.desktop";
        "text/html" = "firefox.desktop";
        "text/markdown" = "firefox.desktop";
        "video/mp4" = "vlc.desktop";
        "video/quicktime" = "vlc.desktop";
        "video/webm" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
        "video/x-msvideo" = "vlc.desktop";
      };
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = null;
      publicShare = null;
      templates = null;
    };
  };
}

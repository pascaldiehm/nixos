{
  home-manager.users.pascal.xdg = {
    enable = true;

    mimeApps = {
      enable = true;

      defaultApplications = {
        "application/json" = "firefox.desktop";
        "application/pdf" = "org.kde.okular.desktop";
        "audio/aac" = "vlc.desktop";
        "audio/flac" = "vlc.desktop";
        "audio/m4a" = "vlc.desktop";
        "audio/mp4" = "vlc.desktop";
        "audio/mpeg" = "vlc.desktop";
        "audio/ogg" = "vlc.desktop";
        "audio/wav" = "vlc.desktop";
        "audio/webm" = "vlc.desktop";
        "audio/x-wav" = "vlc.desktop";
        "image/bmp" = "org.kde.gwenview.desktop";
        "image/gif" = "org.kde.gwenview.desktop";
        "image/jpeg" = "org.kde.gwenview.desktop";
        "image/png" = "org.kde.gwenview.desktop";
        "image/svg+xml" = "org.kde.gwenview.desktop";
        "image/webp" = "org.kde.gwenview.desktop";
        "inode/directory" = "org.kde.dolphin.desktop";
        "text/calendar" = "thunderbird.desktop";
        "text/html" = "firefox.desktop";
        "text/markdown" = "firefox.desktop";
        "text/plain" = "firefox.desktop";
        "video/avi" = "vlc.desktop";
        "video/flv" = "vlc.desktop";
        "video/mp4" = "vlc.desktop";
        "video/mpeg" = "vlc.desktop";
        "video/msvideo" = "vlc.desktop";
        "video/quicktime" = "vlc.desktop";
        "video/webm" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
        "video/x-msvideo" = "vlc.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/mailto" = "firefox.desktop";
      };
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = null;
      documents = null;
      music = null;
      pictures = null;
      publicShare = null;
      templates = null;
      videos = null;
    };
  };
}

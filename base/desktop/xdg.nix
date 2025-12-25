{
  home-manager.users.pascal.xdg = {
    enable = true;

    mimeApps = {
      enable = true;

      defaultApplications = {
        "application/gzip" = "org.kde.ark.desktop";
        "application/json" = "firefox.desktop";
        "application/pdf" = "org.kde.okular.desktop";
        "application/vnd.efi.iso" = "org.kde.ark.desktop";
        "application/x-compressed-tar" = "org.kde.ark.desktop";
        "application/x-cpio" = "org.kde.ark.desktop";
        "application/x-tar" = "org.kde.ark.desktop";
        "application/xml" = "firefox.desktop";
        "application/zip" = "org.kde.ark.desktop";
        "audio/aac" = "vlc.desktop";
        "audio/flac" = "vlc.desktop";
        "audio/mp4" = "vlc.desktop";
        "audio/mpeg" = "vlc.desktop";
        "audio/vnd.wav" = "vlc.desktop";
        "audio/webm" = "vlc.desktop";
        "audio/x-matroska" = "vlc.desktop";
        "image/bmp" = "org.kde.gwenview.desktop";
        "image/gif" = "org.kde.gwenview.desktop";
        "image/jpeg" = "org.kde.gwenview.desktop";
        "image/png" = "org.kde.gwenview.desktop";
        "image/svg+xml" = "org.kde.gwenview.desktop";
        "image/vnd.microsoft.icon" = "org.kde.gwenview.desktop";
        "image/webp" = "org.kde.gwenview.desktop";
        "inode/directory" = "org.kde.dolphin.desktop";
        "inode/mount-point" = "org.kde.dolphin.desktop";
        "text/calendar" = "thunderbird.desktop";
        "text/html" = "firefox.desktop";
        "text/markdown" = "firefox.desktop";
        "text/plain" = "firefox.desktop";
        "video/mp4" = "vlc.desktop";
        "video/quicktime" = "vlc.desktop";
        "video/vnd.avi" = "vlc.desktop";
        "video/webm" = "vlc.desktop";
        "video/x-flv" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
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

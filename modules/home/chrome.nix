{ pkgs, ... }: {
  # Install google-chrome
  home.packages = [ pkgs.google-chrome ];

  # Set as default browser
  xdg.mimeApps.defaultApplications = {
    "text/html" = "google-chrome.desktop";
    "x-scheme-handler/http" = "google-chrome.desktop";
    "x-scheme-handler/https" = "google-chrome.desktop";
  };
}

{ ... }: {
  # Setup Firefox
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" "de" ];

    policies.ExtensionSettings = { "*".installation_mode = "blocked"; } // builtins.listToAttrs (map (id: {
      name = id;
      value = {
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
      };
    }) [
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" # Bitwarden
      "dont-track-me-google@robwu.nl" # Don't track me Google
      "plasma-browser-integration@kde.org" # Plasma Integration
      "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" # Return YouTube Dislike
      "uBlock0@raymondhill.net" # uBlock Origin
    ]);

    profiles.default = {
      name = "Default";

      bookmarks = [
        {
          name = "Toolbar";
          toolbar = true;
          bookmarks = [
            { name = "GitHub"; url = "https://github.com"; }
            { name = "WhatsApp"; url = "https://web.whatsapp.com"; }
            { name = "Home Assistant"; url = "http://192.168.1.88:8123"; }
          ];
        }

        { name = "Amazon"; url = "https://amazon.de"; }
        { name = "Cloudflare"; url = "https://dash.cloudflare.com"; }
        { name = "Hetzner"; url = "https://console.hetzner.cloud"; }
        { name = "PayPal"; url = "https://paypal.com"; }
        { name = "PiHole"; url = "http://192.168.1.88/admin"; }
        { name = "Sparkasse"; url = "https://sparkasse-mainfranken.de"; }
      ];

      search = {
        default = "Google";
        force = true;

        engines = {
          "Docker Hub" = {
            definedAliases = [ "@docker" ];
            urls = [{ template = "https://hub.docker.com/search?q={searchTerms}"; }];
          };

          "GitHub" = {
            definedAliases = [ "@github" "@gh" ];
            urls = [{ template = "https://github.com/search?q={searchTerms}"; }];
          };

          "NixOS Options" = {
            definedAliases = [ "@nixopts" ];
            urls = [{ template = "https://search.nixos.org/options?query={searchTerms}"; }];
          };

          "NixOS Packages" = {
            definedAliases = [ "@nixpkgs" ];
            urls = [{ template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; }];
          };

          "NPM" = {
            definedAliases = [ "@npm" ];
            urls = [{ template = "https://npmjs.com/search?q={searchTerms}"; }];
          };

          "Mozilla Developer Network" = {
            definedAliases = [ "@mdn" "@js" ];
            urls = [{ template = "https://developer.mozilla.org/search?q={searchTerms}"; }];
          };

          "YouTube" = {
            definedAliases = [ "@youtube" "@yt" ];
            urls = [{ template = "https://youtube.com/results?search_query={searchTerms}"; }];
          };

          "YouTube Music" = {
            definedAliases = [ "@music" "@ytm" ];
            urls = [{ template = "https://music.youtube.com/search?q={searchTerms}"; }];
          };
        };
      };
    };
  };

  # Add mime types
  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
  };
}

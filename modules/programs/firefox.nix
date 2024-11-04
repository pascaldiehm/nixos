{ pkgs, helpers, ... }: {
  home-manager.users.pascal = {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox.override { nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ]; };

      policies = {
        DisableFirefoxAccounts = true;
        ExtensionSettings = helpers.mkMozillaExtensions ../../resources/extensions/firefox.json;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        PasswordManagerEnabled = false;
      };

      profiles.default = {
        name = "Default";
        settings."browser.translations.automaticallyPopup" = false;

        bookmarks = [
          {
            name = "Toolbar";
            toolbar = true;
            bookmarks = [
              (helpers.mkFirefoxBookmarksFolder "Google" {
                Account = "https://myaccount.google.com";
                Calendar = "https://calendar.google.com";
                Contacts = "https://contacts.google.com";
                Drive = "https://drive.google.com";
                Keep = "https://keep.google.com";
                Maps = "https://google.com/maps";
                Photos = "https://photos.google.com";
                YouTube = "https://youtube.com";
              })
            ] ++ helpers.mkFirefoxBookmarks {
              Element = "https://app.element.io";
              GitHub = "https://github.com";
              "Home Assistant" = "http://192.168.1.89:8123";
              WhatsApp = "https://web.whatsapp.com";
            };
          }

          (helpers.mkFirefoxBookmarksFolder "NixOS Manuals" {
            "Home Manager Manual" = "https://nix-community.github.io/home-manager";
            "NixOS Manual" = "https://nixos.org/manual/nixos/stable";
            "Plasma Manager Manual" = "https://nix-community.github.io/plasma-manager";
          })
        ] ++ helpers.mkFirefoxBookmarks {
          Amazon = "https://amazon.de";
          ChatGPT = "https://chatgpt.com";
          Cloudflare = "https://dash.cloudflare.com";
          Hetzner = "https://console.hetzner.cloud";
          "Matrix Admin" = "https://matrix-admin.pdiehm.dev";
          PayPal = "https://paypal.com";
          PiHole = "http://192.168.1.88/admin";
          Sparkasse = "https://sparkasse-mainfranken.de";
        };

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

    xdg.mimeApps.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };
}

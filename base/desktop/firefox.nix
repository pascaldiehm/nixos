{ config, lib, ... }: {
  home-manager.users.pascal.programs.firefox = {
    enable = true;

    policies = {
      DisableFirefoxAccounts = true;
      DisablePocket = true;
      ExtensionSettings = lib.mkMozillaExtensions ../../resources/extensions/firefox.json;
      PasswordManagerEnabled = false;
    };

    profiles.default = {
      name = "Default";

      bookmarks = lib.mkFirefoxBookmarks {
        Amazon = "https://amazon.de";
        Brilliant = "https://brilliant.org";
        ChatGPT = "https://chatgpt.com";
        Cloudflare = "https://dash.cloudflare.com";
        Hetzner = "https://console.hetzner.cloud";
        "Matrix Admin" = "https://admin.etke.cc";
        Netflix = "https://netflix.com";
        PayPal = "https://paypal.com";
        PiHole = "http://192.168.1.88:8072/admin";
        Sparkasse = "https://sparkasse-mainfranken.de";

        _toolbar = {
          Element = "https://app.element.io";
          GitHub = "https://github.com";
          "Home Assistant" = "http://192.168.1.89:8123";
          WhatsApp = "https://web.whatsapp.com";

          Google = {
            Account = "https://myaccount.google.com";
            Calendar = "https://calendar.google.com";
            Contacts = "https://contacts.google.com";
            Drive = "https://drive.google.com";
            Keep = "https://keep.google.com";
            Maps = "https://google.com/maps";
            Photos = "https://photos.google.com";
            Tasks = "https://tasks.google.com";
            YouTube = "https://youtube.com";
            "YouTube Music" = "https://music.youtube.com";
          };
        };

        "NixOS Manuals" = {
          "Home Manager Manual" = "https://nix-community.github.io/home-manager";
          "Nix Manual" = "https://nixos.org/manual/nix/stable";
          "NixOS Manual" = "https://nixos.org/manual/nixos/stable";
          "Nixpkgs Manual" = "https://nixos.org/manual/nixpkgs/stable";
          "Nixvim Manual" = "https://nix-community.github.io/nixvim";
          "Stylix Manual" = "https://stylix.danth.me";
        };
      };

      search = {
        default = "Google";
        force = true;

        engines = {
          "Bing".metaData.hidden = true;
          "DuckDuckGo".metaData.hidden = true;
          "Wikipedia (en)".metaData.hidden = true;

          "Docker Hub" = {
            urls = [ { template = "https://hub.docker.com/search?q={searchTerms}"; } ];
            definedAliases = [ "@docker" ];
          };

          "GitHub" = {
            urls = [ { template = "https://github.com/search?q={searchTerms}"; } ];
            definedAliases = [ "@github" ];
          };

          "MDN" = {
            urls = [ { template = "https://developer.mozilla.org/search?q={searchTerms}"; } ];
            definedAliases = [ "@mdn" ];
          };

          "NixOS Options" = {
            urls = [ { template = "https://search.nixos.org/options?channel=${config.system.stateVersion}&query={searchTerms}"; } ];
            definedAliases = [ "@nixopts" ];
          };

          "NixOS Packages" = {
            urls = [ { template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; } ];
            definedAliases = [ "@nixpkgs" ];
          };

          "NixOS Wiki" = {
            urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
            definedAliases = [ "@nixwiki" ];
          };

          "NPM" = {
            urls = [ { template = "https://npmjs.com/search?q={searchTerms}"; } ];
            definedAliases = [ "@npm" ];
          };

          "YouTube" = {
            urls = [ { template = "https://youtube.com/results?search_query={searchTerms}"; } ];
            definedAliases = [ "@youtube" ];
          };

          "YouTube Music" = {
            urls = [ { template = "https://music.youtube.com/search?q={searchTerms}"; } ];
            definedAliases = [ "@music" ];
          };
        };
      };

      settings = {
        "browser.formfill.enable" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.newtabWallpapers.wallpaper-dark" = "dark-beach";
        "browser.search.suggest.enabled" = false;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.translations.automaticallyPopup" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.recentsearches" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.topsites" = false;
        "dom.security.https_only_mode" = true;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "media.eme.enabled" = true;
        "places.history.enabled" = false;
        "privacy.history.custom" = true;
      };
    };
  };
}

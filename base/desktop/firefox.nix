{ config, libx, pkgs, ... }: {
  home-manager.users.pascal.programs.firefox = {
    enable = true;
    package = pkgs.firefox.override { nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ]; };

    policies = {
      DisableFirefoxAccounts = true;
      ExtensionSettings = libx.mkMozillaExtensions ../../resources/extensions/firefox.json;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      PasswordManagerEnabled = false;
    };

    profiles.default = {
      name = "Default";
      settings."browser.translation.automaticallyPopup" = false;

      bookmarks = libx.mkFirefoxBookmarks {
        Amazon = "https://amazon.de";
        ChatGPT = "https://chatgpt.com";
        Cloudflare = "https://dash.cloudflare.com";
        Hetzner = "https://console.hetzner.cloud";
        "Matrix Admin" = "https://matrix-admin.pdiehm.dev";
        PayPal = "https://paypal.com";
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
          "Plasma Manager Manual" = "https://nix-community.github.io/plasma-manager";
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
    };
  };
}

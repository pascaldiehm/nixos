{ inputs, pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = [
    pkgs.kdePackages.elisa
    pkgs.kdePackages.krdp
  ];

  home-manager = {
    sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

    users.pascal = {
      home.packages = [
        pkgs.kdePackages.filelight
        pkgs.kdePackages.kdeconnect-kde
        pkgs.kdePackages.partitionmanager
      ];

      programs = {
        konsole = {
          enable = true;
          defaultProfile = "default";
          extraConfig.KonsoleWindow.RememberWindowSize = false;
          profiles.default.font.name = "Fira Code";
        };

        okular = {
          enable = true;
          accessibility.highlightLinks = true;
        };

        plasma = {
          enable = true;
          dataFile."dolphin/view_properties/global/.directory".Settings.HiddenFilesShown = true;
          krunner.position = "center";
          kscreenlocker.appearance.wallpaper = "${../../resources/wallpaper.jpg}";
          overrideConfig = true;

          configFile = {
            kwinrc.Effect-overview.BorderActivate = 9;
            okularpartrc."Dlg Presentation".SlidesShowProgress = false;
            plasmashellrc."Notification Messages".klipperClearHistoryAskAgain = false;
            systemsettingsrc.systemsettings_sidebar_mode.HighlightNonDefaultSettings = true;

            dolphinrc = {
              General.RememberOpenedTabs = false;
              IconsMode.PreviewSize = 80;
            };

            krunnerrc = {
              Plugins = {
                baloosearchEnabled = false;
                browserhistoryEnabled = false;
                browsertabsEnabled = false;
                krunner_appstreamEnabled = false;
                krunner_bookmarksrunnerEnabled = false;
                krunner_charrunnerEnabled = false;
                krunner_dictionaryEnabled = false;
                krunner_katesessionsEnabled = false;
                krunner_killEnabled = false;
                krunner_konsoleprofilesEnabled = false;
                krunner_kwinEnabled = false;
                krunner_placesrunnerEnabled = false;
                krunner_plasma-desktopEnabled = false;
                krunner_recentdocumentsEnabled = false;
                krunner_spellcheckEnabled = false;
                krunner_webshortcutsEnabled = false;
                locationsEnabled = false;
                "org.kde.activities2Enabled" = false;
                windowsEnabled = false;
              };

              "Plugins/Favorites".plugins = builtins.concatStringsSep "," [
                "krunner_powerdevil"
                "krunner_sessions"
                "krunner_services"
                "krunner_systemsettings"
                "org.kde.datetime"
                "unitconverter"
                "krunner_shell"
                "calculator"
                "helprunner"
              ];
            };

            kwalletrc = {
              "Auto Allow".kdewallet = "kded6,KDE System,kwalletmanager,VSCodium";
              Wallet."Prompt on Open" = true;
            };
          };

          input.keyboard = {
            numlockOnStartup = "on";
            repeatDelay = 200;
          };

          kwin = {
            cornerBarrier = false;
            edgeBarrier = 0;
            effects.dimAdminMode.enable = true;

            titlebarButtons.left = [
              "more-window-actions"
              "on-all-desktops"
              "keep-above-windows"
            ];

            virtualDesktops = {
              rows = 1;

              names = [
                "Primary"
                "Secondary"
                "Tertiary"
              ];
            };
          };

          panels = [
            {
              screen = 0;

              widgets = [
                {
                  name = "org.kde.plasma.kickoff";
                  config.General.icon = "${../../resources/flake.png}";
                }

                {
                  name = "org.kde.plasma.icontasks";

                  config.General.launchers = [
                    "applications:org.kde.dolphin.desktop"
                    "applications:firefox.desktop"
                    "applications:thunderbird.desktop"
                  ];
                }

                { name = "org.kde.plasma.marginsseparator"; }
                { name = "org.kde.plasma.systemtray"; }

                {
                  name = "org.kde.plasma.digitalclock";
                  config.Appearance.showSeconds = 2;
                }
              ];
            }
          ];

          powerdevil = {
            battery.autoSuspend.action = "nothing";

            AC = {
              autoSuspend.action = "nothing";
              dimDisplay.enable = false;
            };
          };

          shortcuts = {
            kaccess."Toggle Screen Reader On and Off" = "none";
            "services/org.kde.konsole.desktop"._launch = "Meta+Return";
            "services/org.kde.plasma.emojier.desktop"._launch = "none";

            "KDE Keyboard Layout Switcher" = {
              "Switch to Last-Used Keyboard Layout" = "none";
              "Switch to Next Keyboard Layout" = "none";
            };

            kwin = {
              "Activate Window Demanding Attention" = "none";
              "Expose" = "none";
              "ExposeAll" = "none";
              "ExposeClass" = "none";
              "Grid View" = "none";
              "Kill Window" = "Meta+Ctrl+Shift+Q";
              "MoveMouseToCenter" = "none";
              "MoveMouseToFocus" = "none";
              "Switch One Desktop Down" = "none";
              "Switch One Desktop Up" = "none";
              "Switch Window Down" = "none";
              "Switch Window Left" = "none";
              "Switch Window Right" = "none";
              "Switch Window Up" = "none";
              "Switch to Desktop 1" = "none";
              "Switch to Desktop 2" = "none";
              "Switch to Desktop 3" = "none";
              "Switch to Desktop 4" = "none";
              "Walk Through Windows of Current Application (Reverse)" = "none";
              "Walk Through Windows of Current Application" = "none";
              "Window Above Other Windows" = "Meta+Shift+Up";
              "Window Below Other Windows" = "Meta+Shift+Down";
              "Window Close" = "Meta+Shift+Q";
              "Window Fullscreen" = "Meta+F";
              "Window Maximize" = "Meta+Up";
              "Window Minimize" = "Meta+Q";
              "Window One Desktop Down" = "none";
              "Window One Desktop Up" = "none";
              "Window Operations Menu" = "none";
              "Window Quick Tile Bottom" = "none";
            };

            plasmashell = {
              "clipboard_action" = "none";
              "cycle-panels" = "none";
              "next activity" = "none";
              "previous activity" = "none";
              "show dashboard" = "none";
              "show-on-mouse-pos" = "none";
              "stop current activity" = "none";
            };

            "services/org.kde.krunner.desktop" = {
              _launch = "Meta+Space";
              RunClipboard = "none";
            };
          };

          workspace = {
            lookAndFeel = "org.kde.breezedark.desktop";
            wallpaper = "${../../resources/wallpaper.jpg}";
          };
        };
      };
    };
  };
}

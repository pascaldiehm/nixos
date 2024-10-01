{ ... }: {
    # Home manager settings
    programs.home-manager.enable = true;

    home = {
        homeDirectory = "/home/pascal";
        stateVersion = "24.05";
        username = "pascal";
    };

    # Plasma
    programs.plasma = {
        enable = true;
        kscreenlocker.appearance.wallpaper = ../resources/wallpaper.jpg;
        overrideConfig = true;

        configFile = {
            dolphinrc.General.RememberOpenedTabs = false;
            katerc.General."Show welcome view for new window" = false;
            klipperrc.General.KeepClipboardContents = false;
            kwinrc.Effect-overview.BorderActivate = 9;
            okularpartrc."Dlg Presentation".SlidesShowProgress = false;
            spectaclerc.ImageSave.imageSaveLocation = "file:///home/pascal/Downloads";
            systemsettingsrc.systemsettings_sidebar_mode.HighlightNonDefaultSettings = true;

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
                "Auto Allow".kdewallet = builtins.concatStringsSep "," [ "kded6" "KDE System" "kwalletmanager" "Google Chrome" "Code" "Signal" ];
                Wallet."Prompt on Open" = true;
            };

            powerdevilrc = {
                "LowBattery/Display".DisplayBrightness = 25;

                "AC/Display" = {
                    DisplayBrightness = 100;
                    UseProfileSpecificDisplayBrightness = true;
                };

                "Battery/Display" = {
                    DisplayBrightness = 50;
                    UseProfileSpecificDisplayBrightness = true;
                };
            };

        };

        input.keyboard = {
            numlockOnStartup = "on";
            options = [ "caps:escape_shifted_capslock" ];
            repeatDelay = 200;
            repeatRate = 25;
        };

        krunner = {
            historyBehavior = "disabled";
            position = "center";
        };


        kwin = {
            cornerBarrier = false;
            edgeBarrier = 0;
            effects.dimAdminMode.enable = true;
            titlebarButtons.left = [ "more-window-actions" "on-all-desktops" "keep-above-windows" ];

            virtualDesktops = {
                names = [ "Primary" "Secondary" "Tertiary" ];
                rows = 1;
            };
        };

        panels = [{
            widgets = [
                { name = "org.kde.plasma.kickoff"; config.General.icon = "/home/pascal/.config/nixos/resources/flake.png"; }
                { name = "org.kde.plasma.icontasks"; config.General.launchers = [ "applications:org.kde.dolphin.desktop" ]; }
                { name = "org.kde.plasma.marginsseparator"; }
                { name = "org.kde.plasma.systemtray"; }
                { name = "org.kde.plasma.digitalclock"; config.Appearance.showSeconds = 2; }
            ];
        }];

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
            wallpaper = ../resources/wallpaper.jpg;
        };
    };

    # Konsole
    programs.konsole = {
        enable = true;
        extraConfig.KonsoleWindow.RememberWindowSize = false;
    };

    # Okular
    programs.okular = {
        enable = true;
        accessibility.highlightLinks = true;
    };
}

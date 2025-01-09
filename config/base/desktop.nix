{ config, lib, pkgs, helpers, ... }: {
  fonts.packages = [ pkgs.fira-code ];
  imports = [ ../extra/university.nix ];
  users.users.pascal.extraGroups = [ "networkmanager" ];

  boot.initrd = {
    luks.devices.nixos.device = "/dev/disk/by-partlabel/nixos";
    postDeviceCommands = lib.mkAfter (builtins.readFile ../../resources/scripts/wipe-root.sh);
  };

  environment = {
    plasma6.excludePackages = [ pkgs.kdePackages.elisa pkgs.kdePackages.kate pkgs.kdePackages.krdp ];

    persistence."/perm" = {
      directories = [ "/etc/nixos" "/var/lib/nixos" ];
      files = [ "/etc/machine-id" ];
      hideMounts = true;

      users.pascal = {
        files = [ ".config/VSCodium/User/globalStorage/state.vscdb" ".config/kwinoutputconfig.json" ];

        directories = [
          ".config/kdeconnect"
          ".config/nixos"
          ".local/share/kwalletd"
          ".local/state/wireplumber"
          ".mozilla/firefox/default"
          ".thunderbird/default"
          "Documents"
          { directory = ".local/share/gnupg"; mode = "0700"; }
          { directory = ".ssh"; mode = "0700"; }
        ];
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/nixos";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

    "/nix" = {
      device = "/dev/mapper/nixos";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

    "/perm" = {
      device = "/dev/mapper/nixos";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=perm" ];
    };
  };

  home-manager.users.pascal = {
    accounts.email.accounts.default = {
      address = "pdiehm8@gmail.com";
      flavor = "gmail.com";
      primary = true;
      realName = config.users.users.pascal.description;
      thunderbird.enable = true;

      gpg = {
        key = "E85EB0566C779A2F";
        signByDefault = true;
      };

      imap = {
        host = "imap.gmail.com";
        port = 993;
      };

      smtp = {
        host = "smtp.gmail.com";
        port = 465;
      };
    };

    home = {
      sessionVariables.CMAKE_GENERATOR = "Ninja";

      file = {
        "Documents/.clang-format".source = ../../resources/clang/format.yaml;
        "Documents/.clang-tidy".source = ../../resources/clang/tidy.yaml;
      };

      packages = [
        pkgs.btrfs-progs
        pkgs.cmake
        pkgs.cryptsetup
        pkgs.exfat
        pkgs.gcc
        pkgs.gdb
        pkgs.gnumake
        pkgs.gradle
        pkgs.imagemagickBig
        pkgs.jdk
        pkgs.kdePackages.filelight
        pkgs.kdePackages.kdeconnect-kde
        pkgs.kdePackages.partitionmanager
        pkgs.ninja
        pkgs.nodejs
        pkgs.php
        pkgs.poppler_utils
        pkgs.python3
        pkgs.quickemu
        pkgs.sops
        pkgs.sshfs
        pkgs.texlive.combined.scheme-full
        pkgs.vlc
        pkgs.yt-dlp
        pkgs.yubioath-flutter
      ];
    };

    programs = {
      zsh.localVariables.NIXOS_MACHINE_TYPE = "desktop";

      firefox = {
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
                {
                  name = "Google";
                  bookmarks = [
                    { name = "Account"; url = "https://myaccount.google.com"; }
                    { name = "Calendar"; url = "https://calendar.google.com"; }
                    { name = "Contacts"; url = "https://contacts.google.com"; }
                    { name = "Drive"; url = "https://drive.google.com"; }
                    { name = "Keep"; url = "https://keep.google.com"; }
                    { name = "Maps"; url = "https://google.com/maps"; }
                    { name = "Photos"; url = "https://photos.google.com"; }
                    { name = "Tasks"; url = "https://tasks.google.com"; }
                    { name = "YouTube"; url = "https://youtube.com"; }
                    { name = "YouTube Music"; url = "https://music.youtube.com"; }
                  ];
                }

                { name = "Element"; url = "https://app.element.io"; }
                { name = "GitHub"; url = "https://github.com"; }
                { name = "Home Assistant"; url = "http://192.168.1.89:8123"; }
                { name = "WhatsApp"; url = "https://web.whatsapp.com"; }
              ];
            }

            {
              name = "NixOS Manuals";
              bookmarks = [
                { name = "Home Manager Manual"; url = "https://nix-community.github.io/home-manager"; }
                { name = "NixOS Manual"; url = "https://nixos.org/manual/nixos/stable"; }
                { name = "Plasma Manager Manual"; url = "https://nix-community.github.io/plasma-manager"; }
              ];
            }

            { name = "Amazon"; url = "https://amazon.de"; }
            { name = "ChatGPT"; url = "https://chatgpt.com"; }
            { name = "Cloudflare"; url = "https://dash.cloudflare.com"; }
            { name = "Hetzner"; url = "https://console.hetzner.cloud"; }
            { name = "Matrix Admin"; url = "https://matrix-admin.pdiehm.dev"; }
            { name = "PayPal"; url = "https://paypal.com"; }
            { name = "Sparkasse"; url = "https://sparkasse-mainfranken.de"; }
          ];

          search = {
            default = "Google";
            force = true;

            engines = {
              "Bing".metaData.hidden = true;
              "DuckDuckGo".metaData.hidden = true;
              "Wikipedia (en)".metaData.hidden = true;

              "Docker Hub" = {
                urls = [{ template = "https://hub.docker.com/search?q={searchTerms}"; }];
                definedAliases = [ "@docker" ];
              };

              "MDN" = {
                urls = [{ template = "https://developer.mozilla.org/search?q={searchTerms}"; }];
                definedAliases = [ "@mdn" ];
              };

              "NixOS Options" = {
                urls = [{ template = "https://search.nixos.org/options?channel=${config.system.stateVersion}&query={searchTerms}"; }];
                definedAliases = [ "@nixopts" ];
              };

              "NixOS Packages" = {
                urls = [{ template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; }];
                definedAliases = [ "@nixpkgs" ];
              };

              "NixOS Wiki" = {
                urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
                definedAliases = [ "@nixwiki" ];
              };

              "NPM" = {
                urls = [{ template = "https://npmjs.com/search?q={searchTerms}"; }];
                definedAliases = [ "@npm" ];
              };

              "YouTube" = {
                urls = [{ template = "https://youtube.com/results?search_query={searchTerms}"; }];
                definedAliases = [ "@youtube" ];
              };

              "YouTube Music" = {
                urls = [{ template = "https://music.youtube.com/search?q={searchTerms}"; }];
                definedAliases = [ "@music" ];
              };
            };
          };
        };
      };

      git.signing = {
        key = "E85EB0566C779A2F";
        signByDefault = true;
      };

      gpg = {
        enable = true;
        homedir = "${config.home-manager.users.pascal.xdg.dataHome}/gnupg";
        scdaemonSettings.disable-ccid = true;
      };

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
            "Auto Allow".kdewallet = builtins.concatStringsSep "," [ "kded6" "KDE System" "kwalletmanager" "VSCodium" ];
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
          titlebarButtons.left = [ "more-window-actions" "on-all-desktops" "keep-above-windows" ];

          virtualDesktops = {
            names = [ "Primary" "Secondary" "Tertiary" ];
            rows = 1;
          };
        };

        panels = [{
          screen = 0;
          widgets = [
            { name = "org.kde.plasma.kickoff"; config.General.icon = "${../../resources/flake.png}"; }

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
          wallpaper = "${../../resources/wallpaper.jpg}";
        };
      };

      ssh.matchBlocks = {
        "github.com".identityFile = config.sops.secrets."ssh/github".path;

        bowser = {
          identityFile = config.sops.secrets."ssh/bowser".path;
          port = 1970;
        };

        goomba = {
          identityFile = config.sops.secrets."ssh/goomba".path;
          port = 1970;
        };
      };

      thunderbird = {
        enable = true;
        package = pkgs.thunderbird.override { extraPolicies.ExtensionSettings = helpers.mkMozillaExtensions ../../resources/extensions/thunderbird.json; };

        profiles.default = {
          isDefault = true;
          withExternalGnupg = true;
        };

        settings = {
          "mail.collect_email_address_outgoing" = false;
          "mail.openpgp.fetch_pubkeys_from_gnupg" = true;
        };
      };

      vscode = {
        enable = true;
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
        keybindings = [{ key = "shift+enter"; command = "-python.execSelectionInTerminal"; }];
        package = pkgs.vscodium;

        extensions = with pkgs.vscode-extensions; [
          aaron-bond.better-comments
          bradlc.vscode-tailwindcss
          dbaeumer.vscode-eslint
          esbenp.prettier-vscode
          foxundermoon.shell-format
          github.vscode-github-actions
          james-yu.latex-workshop
          jnoortheen.nix-ide
          llvm-vs-code-extensions.vscode-clangd
          ms-azuretools.vscode-docker
          ms-python.isort
          ms-python.python
          ms-vscode.cmake-tools
          pkief.material-icon-theme
          streetsidesoftware.code-spell-checker
          twxs.cmake
          redhat.java
          usernamehw.errorlens
          vscodevim.vim
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (lib.importJSON ../../resources/extensions/vscode.json);

        userSettings = {
          # Editor
          "editor.fontFamily" = "Fira Code";
          "editor.fontLigatures" = true;
          "editor.formatOnSave" = true;
          "editor.inlayHints.enabled" = "off";
          "editor.lineNumbers" = "relative";
          "editor.linkedEditing" = true;
          "editor.tabSize" = 2;
          "explorer.compactFolders" = false;
          "extensions.experimental.affinity" = { "vscodevim.vim" = 1; };
          "extensions.ignoreRecommendations" = true;
          "files.enableTrash" = false;
          "files.insertFinalNewline" = true;
          "files.trimFinalNewlines" = true;
          "files.trimTrailingWhitespace" = true;
          "terminal.integrated.persistentSessionReviveProcess" = "never";
          "terminal.integrated.showExitAlert" = false;
          "update.showReleaseNotes" = false;
          "workbench.editorAssociations" = { "*.pdf" = "latex-workshop-pdf-hook"; };
          "workbench.iconTheme" = "material-icon-theme";
          "workbench.startupEditor" = "none";

          "editor.codeActionsOnSave" = {
            "source.organizeImports" = "always";
            "source.removeUnusedImports" = "always";
            "source.sortImports" = "always";
          };

          # General
          "cSpell.diagnosticLevel" = "Hint";
          "cSpell.language" = "en,de";
          "git.autofetch" = true;
          "git.confirmSync" = false;
          "git.inputValidation" = true;
          "git.openRepositoryInParentFolders" = "always";
          "material-icon-theme.activeIconPack" = "react";
          "vim.handleKeys" = { "<C-i>" = false; "<C-k>" = false; "<C-p>" = false; "<C-s>" = true; "<C-z>" = true; };
          "vim.useSystemClipboard" = true;

          # C++
          "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
          "cmake.configureOnOpen" = true;

          # Java
          "java.compile.nullAnalysis.mode" = "automatic";
          "java.configuration.updateBuildConfiguration" = "automatic";
          "java.format.settings.url" = ../../resources/java-format.xml;
          "redhat.telemetry.enabled" = false;

          # LaTeX
          "latex-workshop.latex.autoClean.run" = "onSucceeded";

          # PHP
          "intelephense.format.braces" = "k&r";

          # Prettier
          "prettier.arrowParens" = "avoid";
          "prettier.bracketSameLine" = true;
          "prettier.printWidth" = 120;

          # Python
          "autopep8.args" = [ "--indent-size=2" "--max-line-length=120" ];

          # Formatters
          "[css]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[dockerfile]"."editor.defaultFormatter" = "ms-azuretools.vscode-docker";
          "[html]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[typescriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "nix.formatterPath" = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
          "shellformat.path" = "${pkgs.shfmt}/bin/shfmt";
        };
      };
    };

    services.gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
    };

    xdg = {
      configFile."clangd/config.yaml".source = ../../resources/clang/clangd.yaml;
      stateFile.konsolestaterc.source = ../../resources/konsolestaterc;

      mimeApps = {
        enable = true;

        defaultApplications = {
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/mailto" = "thunderbird.desktop";
        };
      };

      userDirs = {
        enable = true;
        createDirectories = true;
      };
    };
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  networking = {
    firewall = {
      allowedTCPPorts = [ 1234 1716 1739 1740 1741 ];
      allowedUDPPorts = [ 1716 ];
    };

    networkmanager = {
      enable = true;
      ensureProfiles.environmentFiles = [ config.sops.secrets.network.path ];
    };
  };

  security.pam.u2f = {
    enable = true;

    settings = {
      cue = true;
      origin = "pam://pascal";
    };
  };

  services = {
    desktopManager.plasma6.enable = true;
    pcscd.enable = true;

    displayManager = {
      autoLogin.user = "pascal";

      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", ENV{PRODUCT}=="1050/407/543", RUN+="${pkgs.systemd}/bin/loginctl unlock-sessions"
      ACTION=="remove", SUBSYSTEM=="usb", ENV{PRODUCT}=="1050/407/543", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    '';
  };

  sops = {
    defaultSopsFile = ../../resources/secrets/desktop/store.yaml;
    gnupg.home = "/perm/etc/nixos/.gnupg";

    secrets = {
      network.restartUnits = [ "NetworkManager.service" "NetworkManager-ensure-profiles.service" ];
      "ssh/bowser".owner = "pascal";
      "ssh/github".owner = "pascal";
      "ssh/goomba".owner = "pascal";

      u2f_keys = {
        owner = "pascal";
        path = "${config.home-manager.users.pascal.xdg.configHome}/Yubico/u2f_keys";
      };
    };
  };

  system.activationScripts.linkProfilePicture = ''
    mkdir -p /var/lib/AccountsService/icons
    ln -sf "${../../resources/profile.png}" /var/lib/AccountsService/icons/pascal
  '';
}

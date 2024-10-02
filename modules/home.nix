{ lib, pkgs, ... }: {
  # Home manager settings
  programs.home-manager.enable = true;

  home = {
    homeDirectory = "/home/pascal";
    stateVersion = "24.05";
    username = "pascal";
  };

  # Home setup
  home.activation.deleteChannelLinks = lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" "linkGeneration" ] "run rm -rf .nix-defexpr .nix-profile";
  xdg.enable = true;

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

  # ZSH
  home.activation.deleteZSHEnv = lib.hm.dag.entryAfter [ "writeBoundary" ] "run rm -rf .zshenv";

  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    dotDir = ".config/zsh";
    history.path = "$ZDOTDIR/.zsh_history";
    plugins = [ { name = "zsh-completions"; src = pkgs.zsh-completions; } ];
    syntaxHighlighting.enable = true;

    initExtra = ''
      # Prompt
      export PROMPT=$'%F{4}%~%f %F{%(?.5.1)}\U276F%f '

      # Keybindings
      bindkey -rp ""
      bindkey -R ' '-'~' self-insert
      bindkey -R '\M-^@'-'\M-^?' self-insert

      bindkey '^M'      accept-line                         # Enter
      bindkey '^I'      expand-or-complete                  # Tab
      bindkey '^[[C'    forward-char                        # Right
      bindkey '^[[1;5C' forward-word                        # Ctrl+Right
      bindkey '^[[D'    backward-char                       # Left
      bindkey '^[[1;5D' backward-word                       # Ctrl+Left
      bindkey '^[[H'    beginning-of-line                   # Home
      bindkey '^[[F'    end-of-line                         # End
      bindkey '^[[A'    up-line-or-history                  # Up
      bindkey '^[[B'    down-line-or-history                # Down
      bindkey '^?'      backward-delete-char                # Backspace
      bindkey '^H'      backward-delete-word                # Ctrl+Backspace
      bindkey '^[[3~'   delete-char                         # Delete
      bindkey '^[[3;5~' delete-word                         # Ctrl+Delete
      bindkey '^V'      quoted-insert                       # Ctrl+V
      bindkey '^[[200~' bracketed-paste                     # Ctrl+Shift+V
      bindkey '^R'      history-incremental-search-backward # Ctrl+R
      bindkey '^L'      clear-screen                        # Ctrl+L
      bindkey '^Z'      undo                                # Ctrl+Z
      bindkey '^Y'      redo                                # Ctrl+Y

      bindkey "''${key[Home]}"  beginning-of-line
      bindkey "''${key[End]}"   end-of-line
      bindkey "''${key[Up]}"    up-line-or-history
      bindkey "''${key[Down]}"  down-line-or-history
      bindkey "''${key[Left]}"  backward-char
      bindkey "''${key[Right]}" forward-char

      # Functions
      function nixos-update() {(
        set -e
        cd ~/.config/nixos

        if [ -n "$(git status --porcelain)" ]; then
          echo "There are uncommitted changes. Please commit or stash them."
          return 1
        fi

        git fetch
        local ahead=$(git rev-list --count @{u}..)
        local behind=$(git rev-list --count ..@{u})

        if [ $ahead -gt 0 ] && [ $behind -gt 0 ]; then
          clear
          echo "The local branch is diverged from the remote branch."
          echo
          echo "R) Hard reset"
          echo "P) Force push"
          echo "I) Ignore"
          echo "Q) Abort"
          echo
          echo -n "> "
          read -k 1 action
          echo

          if [ "$action" = "R" ]; then
            git reset --hard @{u}
          elif [ "$action" = "P" ]; then
            git push --force
          elif [ "$action" != "I" ]; then
            return 1
          fi
        elif [ $ahead -gt 0 ]; then
          clear
          echo "The local branch is ahead of the remote branch."
          echo
          echo "P) Push"
          echo "R) Reset"
          echo "I) Ignore"
          echo "Q) Abort"
          echo
          echo -n "> "
          read -k 1 action
          echo

          if [ "$action" = "P" ]; then
            git push
          elif [ "$action" = "R" ]; then
            git reset --hard @{u}
          elif [ "$action" != "I" ]; then
            return 1
          fi
        elif [ $behind -gt 0 ]; then
          clear
          echo "The local branch is behind the remote branch."
          echo
          echo "P) Pull"
          echo "I) Ignore"
          echo "Q) Abort"
          echo
          echo -n "> "
          read -k 1 action
          echo

          if [ "$action" = "P" ]; then
            git pull
          elif [ "$action" != "I" ]; then
            return 1
          fi
        fi

        nix flake update
        if [ -n "$(git status --porcelain)" ]; then
          clear
          echo "Updates are available. Do you want to apply them?"
          echo -n "[y/N] "

          if read -q; then
            echo
            git add flake.lock
            git commit -m "Updated flake.lock"
            git push
          else
            echo
            git restore flake.lock
          fi
        fi

        sudo nixos-rebuild --impure --flake . switch
        cd - > /dev/null
      )}
    '';

    shellAliases = {
      l = "ls -alh";
      ll = "ls -lh";
      open = "xdg-open";
    };
  };

  # Vim
  programs.vim = {
    enable = true;
    defaultEditor = true;

    extraConfig = ''
      set autoindent
      set clipboard=unnamedplus
      set expandtab
      set ignorecase
      set nowrap
      set number
      set relativenumber
      set scrolloff=10
      set shiftwidth=4
      set smartcase
      set tabstop=4
      set viminfo=""
    '';
  };
}

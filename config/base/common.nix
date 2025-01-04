{ config, pkgs, nixpkgs, helpers, ... }: {
  console.keyMap = "de";
  environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
  i18n.defaultLocale = "en_US.UTF-8";
  sops.secrets.password.neededForUsers = true;
  services.xserver.xkb.layout = "de";
  system.stateVersion = "24.11";
  time.timeZone = "Europe/Berlin";

  boot.loader = {
    efi.canTouchEfiVariables = true;

    systemd-boot = {
      enable = true;
      configurationLimit = 8;
    };
  };

  home-manager = {
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    useUserPackages = true;

    users.pascal = {
      xdg.enable = true;

      home = {
        activation.deleteBackups = helpers.mkHMActivation [ "writeBoundary" ] "run find $HOME -name '*.hm-bak' -exec rm -rf {} \\;";
        homeDirectory = "/home/pascal";
        stateVersion = config.system.stateVersion;
        username = "pascal";

        packages = [
          pkgs.jq
          pkgs.unzip
          pkgs.wireguard-tools
          pkgs.zip
        ];
      };

      programs = {
        home-manager.enable = true;

        git = {
          enable = true;
          userEmail = "pdiehm8@gmail.com";
          userName = "Pascal Diehm";

          aliases = {
            a = "add";

            b = "branch";
            bc = "branch --copy";
            bd = "branch --delete";
            bdf = "branch --delete --force";
            bm = "branch --move";
            bu = "branch --set-upstream-to";

            c = "commit";
            ca = "commit --all";
            cac = "commit --all --amend --no-edit";
            cacm = "commit --all --amend --message";
            cam = "commit --all --message";
            cc = "commit --amend --no-edit";
            ccm = "commit --amend --message";
            ce = "commit --allow-empty";
            cem = "commit --allow-empty --message";
            cm = "commit --message";

            cl = "clean -fdx";
            cli = "clean -fdX";

            co = "checkout";
            cob = "checkout -b";

            d = "diff";
            dm = "rev-list --left-right --oneline main...";
            ds = "diff --staged";
            du = "rev-list --left-right --oneline @{u}...";

            f = "fetch";

            i = "status";
            is = "status --short";

            l = "log --format='%C(yellow)%h %C(blue)%aN, %ah %C(reset)%s%C(dim white)%d'";
            ll = "log --format='%C(yellow)%h %C(white)%s%C(dim white)%d%n%C(blue)%aN <%aE>, %ah %C(reset)- %C(green)(%G?) %GS%n'";
            lll = "log --format='%C(yellow)Commit %H%C(dim white)%d%n%C(blue)Author:    %aN <%aE> on %aD%n%C(blue)Committer: %cN <%cE> on %cD%n%C(green)Signature: (%G?) %GS%n%n%B%n'";

            m = "merge";
            ma = "merge --abort";
            mc = "merge --continue";

            pf = "push --force-with-lease";
            pl = "pull";
            ps = "push";

            rb = "rebase";
            rba = "rebase --abort";
            rbc = "rebase --continue";
            rbi = "rebase --interactive";
            rbr = "rebase --interactive --root";

            rsh = "reset --hard";
            rso = "reset --hard origin";

            rs = "restore";
            rss = "restore --staged";

            rv = "revert";
            rva = "revert --abort";
            rvc = "revert --continue";

            s = "stash push --include-untracked";
            sc = "stash clear";
            sd = "stash drop";
            sl = "stash list";
            sp = "stash pop";

            sh = "show";
            shh = "show @";

            t = "tag";
            td = "tag --delete";
            tm = "tag --message";
          };

          extraConfig = {
            help.autoCorrect = "prompt";
            init.defaultBranch = "main";
            pull.rebase = true;
            rebase.autoStash = true;
            submodule.recurse = true;

            fetch = {
              prune = true;
              pruneTags = true;
            };

            push = {
              autoSetupRemote = true;
              followTags = true;
            };

            url = {
              "git@github.com:".insteadOf = "gh:";
              "git@github.com:pascaldiehm/".insteadOf = "gh:/";
            };
          };
        };

        vim = {
          enable = true;
          defaultEditor = true;
          extraConfig = builtins.readFile ../../resources/vimrc.vim;
        };

        zsh = {
          enable = true;
          autosuggestion.enable = true;
          dotDir = ".config/zsh";
          history.path = "$ZDOTDIR/.zsh_history";
          initExtra = builtins.readFile ../../resources/zshrc.zsh;
          plugins = [{ name = "zsh-completions"; src = pkgs.zsh-completions; }];
          syntaxHighlighting.enable = true;

          shellAliases = {
            l = "ls -alh";
            nixos-test = "sudo nixos-rebuild --impure --flake ~/.config/nixos test";
            nixos-update = "nix run ~/.config/nixos#update";
          };
        };
      };
    };
  };

  nix = {
    channel.enable = false;
    registry.nixpkgs.flake = nixpkgs;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = [ "flakes" "nix-command" ];
      nix-path = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
      use-xdg-base-directories = true;
    };
  };

  programs = {
    nano.enable = false;
    zsh.enable = true;
  };

  users.users.pascal = {
    description = "Pascal Diehm";
    extraGroups = [ "docker" "wheel" ];
    hashedPasswordFile = config.sops.secrets.password.path;
    home = "/home/pascal";
    isNormalUser = true;
    shell = pkgs.zsh;
    uid = 1000;
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings.log-driver = "local";
  };
}

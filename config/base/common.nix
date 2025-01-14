{
  config,
  lib,
  glb,
  pkgs,
  ...
}:
{
  console.keyMap = "de";
  i18n.defaultLocale = "en_US.UTF-8";
  programs.nano.enable = false;
  system.stateVersion = "24.11";
  time.timeZone = "Europe/Berlin";

  boot = {
    initrd.postDeviceCommands = lib.mkAfter ''
      DISK="${config.fileSystems."/".device}"
      ${builtins.readFile ../../resources/scripts/wipe-root.sh}
    '';

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        configurationLimit = 8;
      };
    };
  };

  environment = {
    etc = {
      hosts.mode = "0644";
      "nix/inputs/nixpkgs".source = "${glb.nixpkgs}";
    };

    persistence."/perm" = {
      files = [ "/etc/machine-id" ];
      hideMounts = true;

      directories = [
        "/etc/nixos"
        "/var/lib/nixos"
        "/var/lib/systemd"
      ];

      users.pascal.directories = lib.mapAttrsToList (directory: mode: { inherit directory mode; }) {
        ".config/nixos" = "0755";
        ".ssh" = "0700";
      };
    };
  };

  fileSystems = {
    "/" = {
      device = if glb.machineType == "desktop" then "/dev/mapper/nixos" else "/dev/disk/by-partlabel/nixos";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

    "/boot" = {
      device = "/dev/disk/by-partlabel/ESP";
      fsType = "vfat";

      options = [
        "dmask=0077"
        "fmask=0077"
      ];
    };

    "/nix" = {
      device = config.fileSystems."/".device;
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

    "/perm" = {
      device = config.fileSystems."/".device;
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=perm" ];
    };
  };

  home-manager = {
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    useUserPackages = true;

    users.pascal = {
      xdg.enable = true;

      home = {
        homeDirectory = config.users.users.pascal.home;
        stateVersion = config.system.stateVersion;
        username = "pascal";

        activation.deleteBackups = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run find "${config.users.users.pascal.home}" -name "*.${config.home-manager.backupFileExtension}" -exec rm -rf "{}" ";"
        '';

        packages = [
          pkgs.btrfs-progs
          pkgs.jq
          pkgs.unzip
          pkgs.wireguard-tools
          pkgs.zip
        ];
      };

      programs = {
        home-manager.enable = true;
        ssh.enable = true;

        git = {
          enable = true;
          userEmail = "pdiehm8@gmail.com";
          userName = config.users.users.pascal.description;

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
            dm = "rev-list --left-right --oneline '...main'";
            ds = "diff --staged";
            du = "rev-list --left-right --oneline '...@{u}'";

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

            rs = "restore";
            rss = "restore --staged";

            rt = "reset";
            rth = "reset --hard";
            rtu = "reset --hard '@{u}'";

            rv = "revert";
            rva = "revert --abort";
            rvc = "revert --continue";

            s = "stash push --include-untracked";
            sc = "stash clear";
            sd = "stash drop";
            sl = "stash list";
            sp = "stash pop";

            sh = "show";

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
          completionInit = "autoload -U compinit && compinit -d '${config.home-manager.users.pascal.xdg.stateHome}/.zcompdump'";
          dotDir = "${lib.removePrefix "${config.users.users.pascal.home}/" config.home-manager.users.pascal.xdg.configHome}/zsh";
          history.path = "${config.home-manager.users.pascal.xdg.stateHome}/.zsh_history";
          initExtra = builtins.readFile ../../resources/zshrc.zsh;
          localVariables.NIXOS_MACHINE_TYPE = glb.machineType;
          plugins = lib.mapAttrsToList (name: src: { inherit name src; }) { zsh-completions = pkgs.zsh-completions; };
          syntaxHighlighting.enable = true;
        };
      };
    };
  };

  nix = {
    channel.enable = false;
    registry.nixpkgs.flake = glb.nixpkgs;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      auto-optimise-store = true;
      nix-path = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
      use-xdg-base-directories = true;

      experimental-features = [
        "flakes"
        "nix-command"
      ];
    };
  };

  services = {
    fwupd.enable = true;
    journald.storage = "volatile";
    xserver.xkb.layout = config.console.keyMap;
  };

  sops = {
    age.sshKeyPaths = [ ];
    defaultSopsFile = ../../resources/secrets/${glb.machineType}/store.yaml;

    gnupg = {
      home = "/perm/etc/nixos/.gnupg";
      sshKeyPaths = [ ];
    };

    secrets = {
      hosts.sopsFile = ../../resources/secrets/common/store.yaml;
      password.neededForUsers = true;
    };
  };

  system.activationScripts.addSecretHosts = {
    text = "cat '${config.sops.secrets.hosts.path}' >> /etc/hosts";

    deps = [
      "etc"
      "setupSecrets"
    ];
  };

  users.users.pascal = {
    description = "Pascal Diehm";
    hashedPasswordFile = config.sops.secrets.password.path;
    home = "/home/pascal";
    ignoreShellProgramCheck = true;
    isNormalUser = true;
    shell = pkgs.zsh;
    uid = 1000;

    extraGroups = [
      "docker"
      "wheel"
    ];
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings.log-driver = "local";
  };
}

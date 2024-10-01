{ pkgs, nixpkgs, ... }: {
    # Nix settings
    environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
    nixpkgs.config.allowUnfree = true;
    system.stateVersion = "24.05";

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
            experimental-features = [ "nix-command" "flakes" ];
            nix-path = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
        };
    };

    # Bootloader
    boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = true;
    };

    # User
    users.users.pascal = {
        description = "Pascal Diehm";
        extraGroups = [ "wheel" "networkmanager" ];
        initialPassword = "pascal";
        isNormalUser = true;
        uid = 1000;
    };

    # Localization
    console.keyMap = "de";
    services.xserver.xkb.layout = "de";
    time.timeZone = "Europe/Berlin";

    i18n = {
        defaultLocale = "en_US.UTF-8";

        extraLocaleSettings = {
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
    };

    # Desktop
    networking = {
        firewall.allowedTCPPorts = [ 1234 ];
        networkmanager.enable = true;
    };

    services = {
        desktopManager.plasma6.enable = true;

        displayManager.sddm = {
            enable = true;
            wayland.enable = true;
        };
    };

    # Audio
    services.pipewire = {
        enable = true;
        pulse.enable = true;

        alsa = {
            enable = true;
            support32Bit = true;
        };
    };

    # Home manager
    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
    };

    # Additional programs
    programs = {
        git.enable = true;
        nano.enable = false;
        vim.enable = true;
    };
}

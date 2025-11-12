{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      auto-optimise-store = true;
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };

    # Garbage collector
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;

    configurationLimit = 10;

    extraEntries = {
      "opensuse.conf" = ''
        title   openSUSE Tumbleweed
        efi     /EFI/opensuse/shim.efi
      '';
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Enable geoclue to find localisation
  services.geoclue2.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Configure graphical (Wayland) keymap
  # services.xserver.layout = "fr";

  ######################################
  ###           HYPRLAND             ###
  ######################################
  # Enable graphics drivers
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true; # Replaces driSupport32Bit

  # Disable SDDM
  services.displayManager.sddm.enable = false;
  services.displayManager.sddm.wayland.enable = false;

  # Enable greetd (the backend)
  services.greetd = {
    enable = true;
  };

  # Enable regreet (the frontend)
  # This module automatically sets up greetd to run regreet
  # inside a minimal Wayland compositor.
  programs.regreet = {
    enable = true;

    # These settings are automatically written to regreet's config file
    settings = {
      background = {
        color = "#1e1e2e"; # Catppuccin base color
      };
      window = {
        stylesheet = "/etc/greetd/style.css";
      };
      commands = {
        sessions = [ "Hyprland" ]; # Finds the session your config already created
      };
    };
  };

  # Link our theme file so regreet can find it
  environment.etc = {
    "greetd/style.css".source = ./style.css;
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  # XDG Portals (for screen sharing)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
  programs.hyprland.enable = true;
  programs.xwayland.enable = true;

  programs.zsh.enable = true;

  # Enable FHS-compatibility libraries for non-nix binaries
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Add any libraries your external programs might need
      stdenv.cc.cc.lib
      zlib
      openssl
    ];
  };

  # Podman
  virtualisation.podman = {
    enable = true;
    # Enable the rootless daemon for your user
    dockerSocket.enable = true;
    # Optionally, allow rootless users to use networking
    defaultNetwork.settings.dns_enabled = true;
  };

  # Fingerprint
  services.fprintd.enable = true;
  # Framework updates
  services.fwupd.enable = true;

  # Keyring
  services.gnome.gnome-keyring.enable = true;

  home-manager = {
    extraSpecialArgs = {inherit inputs; };
    users = {
      "alois" = import ../home-manager/home.nix;
    };
  };

  users.users.alois = {
    isNormalUser = true;
    description = "Aloïs";
    extraGroups = [ "networkmanager" "wheel" "video" "podman" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}

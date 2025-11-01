# This is your home-manager configuration file
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./waybar.nix
  ];

  home.stateVersion = "25.05";

  nixpkgs = {
    # You can add overlays here
    overlays = [];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # --- 1. MERGED User Packages ---
  # (from both your old and new files)
  home.packages = with pkgs; [
    steam
    firefox
    discord

    fastfetch

    # --- Software Engineering ---
    git
    zsh
    micro
    ripgrep
    bat
    eza
    vscode-fhs
    jetbrains.idea-ultimate
    kitty
    unzip
    wget
    curl
    # Nix-specific for programming
    direnv
    nix-direnv # The bridge between direnv and nix
    nixpkgs-fmt  # For formatting your .nix files

    # --- Desktop Essentials ---
    waybar       # The status bar
    dunst        # Notification daemon
    swaylock     # Screen locker
    swww         # Wallpaper utility
    wl-clipboard # Clipboard tool for Wayland
    grim slurp   # Screenshot tools (grim=grab, slurp=select)
    grimblast
    fuzzel
    btop
    brightnessctl

    # --- Theming ---
    catppuccin-gtk  # A popular GTK theme
    papirus-icon-theme # A popular icon theme
    nerd-fonts.jetbrains-mono
    font-awesome

  ];

  programs.direnv = {
    enable = true;
    # This automatically loads flakes
    nix-direnv.enable = true;
  };

  # --- ZSH and Oh My Zsh Configuration ---
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # This block sets up Oh My Zsh
    oh-my-zsh = {
      enable = true;
      theme = "gnzh";
      plugins = [ "git" "sudo" "z" "you-should-use" ];
    };

    # This block is for your aliases
    shellAliases = {
      myip = "curl http://ipecho.net/plain; echo";
      c = "clear";
      img = "kitten icat";
      grep = "rg";
      cat = "bat";
      ls = "eza";
      nano = "micro";
    };

    # This block holds all your custom startup scripts
    initContent = ''
      # --- Fastfetch ---
      fastfetch
    '';
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Forces Electron apps (VSCode, etc.) to use Wayland
    _JAVA_AWT_WM_NONREPARENTING = "1"; # Fix for Java apps (IntelliJ)
    GDK_BACKEND = "wayland"; # For GTK apps
    QT_QPA_PLATFORM = "wayland"; # For Qt apps
  };

  # --- 3. COPIED from old file: Your Hyprland Config ---
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # This is the correct way to pass settings in Home Manager
    settings = {

      xwayland = {
        force_zero_scaling = true;
      };

      # --- Main Modifier Key ---
      "$mainMod" = "SUPER";

      # --- Input Devices (Fix Scrolling & AZERTY) ---
      input = {
        kb_layout = "fr";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };

      # --- Autostart Programs ---
      exec-once = [
        "waybar"           # Start the bar
        "dunst"            # Start the notification daemon
        "swww-daemon"      # Start the wallpaper daemon
        # Set a wallpaper (replace with your path)
        "swww img ~/Documents/nix-config/wallpapers/porco_rosso.jpg"
        # Start a terminal
        "kitty"
      ];

      # --- Keybindings ---
      bind = [
        # App Launcher
        "$mainMod, Space, exec, fuzzel"

        # Terminal
        "$mainMod, Return, exec, kitty" # Use SUPER + Enter for terminal

        # Close window (W on AZERTY)
        "$mainMod, W, killactive,"

        # Workspaces (AZERTY)
        "$mainMod, ampersand, workspace, 1"
        "$mainMod, eacute, workspace, 2"
        "$mainMod, quotedbl, workspace, 3"
        "$mainMod, apostrophe, workspace, 4"
        "$mainMod, parenleft, workspace, 5"
        "$mainMod, minus, workspace, 6"
        "$mainMod, egrave, workspace, 7"
        "$mainMod, underscore, workspace, 8"
        "$mainMod, ccedilla, workspace, 9"

        # Move window to workspace (AZERTY)
        "$mainMod SHIFT, ampersand, movetoworkspace, 1"
        "$mainMod SHIFT, eacute, movetoworkspace, 2"
        "$mainMod SHIFT, quotedbl, movetoworkspace, 3"
        "$mainMod SHIFT, apostrophe, movetoworkspace, 4"
        "$mainMod SHIFT, parenleft, movetoworkspace, 5"
        "$mainMod SHIFT, minus, movetoworkspace, 6"
        "$mainMod SHIFT, egrave, movetoworkspace, 7"
        "$mainMod SHIFT, underscore, movetoworkspace, 8"
        "$mainMod SHIFT, ccedilla, movetoworkspace, 9"

        # Set brightness
        ", XF86MonBrightnessUp,   exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"


        # Screenshots
        # F11: Copy entire screen to clipboard
        ", F11, exec, grimblast copy screen"

        # Shift + F11: Select an area to copy to clipboard
        "SHIFT, F11, exec, grimblast copy area"

        # Ctrl + F11: Copy the active window to clipboard
        "CTRL, F11, exec, grimblast copy active"
      ];
    };
  };

  # --- Enable Services ---

  programs.ssh = {
    enable = true;

    # This will create ~/.ssh/config with proper permissions
    matchBlocks = {
      # GitHub configuration
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        addKeysToAgent = "yes";
      };
    };
  };

  # Enable the notification daemon
  services.dunst = {
    enable = true;
    settings = {
      global = {
        format = "<b>%s</b>\n%b";
        font = "Noto Sans 10";
      };
    };
  };

  # --- Theming ---
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-dark"; # Theme from catppuccin-gtk
      package = pkgs.catppuccin-gtk.override { variant = "mocha"; };
    };
    iconTheme = {
      name = "Papirus-Dark"; # Theme from papirus-icon-theme
      package = pkgs.papirus-icon-theme;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Alois";
        email = "your-email@example.com";
      };
    };
  };

  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12.0;
    };

    # This section is for all other settings
    settings = {
      background_opacity = 0.9;

      bold_italic_font = "JetBrainsMono Nerd Font:style=ExtraBold Italic";
    };
  };

}

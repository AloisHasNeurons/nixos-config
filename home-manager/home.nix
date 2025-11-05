{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.stateVersion = "25.05";

  imports = [
    ./waybar.nix
    ./hyprland.nix
    ./kitty.nix
    ./dunst.nix
    ./fuzzel.nix
    ./gtk.nix
    ./swaylock.nix
    ./wlogout.nix
  ];

  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home.packages = with pkgs; [
    # --- System & Utils ---
    steam
    firefox
    discord
    fastfetch
    tldr
    btop
    brightnessctl
    wl-clipboard
    unzip
    wget
    curl

    # --- Dev Tools ---
    git
    zsh
    micro
    ripgrep
    bat
    eza
    vscode
    direnv
    nix-direnv
    nixpkgs-fmt
    distrobox

    # --- Hyprland Ecosystem ---
    waybar
    dunst
    swww
    grim slurp
    grimblast
    fuzzel
    wlogout
    swayidle
    swaylock-effects

    pkgs.xfce.thunar    # File manager
    pkgs.xfce.tumbler   # For thumbnails in thunar
    pamixer             # For audio/volume control
    playerctl           # For media (play/pause/next) control

    # --- Theming ---
    catppuccin-gtk
    papirus-icon-theme
    catppuccin-cursors
    nerd-fonts.jetbrains-mono
    font-awesome
  ];


  # --- ZSH, Git, Direnv ---
  # (These are small and fine to keep in home.nix)

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "gnzh";
      plugins = [ "git" "sudo" "z" "you-should-use" ];
    };
    shellAliases = {
      myip = "curl http://ipecho.net/plain; echo";
      c = "clear";
      img = "kitten icat";
      grep = "rg";
      cat = "bat";
      ls = "eza";
      nano = "micro";
      tree = "eza --tree --no-git";
      "cd.." = "cd ..";
    };
    initContent = ''
      # --- Fastfetch ---
      fastfetch
    '';
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Alois";
        email = "alois.vincent@imt-atlantique.net";
      };
    };
  };

  # --- Session Variables ---
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
  };

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
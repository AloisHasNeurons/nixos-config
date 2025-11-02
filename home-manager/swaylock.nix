# home-manager/swaylock.nix
{ pkgs, ... }:

{
  # Add a keybind in hyprland.nix for this
  # We'll bind SUPER + L
  wayland.windowManager.hyprland.settings.bind = [
    "SUPER, L, exec, swaylock -f"
  ];

  # Configure swaylock-effects
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects; # Use the -effects fork
    settings = {
      # Catppuccin Mocha theme for swaylock
      color = "1e1e2e"; # Base
      line-color = "181825"; # Mantle
      ring-color = "b4befe"; # Lavender
      text-color = "cdd6f4"; # Text
      inside-color = "313244"; # Surface0
      key-hl-color = "f5c2e7"; # Pink
      separator-color = "00000000"; # Transparent

      image = "~/Documents/nix-config/wallpapers/porco_rosso.jpg";
      scaling = "fill";

      blur = "7x5";
      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 10;
    };
  };

  # Configure swayidle
  # Configure swayidle
  services.swayidle = {
    enable = true;

    # 'events' is for specific signals like 'before-sleep'
    events = [
      # Example: { event = "before-sleep"; command = "swaylock -f"; }
      # We don't have any of these right now, but this is where they'd go.
    ];

    # 'timeouts' is for idle durations
    timeouts = [
      {
        timeout = 300; # 5 minutes
        command = "swaylock -f";
      }
      {
        timeout = 600; # 10 minutes (5 + 5)
        command = "hyprctl dispatch dpms off";
        # This command runs when you resume from *this* timeout
        resumeCommand = "hyprctl dispatch dpms on";
      }
    ];
  };
}
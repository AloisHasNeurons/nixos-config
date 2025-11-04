# home-manager/hyprland.nix
{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    # Use settings from your waybar.nix for colors
    settings = let
      # Catppuccin Mocha Colors
      mocha-base = "1e1e2e";
      mocha-surface0 = "313244";
      mocha-blue = "89b4fa";
      mocha-lavender = "b4befe";
    in {

      # --- Main Modifier Key ---
      "$mainMod" = "SUPER";

      # --- Autostart Programs ---
      exec-once = [
        "waybar"           # Start the bar
        "dunst"            # Start the notification daemon
        "swww-daemon"      # Start the wallpaper daemon
        # Set a wallpaper (replace with your path)
        "swww img ~/Documents/nix-config/wallpapers/porco_rosso.jpg"
      ];

      # --- Input Devices (Fix Scrolling & AZERTY) ---
      input = {
        kb_layout = "fr";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };

      # --- Gaps, Borders, and Rounding ---
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgb(${mocha-lavender})";
        "col.inactive_border" = "rgb(${mocha-surface0})";
        layout = "dwindle";
      };

      # --- Decoration (Rounding, Blur, Shadow) ---
      decoration = {
        rounding = 10;

        # --- Blur ---
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        # --- Shadows ---
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(11111b99)";
        };
      };

      # --- Animations ---
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # --- Window Rules ---
      # Make the file manager float
      windowrulev2 = "float, class:^(thunar)$";

      # --- Keybindings ---
      bind = [
        # --- App Launchers ---
        "$mainMod, Space, exec, fuzzel"
        "$mainMod, Return, exec, kitty"
        "$mainMod, F, exec, thunar" # Your bind for files

        # --- Window Management ---
        "$mainMod, W, killactive," # Close window (W on AZERTY)
        "$mainMod, M, fullscreen" # Toggle fullscreen
        "$mainMod, V, togglefloating" # Toggle floating

        # --- System ---
        "$mainMod, Escape, exec, wlogout" # Power Menu
        "$mainMod, L, exec, swaylock -f -C /home/alois/.config/swaylock/config" # Lock screen
        # --- Workspaces (AZERTY) ---
        "$mainMod, ampersand, workspace, 1"
        "$mainMod, eacute, workspace, 2"
        "$mainMod, quotedbl, workspace, 3"
        "$mainMod, apostrophe, workspace, 4"
        "$mainMod, parenleft, workspace, 5"
        "$mainMod, minus, workspace, 6"
        "$mainMod, egrave, workspace, 7"
        "$mainMod, underscore, workspace, 8"
        "$mainMod, ccedilla, workspace, 9"

        # --- Move window to workspace (AZERTY) ---
        "$mainMod SHIFT, ampersand, movetoworkspace, 1"
        "$mainMod SHIFT, eacute, movetoworkspace, 2"
        "$mainMod SHIFT, quotedbl, movetoworkspace, 3"
        "$mainMod SHIFT, apostrophe, movetoworkspace, 4"
        "$mainMod SHIFT, parenleft, movetoworkspace, 5"
        "$mainMod SHIFT, minus, movetoworkspace, 6"
        "$mainMod SHIFT, egrave, movetoworkspace, 7"
        "$mainMod SHIFT, underscore, movetoworkspace, 8"
        "$mainMod SHIFT, ccedilla, movetoworkspace, 9"

        # --- YOUR NEW F-KEY BINDS (Media/Device) ---

        # F1: Mute
        ", F1, exec, pamixer --toggle-mute"
        # F2: Volume Down
        ", F2, exec, pamixer --decrease 5"
        # F3: Volume Up
        ", F3, exec, pamixer --increase 5"
        # F4: Previous
        ", F4, exec, playerctl previous"
        # F5: Play/Pause
        ", F5, exec, playerctl play-pause"
        # F6: Next
        ", F6, exec, playerctl next"
        # F7: Brightness Down
        ", F7, exec, brightnessctl set 5%-"
        # F8: Brightness Up
        ", F8, exec, brightnessctl set 5%+"
        # F9: (Suggestion: Toggle blur for performance)
        ", F9, exec, hyprctl keyword decoration:blur:enabled !decoration:blur:enabled"
        # F10: Airplane Mode (Toggles WiFi/Bluetooth)
        ", F10, exec, rfkill toggle all"

        # --- Screenshots (from your old config) ---
        # F11: Copy screen
        ", F11, exec, grimblast copy screen"
        # Shift + F11: Copy area
        "SHIFT, F11, exec, grimblast copy area"
        # Ctrl + F11: Copy active window
        "CTRL, F11, exec, grimblast copy active"

        # F12: (Suggestion: Toggle gaps on/off)
        ", F12, exec, hyprctl keyword general:gaps_in 0 && hyprctl keyword general:gaps_out 0"
        "SHIFT, F12, exec, hyprctl keyword general:gaps_in 5 && hyprctl keyword general:gaps_out 10"
      ];
    };
  };
}
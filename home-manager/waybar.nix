# ~/Documents/nix-config/home-manager/waybar.nix
{ pkgs, ... }:

{
  # Add the nerd fonts just for this module
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  font-awesome # Fallback font
  ];
  programs.waybar = {
    enable = true;

    # This is the main config file
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4; # Adds a small gap between modules

        # Module order
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [
          "tray"
          "pulseaudio"
          "network"
          "battery"
          "memory"
          "cpu"
        ];

        # --- Module Settings ---
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "󰎦";
            "2" = "󰎩";
            "3" = "󰎬";
            "4" = "󰎮";
            "5" = "󰎰";
            "6" = "󰎳";
            "7" = "󰎶";
            "8" = "󰎹";
            "9" = "󰎼";
            "default" = "";
            "urgent" = "";
          };
          on-click = "activate";
        };
        "hyprland/window" = {
          format = "{}"; # Shows the active window title
          max-length = 25;
        };
        clock = {
          format = " {:%H:%M}";
          format-alt = " {:%d/%m/%Y}";
        };
        battery = {
          format = "{capacity}% {icon}";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          format-charging = "{capacity}% 󰂄";
          format-plugged = "{capacity}% 󰂄";
          states = {
            warning = 30;
            critical = 15;
          };
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "󰊗";
          format-disconnected = "󰖪";
        };
        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            default = [ "" ];
          };
          scroll-step = 5;
        };
        tray = {
          icon-size = 18;
          spacing = 10;
        };
        cpu = {
          format = "  {usage}%";
        };
        memory = {
          format = "󰍛 {used:0.1f}G";
        };
      };
    };

    # This is the CSS styling
    style = ''
      /* --- Define Catppuccin Mocha Colors --- */
      @define-color base   #1e1e2e;
      @define-color mantle #181825;
      @define-color crust  #11111b;
      @define-color text   #cdd6f4;
      @define-color subtext0 #a6adc8;
      @define-color overlay2 #9399b2;
      @define-color surface0 #313244;
      @define-color surface1 #45475a;
      @define-color surface2 #585b70;
      @define-color blue     #89b4fa;
      @define-color lavender #b4befe;
      @define-color sapphire #74c7ec;
      @define-color sky      #89dceb;
      @define-color teal     #94e2d5;
      @define-color green    #a6e3a1;
      @define-color yellow   #f9e2af;
      @define-color peach    #fab387;
      @define-color maroon   #eba0ac;
      @define-color red      #f38ba8;
      @define-color pink     #f5c2e7;

      * {
        font-family: "JetBrainsMono Nerd Font", FontAwesome, sans-serif;
        font-size: 14px;
        border: none;
        border-radius: 0;
      }

      /* --- Main Bar --- */
      window#waybar {
        background-color: rgba(30, 30, 46, 0.7); /* Catppuccin Base @ 70% opacity */
        color: @text;
        border-bottom: 2px solid @surface0;
      }

      /* --- All Modules --- */
      #workspaces,
      #hyprland-window,
      #clock,
      #battery,
      #network,
      #pulseaudio,
      #tray,
      #cpu,
      #memory {
        background-color: @surface0;
        color: @text;
        padding: 0 10px;
        margin: 4px 0px; /* Vertical margin */
        border-radius: 8px;
      }

      /* --- Workspaces --- */
      #workspaces button {
        padding: 0 5px;
        color: @overlay2;
        background-color: transparent;
      }
      #workspaces button:hover {
        background-color: @surface1;
        color: @text;
        border-radius: 4px;
      }
      #workspaces button.active {
        color: @blue;
      }
      #workspaces button.urgent {
        color: @red;
      }

      /* --- Specific Module Colors --- */
      #clock {
        background-color: @lavender;
        color: @base;
      }
      #battery {
        background-color: @green;
        color: @base;
      }
      #battery.charging, #battery.plugged {
        background-color: @green;
      }
      #battery.critical:not(.charging) {
        background-color: @red;
      }
      #network {
        background-color: @blue;
        color: @base;
      }
      #network.disconnected {
        background-color: @surface1;
        color: @text;
      }
      #pulseaudio {
        background-color: @peach;
        color: @base;
      }
      #pulseaudio.muted {
        background-color: @surface1;
        color: @text;
      }
      #cpu {
        background-color: @pink;
        color: @base;
      }
      #memory {
        background-color: @sky;
        color: @base;
      }
      #tray {
        background-color: @surface1;
      }
      #hyprland-window {
        background-color: transparent;
      }
    '';
  };
}
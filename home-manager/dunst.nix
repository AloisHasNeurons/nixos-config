# home-manager/dunst.nix
{ ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      # Catppuccin Mocha theme for Dunst
      global = {
        # Looks
        font = "JetBrainsMono Nerd Font 10";
        format = "<b>%s</b>\n%b";
        icon_theme = "Papirus-Dark";

        # Geometry
        width = 300;
        height = 100;
        origin = "top-right";
        offset = "10x50"; # 10px from right, 50px from top

        # Colors
        frame_color = "#89b4fa"; # Blue
        separator_color = "#89b4fa";
      };

      urgency_low = {
        background = "#1e1e2e"; # Base
        foreground = "#cdd6f4"; # Text
        timeout = 5;
      };

      urgency_normal = {
        background = "#1e1e2e"; # Base
        foreground = "#cdd6f4"; # Text
        timeout = 10;
      };

      urgency_critical = {
        background = "#f38ba8"; # Red
        foreground = "#1e1e2e"; # Base
        frame_color = "#eba0ac"; # Maroon
        timeout = 0;
      };
    };
  };
}
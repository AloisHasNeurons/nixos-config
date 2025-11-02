# home-manager/fuzzel.nix
{ ... }:

{
  programs.fuzzel = {
    enable = true;
    # Catppuccin Mocha theme for Fuzzel
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        lines = 10;
        width = 30;
        horizontal-pad = 20;
        vertical-pad = 20;
        inner-pad = 5;
        icons-enabled = true;
        terminal = "kitty"; # Use your terminal
      };

      border = {
        width = 2;
        radius = 10;
        color = "89b4faff"; # Blue
      };

      colors = {
        background = "1e1e2eff"; # Base
        text = "cdd6f4ff"; # Text
        match = "f5c2e7ff"; # Pink
        selection = "313244ff"; # Surface0
        selection-text = "89b4faff"; # Blue
      };
    };
  };
}
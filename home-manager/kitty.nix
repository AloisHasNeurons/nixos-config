# home-manager/kitty.nix
{ ... }:

{
  programs.kitty = {
    enable = true;

    # Apply the built-in Catppuccin Mocha theme
    themeFile = "Catppuccin-Mocha";

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12.0;
    };
    settings = {
      background_opacity = "0.9";
      # Your other custom settings
      bold_italic_font = "JetBrainsMono Nerd Font:style=ExtraBold Italic";
    };
  };
}
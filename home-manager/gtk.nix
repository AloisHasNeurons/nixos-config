# home-manager/gtk.nix
{ pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-dark";
      package = pkgs.catppuccin-gtk.override { variant = "mocha"; };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Set the cursor theme
  home.pointerCursor = {
    name = "Catppuccin-Mocha-Dark"; # This name is correct
    package = pkgs.catppuccin-cursors; # Just install the base package
    size = 24;
    gtk.enable = true; # Apply to GTK apps
  };
}
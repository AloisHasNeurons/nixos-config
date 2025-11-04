# home-manager/gtk.nix
{ pkgs, ... }:

{
  # --- Enable the GTK modules ---
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

  # --- Set the cursor theme ---
  home.pointerCursor = {
    name = "Catppuccin-Mocha-Dark";
    package = pkgs.catppuccin-cursors;
    size = 24;
    gtk.enable = true;
  };

  # --- NEW: Force apps to use the dark theme ---
  # This is the most reliable way to apply GTK themes
  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      "color-scheme" = "prefer-dark";
      "gtk-theme" = "Catppuccin-Mocha-Standard-Blue-dark";
      "icon-theme" = "Papirus-Dark";
    };
  };
}
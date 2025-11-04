# home-manager/wlogout.nix
{ ... }:

{
  # This links the files into your .config directory
  # It's more reliable than home.file
  xdg.configFile = {
    "wlogout/layout.json" = {
      source = ./wlogout-config/layout.json;
      force = true; # Keep forcing, just in case
    };
    "wlogout/style.css" = {
      source = ./wlogout-config/style.css;
      force = true; # Keep forcing, just in case
    };
  };
}
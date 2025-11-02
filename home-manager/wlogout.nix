# home-manager/wlogout.nix
{ ... }:

{
  # This tells Home Manager to create these files in your .config
  home.file = {
    ".config/wlogout/layout.json" = {
      source = ./wlogout-config/layout.json;
    };
    ".config/wlogout/style.css" = {
      source = ./wlogout-config/style.css;
    };
  };
}
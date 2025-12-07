{
  modulesPath,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    #./modules/hyprland.nix
    ./modules/foot.nix
    ./modules/nushell.nix
    #./modules/caelestia.nix
    ./modules/yazi.nix
    ./modules/dms.nix
    ./modules/niri.nix
    ./modules/zellij.nix
  ];

  home = {
    username = "teth-io";
    homeDirectory = "/home/teth-io";
    stateVersion = "25.11";

    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Ice";
      size = 20;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  # theme
  qt = {
    enable = true;
    platformTheme.name = "gtk"; #et pas gtk3 sinon bug des tray icons
  };
  gtk = {
    enable = true;
    font = {
      name = "Inter";
      size = 11;
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Ice";
      size = 24;
    };
  };
}

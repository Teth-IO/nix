{
  modulesPath,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./modules/foot.nix
    ./modules/nushell.nix
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

    packages = with pkgs; [ xwayland-satellite ];
  };

  # theme
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
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

  # desktopEntries pour ajouter des entree dans l'app launcher
  xdg.desktopEntries = {
    # steam avec -system-composer pour niri
    steam = {
      name = "Steam";
      genericName = "Steam niri";
      exec = "steam -system-composer %U";
      terminal = false;
      #categories = [ "Game" ];
    };
    xnviewmp = {
      name = "XnView MP";
      genericName = "Image viewer";
      exec = "xnviewmp %U";
      terminal = false;
      #categories = [ "Graphics" ];
    };
  };

  # rofi
  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "drun";
      display-drun = " Apps";
      hover-select = true;
    };
  };

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        useGrimAdapter = true;
        disabledTrayIcon = true;
        disabledGrimWarning = true;
      };
    };
  };
}

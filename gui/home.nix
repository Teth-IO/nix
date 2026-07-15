{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./modules/foot.nix
    inputs.nix-doom-emacs-unstraightened.homeModule
  ];

  home = {
    username = "teth-io";
    homeDirectory = "/home/teth-io";
    stateVersion = "25.11";
    enableNixpkgsReleaseCheck = false;

    pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Ice";
      size = 20;
      gtk.enable = true;
      x11.enable = true;
    };

    packages = with pkgs; [ xwayland-satellite ];
  };

  # theme qt/gtk (police, icones, ...)
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
  gtk = {
    enable = true;
    font = {
      name = "Inter";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    gtk4.theme = null;
  };

# xdg.desktopEntries = {
#   # Entrée l'AppImage Librewolf 
#   Librewolf = {
#     name = "Librewolf";
#     exec = "appimage-run /home/teth-io/ownCloud/Personal/librewolf.AppImage %U";
#     icon = "librewolf";
#     terminal = false;
#   };
# };
 
  # doom emacs https://github.com/marienz/nix-doom-emacs-unstraightened
  programs.doom-emacs = {
    enable = true;
  };

  # flameshot
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

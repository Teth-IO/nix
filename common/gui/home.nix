{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    #./modules/hyprland.nix
    ./modules/foot.nix
    #./modules/nushell.nix
    #./modules/caelestia.nix
    #./modules/yazi.nix
    #./modules/dms.nix
    #./modules/zellij.nix
    ./modules/noctalia.nix
    inputs.nix-doom-emacs-unstraightened.homeModule
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

  # theme qt/gtk (police, cuseur et icones)
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
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Ice";
      size = 24;
    };
  };

  # desktopEntries pour ajouter des entree dans l'app launcher
  xdg.desktopEntries = {
    # missing entries 
    xnviewmp = {
      name = "XnView MP";
      exec = "xnviewmp %U";
      icon = "xnviewmp";
      terminal = false;
    };
    # platform xcb pour l'autotype
    keepassxc = {
      name = "KeePassXC xcb";
      exec = "keepassxc -platform xcb %U";
      icon = "keepassxc";
      terminal = false;
    };
  };

  # fuzzel theme https://github.com/kuripa/oxocarbon-fuzzel
  programs.fuzzel = {
    enable = true;
    settings = {
      colors = {
        background = "161616ff";
        text = "ffffffff";
        match = "ee5396ff";
        selection-match = "ee5396ff";
        selection = "262626ff";
        selection-text = "33b1ffff";
        border = "525252ff";
      };
    };
  };

  # doom emacs https://github.com/marienz/nix-doom-emacs-unstraightened
  programs.doom-emacs = {
    enable = true;
    doomDir = ./modules/doom.d;  # ou inputs.doom-config si la conf vie dans un repo qu'on peut import avec doom-config.url = "..."; dans les flake inputs
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

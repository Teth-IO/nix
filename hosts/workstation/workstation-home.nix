{
  ...
}:
{
  imports = [
    ./home/niri.nix
    ../../gui/home.nix
  ];

  # desktopEntries pour ajouter des entree dans l'app launcher
  xdg.desktopEntries = {
    # steam avec -system-composer pour niri
    steam = {
      name = "Steam niri";
      exec = "steam -system-composer %U";
      icon = "steam";
      terminal = false;
    };
  };
}

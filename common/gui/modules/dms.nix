{
  inputs,
  ...
}:
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
  ];

  programs.dank-material-shell = {
    enable = true;
    niri = {
      enableKeybinds = false;   # Automatic keybinding configuration
      enableSpawn = true;      # Auto-start DMS with niri
    };
    niri.includes = {
      enable = false;
    };
    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    enableVPN = false;                  # VPN management widget
    enableDynamicTheming = false;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;      # Audio visualizer (cava)
    enableCalendarEvents = true;       # Calendar integration (khal)
  };
}

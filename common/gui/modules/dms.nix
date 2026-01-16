{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.dms.homeModules.dankMaterialShell.default
    inputs.dms.homeModules.dankMaterialShell.niri
  ];

  programs.dankMaterialShell = {
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

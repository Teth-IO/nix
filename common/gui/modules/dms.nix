{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
  ];

  programs.dankMaterialShell = {
    enable = true;
    niri = {
      enableKeybinds = true;   # Automatic keybinding configuration
      enableSpawn = true;      # Auto-start DMS with niri
    };
    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    enableClipboard = false;            # Clipboard history manager
    enableVPN = false;                  # VPN management widget
    enableBrightnessControl = true;    # Backlight/brightness controls
    enableColorPicker = false;          # Color picker tool
    enableDynamicTheming = false;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;      # Audio visualizer (cava)
    enableCalendarEvents = true;       # Calendar integration (khal)
    enableSystemSound = false;          # System sound effects 
  };
}

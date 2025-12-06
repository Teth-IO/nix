{
  config,
  pkgs,
  inputs,
  ...
}:
{

  imports = [inputs.niri.homeModules.niri];

  programs.niri = {
    enable = true;
    settings = {
      environment = {
        CLUTTER_BACKEND = "wayland";
        DISPLAY = null;
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER = "wayland";
        WLR_RENDERER = "vulkan";
        WLR_NO_HARDWARE_CURSORS = "1";
        QT_QPA_PLATFORMTHEME = "qt6ct";
        GTK_IM_MODULE = "simple";
      };
      input = {
        touchpad = {
          click-method = "button-areas";
          dwt = true;
          dwtp = true;
          natural-scroll = true;
          scroll-method = "two-finger";
          tap = true;
          tap-button-map = "left-right-middle";
          middle-emulation = true;
          accel-profile = "adaptive";
        };
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "90%";
        };
        warp-mouse-to-focus.enable = true;
        workspace-auto-back-and-forth = true;
      };
      screenshot-path = "~/Pictures/Screenshots/Screenshot-from-%Y-%m-%d-%H-%M-%S.png";
      outputs = {
        "eDP-1" = {
          scale = 2.0;
        };
      };
      gestures = {
        hot-corners.enable = true;
      };
      layout = {
        focus-ring.enable = false;
        preset-column-widths = [
          {proportion = 0.25;}
          {proportion = 0.5;}
          {proportion = 0.75;}
          {proportion = 1.0;}
        ];
        default-column-width = {proportion = 0.5;};
        gaps = 6;
        tab-indicator = {
          hide-when-single-tab = true;
          place-within-column = true;
          position = "left";
          corner-radius = 20.0;
          gap = -12.0;
          gaps-between-tabs = 10.0;
          width = 4.0;
          length.total-proportion = 0.1;
        };
      };
      hotkey-overlay.skip-at-startup = true;
      binds = with config.lib.niri.actions; {
        "Mod+Left".action = focus-column-left;
        "Mod+Down".action = focus-window-down;
        "Mod+Up".action = focus-window-up;
        "Mod+Right".action = focus-column-right;
        "Mod+Ctrl+Left".action = set-column-width "+10%";
        "Mod+Ctrl+Down".action = set-window-height "-10%";
        "Mod+Ctrl+Up".action = set-window-height "+10%";
        "Mod+Ctrl+Right".action = set-column-width "-10%";
        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Right".action = move-column-right;
        "Mod+Shift+Up".action = move-column-to-workspace-up;
        "Mod+Shift+Down".action = move-column-to-workspace-down;
        "Mod+Q".action = close-window;
        "Mod+S".action = switch-preset-column-width;
        "Mod+F".action = maximize-column;
        "Mod+L".action = spawn-sh "dms ipc call lock lock";
        "Mod+Return".action = spawn "foot";
        "Print".action.screenshot-screen = {write-to-disk = true;};
      };
    };
  };
}

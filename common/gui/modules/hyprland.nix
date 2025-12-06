{
  pkgs,
  config,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    hyprshot
    hyprpicker
    hyprpolkitagent
    wl-clipboard
    cliphist
  ];

  wayland.windowManager.hyprland = {
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    enable = true;
    xwayland.enable = true;

    settings = {
      "$mod" = "SUPER";
      "$shiftMod" = "SUPER_SHIFT";

      bind = [
        "$mod, RETURN, exec, kitty"
        "$mod, Q, killactive"
        "$mod, W, togglefloating"
        "$mod, G, fullscreen"
        "$mod, SPACE, exec, caelestia shell drawers toggle launcher "
        "$mod, L, exec, caelestia shell lock lock "

        ", Print, exec, hyprshot -m output"
        "SHIFT, Print, exec, hyprshot -m region"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        # Thinkpad
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
        ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
        ", XF86AudioMute, exec, noctalia-shell ipc call volume muteOutpute"

      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      exec-once = [
        "caelestia-shell & caelestia shell lock lock && owncloud"
      ];

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "__GL_GSYNC_ALLOWED,0"
        "__GL_VRR_ALLOWED,0"
        "QT_QPA_PLATFORM,wayland"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "XCURSOR_SIZE,24"
        "NIXOS_OZONE_WL,1"
        "WLR_NO_HARDWARE_CURSORS,1"
      ];

      general = {
        resize_on_border = true;
        layout = "dwindle";
        "col.inactive_border" = "rgb(595959)";
        gaps_in = 0;
        gaps_out = 10;
        border_size = 0;
        allow_tearing = true;
      };

      decoration = {
        active_opacity = 1;
        inactive_opacity = 1;
        rounding = 12;
        blur = {
          enabled = true;
          size = 18;
          passes = 3;
        };
        shadow = {
          enabled = true;
          range = 20;
        };
      };

      cursor = {
        no_hardware_cursors = true;
        default_monitor = "HDMI-A-1";
      };

      input = {
        kb_layout = "us";
        kb_options = "grp:alt_shift_toggle";
        follow_mouse = 1;
      };

      animations = {
        enabled = true;
        bezier = [
          "easein, 0.11, 0, 0.5, 0"
          "easeout, 0.5, 1, 0.89, 1"
          "easeinout, 0.65, 0, 0.35, 1"
        ];
        animation = [
          "windows, 1, 3, easeout, slide"
          "windowsOut, 1, 3, easein, slide"
          "border, 1, 10, default"
          "fade, 1, 5, default"
          "workspaces, 1, 4, easeinout, slide"
        ];
      };

      misc = {
        disable_hyprland_logo = true;
      };
    };
  };
}

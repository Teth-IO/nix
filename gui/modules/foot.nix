{
  lib,
  pkgs,
  ...
}:
{
  home.packages = [pkgs.libsixel];
  programs.foot = {
    enable = true;
    settings = {
      main = {
        #term = "xterm-256color";
        shell = "fish";
        font = "BlexMono Nerd Font:size=9:fontfeatures=calt:fontfeatures=dlig:fontfeatures=fbarc:fontfeatures=liga";
        dpi-aware = "yes";
        horizontal-letter-offset = 0;
        vertical-letter-offset = 0;
        pad = "0x0";
        selection-target = "clipboard";
        bold-text-in-bright = "true";
      };
      desktop-notifications.command = "${lib.getExe pkgs.libnotify} -a \${app-id} -i \${app-id} \${title} \${body}";
      scrollback = {
        lines = 10000;
        multiplier = 3;
        indicator-position = "relative";
        indicator-format = "line";
      };
      url = {
        launch = "${pkgs.xdg-utils}/bin/xdg-open \${url}";
        label-letters = "sadfjklewcmpgh";
        osc8-underline = "url-mode";
      };
      cursor = {
        style = "beam";
        beam-thickness = "2";
      };
      tweak = {
        font-monospace-warn = "no";
        sixel = "yes";
      };
      colors-dark = {
        background = "1b1b1b";
        foreground = "ffffff";
      
        # normal
        regular0 = "161616";
        regular1 = "ee5396";
        regular2 = "42be65";
        regular3 = "ff7eb6";
        regular4 = "33b1ff"; # background color des apps en TUI
        regular5 = "be95ff";
        regular6 = "3ddbd9";
        regular7 = "ffffff";
      
        # bright
        bright0 = "525252";
        bright1 = "ee5396";
        bright2 = "42be65";
        bright3 = "ff7eb6";
        bright4 = "33b1ff";
        bright5 = "be95ff";
        bright6 = "3ddbd9";
        bright7 = "ffffff";
      };
    };
  };
}

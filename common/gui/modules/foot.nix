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
        background = "101421";
        foreground = "fffbf6";
      
        # normal
        regular0 = "2e2e2e";
        regular1 = "eb4129";
        regular2 = "abe047";
        regular3 = "f6c744";
        regular4 = "47a0f3"; # background color des apps en TUI
        regular5 = "7b5cb0";
        regular6 = "64dbed";
        regular7 = "e5e9f0";
      
        # bright
        bright0 = "565656";
        bright1 = "ec5357";
        bright2 = "c0e17d";
        bright3 = "f9da6a";
        bright4 = "49a4f8";
        bright5 = "a47de9";
        bright6 = "99faf2";
        bright7 = "ffffff";
      };
    };
  };
}

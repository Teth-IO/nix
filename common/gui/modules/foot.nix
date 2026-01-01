{
  config,
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
        shell = "nu";
        font = "BlexMono Nerd Font:size=9:fontfeatures=calt:fontfeatures=dlig:fontfeatures=fbarc:fontfeatures=liga";
        dpi-aware = "yes";
        horizontal-letter-offset = 0;
        vertical-letter-offset = 0;
        pad = "0x0";
        selection-target = "clipboard";
        #bold-text-in-bright = "true";
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
      colors = {
        # kanso zen
        alpha = 1.0;
        background = "090E13";
        foreground = "C5C9C7";
        selection-background = "22262d";
        selection-foreground = "C5C9C7";
        urls = "72A7BC";

        # normal
        regular0 = "090e13";
        regular1 = "c4746e";
        regular2 = "8a9a7b";
        regular3 = "c4b28a";
        regular4 = "8ba4b0";
        regular5 = "a292a3";
        regular6 = "8ea4a2";
        regular7 = "a4a7a4";

        # bright
        bright0 = "5c6066";
        bright1 = "E46876";
        bright2 = "87a987";
        bright3 = "E6C384";
        bright4 = "7FB4CA";
        bright5 = "938AA9";
        bright6 = "7AA89F";
        bright7 = "C5C9C7";
      };
    };
  };
}

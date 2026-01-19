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
      colors = {
        ## couleur zenburn pour app TUI
        background = "111111";
        foreground = "dcdccc";
      
        # normal
        regular0 = "222222";
        regular1 = "cc9393";
        regular2 = "7f9f7f";
        regular3 = "d0bf8f";
        regular4 = "6ca0a3"; # background color des apps en TUI
        regular5 = "dc8cc3";
        regular6 = "93e0e3";
        regular7 = "dcdccc";
      
        # bright
        bright0 = "666666";
        bright1 = "dca3a3";
        bright2 = "bfebbf";
        bright3 = "f0dfaf";
        bright4 = "8cd0d3";
        bright5 = "fcace3";
        bright6 = "b3ffff";
        bright7 = "ffffff";
      };
    };
  };
}

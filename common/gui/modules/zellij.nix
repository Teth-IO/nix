{
  programs.zellij = {
    enable = true;
    settings = {
      theme = "kanso";
      default_shell = "nu";
      ui = {
        pane_frames = {
          hide_session_name = true;
        };
      };
      pane_frames = false;
      tab_bar = false;
      #default_layout = "compact";
      show_startup_tips = false;
      show_release_notes = false;
      themes = {
        kanso = {
          bg = "#090E13";
          fg = "#C5C9C7";
          red	= "#C4746E";
          green	= "#8A9A7B";
          blue = "#8BA4B0";
          yellow = "#C4B28A";
          magenta = "#A292A3";
          orange	= "#B98D7B";
          cyan = "#8EA4A2";
          black	= "#090E13";
          white	= "#C5C9C7" ;
        };
      };
    };
  };
}

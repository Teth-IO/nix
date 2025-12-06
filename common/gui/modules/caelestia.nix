{ lib, pkgs, inputs, username, ... }:
{

  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  programs.caelestia = {
    enable = true;
    systemd = {
      enable = false; # if you prefer starting from your compositor
      target = "graphical-session.target";
      environment = [];
    };
    settings = {
      general = {
        idle = {
          # I manage idle and lock without caelestia
          lockBeforeSleep = false;
          inhibitWhenAudio = false;
          timeouts = [ ];
        };
      };
      services = {
        useFahrenheit = false;
        weatherLocation = "45.07498, 5.77229";
        useTwelveHourClock = false;
      };
    };
    cli.enable = true;
  };
}
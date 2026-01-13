{
  modulesPath,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./home/niri.nix
    ../../common/gui/home.nix
  ];
}
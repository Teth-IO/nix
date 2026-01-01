{
  modulesPath,
  lib,
  pkgs,
  inputs,
  ...
} @ args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../common/gui/disk-config.nix
    ../../common/configuration.nix
    ../../common/gui/gui.nix
    ../../common/gui/kernel.nix
  ];

  # réseau
  networking = {
    hostName = "laptop";
    nameservers = [ "9.9.9.9" ];
    networkmanager.enable = true;
    useDHCP = false;
    dhcpcd.enable = false;
  };

  ## Hardware_video_acceleration, xf68 pour xserver et lib 32 pour steam
  services.xserver.videoDrivers = [ "intel" ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
    ];
    enable32Bit = true;
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  # thermal daemon
  services.thermald.enable = true;

  # fingerpint
  services.fprintd.enable = true;
  #services.fprintd.tod.enable = true;
  #services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # ne pas toucher après l'install
  system.stateVersion = "25.05";
}
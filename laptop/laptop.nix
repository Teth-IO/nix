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
    ../common/disk-config.nix
    ../common/configuration.nix
    ../common/gui/gui.nix
  ];
  
  # réseau
  networking = {
    hostName = "laptop";
    nameservers = [ "9.9.9.9" ];
    networkmanager.enable = true;
    useDHCP = false;
    dhcpcd.enable = false;
  };

  # modern intel
  services.xserver.videoDrivers = [ "intel" ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
      libvdpau-va-gl
      intel-media-driver
      intel-compute-runtime
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  # thermal daemon
  services.thermald.enable = true;

  # fingerpint
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
}
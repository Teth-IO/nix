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
    hostName = "workstation";
    nameservers = [ "9.9.9.9" ];
    networkmanager.enable = true;
    useDHCP = false;
    dhcpcd.enable = false;
  };

  ## Hardware_video_acceleration, xf68 pour xserver et lib 32 pour steam
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = {
    enable = true;
        extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi
  ];

  # thermal daemon
  services.thermald.enable = true;

  # home-manager
  home-manager = {
    backupFileExtension = "hm-backup";
    users.teth-io = import ./workstation-home.nix;
  };

  # ne pas toucher après l'install
  system.stateVersion = "26.05";
}
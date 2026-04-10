{
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../common/gui/disk-config.nix
    ../../common/configuration.nix
    ../../common/gui/gui.nix
    ../../common/gui/kernel.nix
  ];

  # display manager
  services.displayManager.ly = {
    enable = true;
    settings = {
      bigclock = "en";
      clock = "%c";
      animation = "doom";
      battery_id = "BAT0";
    };
  };
 
 # réseau
  networking = {
    hostName = "laptop";
    nameservers = [ "9.9.9.9" ];
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };
    useDHCP = false;
    dhcpcd.enable = false;
    extraHosts =
      ''
        192.168.1.200 gitea.lan
        192.168.1.200 headlamp.lan
      '';
  };

  ## Hardware_video_acceleration, xf68 pour xserver et lib 32 pour steam
  services.xserver.videoDrivers = [ "intel" ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
    enable32Bit = true;
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  # thermal daemon (intel only)
  services.thermald.enable = true;

  # extra packages
  environment.systemPackages = with pkgs; [
    btop
  ];
    
  # auto-cpufreq
  programs.auto-cpufreq.enable = true;

  # fingerpint
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # home-manager
  home-manager = {
    backupFileExtension = "hm-backup";
    users.teth-io = import ./laptop-home.nix;
  };

  # ne pas toucher après l'install
  system.stateVersion = "25.05";
}

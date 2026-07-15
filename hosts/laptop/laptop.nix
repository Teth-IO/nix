{
  modulesPath,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../gui/disk-config.nix
    ../../base/configuration.nix
    ../../gui/gui.nix
    ../../gui/modules/kernel.nix 
    inputs.noctalia-greeter.nixosModules.default
  ];

  # boot
  boot.loader.limine.secureBoot.enable = true;
  
  # display manager
  services.displayManager.ly = {
    enable = true;
    settings = {
      bigclock = "en";
      clock = "%c";
      battery_id = "BAT0";
      animation = "dur_file";
      dur_file_path = "/home/teth-io/ownCloud/Personal/Images/blackhole-smooth-240x67.dur";
      full_color = "true";
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
  };

  ## Hardware_video_acceleration, xf68 pour xserver et lib 32 pour steam
  services.xserver.videoDrivers = [ "intel" ];
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
        vpl-gpu-rt
      ];
      enable32Bit = true;
    };
    cpu.intel.updateMicrocode = true;
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

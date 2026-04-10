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

  # réseau
  networking = {
    hostName = "workstation";
    nameservers = [ "9.9.9.9" ];
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };
    useDHCP = false;
    dhcpcd.enable = false;
    extraHosts =
      "
        192.168.1.200 gitea.lan
        192.168.1.200 headlamp.lan
        192.168.1.200 technitium.lan
      ";
  };

  ## Hardware_video_acceleration, xf68 pour xserver, lib 32 pour steam et overcloking du gpu
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
      enable32Bit = true;
    };
    amdgpu.overdrive.enable = true;
  };

  # règles udev pour openrgb
  services.hardware.openrgb.enable = true;

  #openrazer
  hardware.openrazer.enable = true;
  
  # extra packages
  environment.systemPackages = with pkgs; [
    openrgb
    lutris
    protonup-qt
    openrazer-daemon
    (btop.override { rocmSupport = true; })
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  # LACT
  services.lact.enable = true;
  
  # steam
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        GAMEMODERUN = "1";
        PROTON_USE_NTSYNC = "1";
      };
    };
  };

  # gamemode
  programs.gamemode.enable = true;
  
  # display manager
  services.displayManager.ly = {
    enable = true;
    settings = {
      bigclock = "en";
      clock = "%c";
      animation = "doom";
    };
  };
  
  # thermal daemon
  services.thermald.enable = true;

  # NTSYNC Kernel Driver
  boot.kernelModules = [ "ntsync" ];

  # home-manager
  home-manager = {
    backupFileExtension = "hm-backup";
    users.teth-io = import ./workstation-home.nix;
  };

  # ne pas toucher après l'install
  system.stateVersion = "26.05";
}

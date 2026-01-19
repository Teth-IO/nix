{
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/minimal.nix")
    # config disk independante de celle commune (root on ZFS)
    ./disk-config.nix
    ../../common/configuration.nix
  ];

  # boot
  boot = {
    supportedFilesystems = ["zfs"];
    #zfs.extraPools = [ "raid" ];
    kernelPackages = pkgs.linuxPackages;
  };

  # réseau
  networking = {
    hostName = "server";
    hostId = "81bd7d57";
    extraHosts = "192.168.1.200 ntfy.lan gitea.lan";
    firewall.allowedTCPPorts = [ 6443 ];
    nameservers = [ "9.9.9.9" ];
    interfaces = {
      eth0 = {
        ipv4.addresses = [{
          address = "192.168.1.201";
          prefixLength = 24;
        }];
      };
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "eth0";
    };
  };

  # ZFS
  services.zfs = {
    autoSnapshot.enable = true;
    autoScrub.enable = true;
    trim.enable = true;
    zed.settings =
    {
      ZED_USE_ENCLOSURE_LEDS = true;
      ZED_SYSLOG_SUBCLASS_EXCLUDE = "history_event";
      ZED_NOTIFY_VERBOSE = true;
      ZED_NTFY_TOPIC = "ZFS";
      ZED_NTFY_URL = "https://ntfy.lan";
    };
  };

  # env var 
  environment.variables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

  # packages
  environment.systemPackages = with pkgs; [
    curl
    git
    restic
    fluxcd
    age
    sops
  ];

  # sops-nix
  sops.age.keyFile = "/root/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ./secrets/secrets.json;
  sops.defaultSopsFormat = "json";
  sops.secrets.AWS_DEFAULT_REGION = {};
  sops.secrets.RESTIC_REPOSITORY = {};
  sops.secrets.AWS_ACCESS_KEY_ID = {};
  sops.secrets.AWS_SECRET_ACCESS_KEY = {};
  sops.secrets.RESTIC_PASSWORD = {};
  sops.secrets.ZFS = {};

  # thermal daemon (intel only)
  services.thermald.enable = true;
  
  # k3s
  services.k3s.enable = true;
  services.k3s.role = "server";

  system.stateVersion = "26.05";
}

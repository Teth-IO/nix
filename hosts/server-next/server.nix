{
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/minimal.nix")
    ./disk-luks-bcachefs-impermanence.nix
    ../../base/configuration.nix
  ];
  
  # boot
  boot = {
    supportedFilesystems = ["bcachefs"];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  
  # réseau
  networking = {
    hostName = "server-next";
    firewall.allowedTCPPorts = [ 6443 ];
    networkmanager = {
      enable = true;
    };
    useDHCP = false;
    dhcpcd.enable = false;
  };

  # Maj auto
  system.autoUpgrade = {
    enable = true;
    flake = "git+https://gitea.lan/admin/nix";
    dates = "07:00";
    allowReboot = true;
  };

  # microcode
  hardware.cpu.intel.updateMicrocode = true;

  # bcachefs
  services.bcachefs.autoScrub.enable = true;
  ## trimming indique au montage (--discard)

  # env var 
  environment.variables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

  # packages
  environment.systemPackages = with pkgs; [
    restic
    fluxcd
    cilium-cli
  ];

  # thermal daemon (intel only)
  services.thermald.enable = true;

  # k3s
  services.k3s = {
    enable = true;
    extraFlags = [
      "--flannel-backend=none"
      "--disable-kube-proxy"
      "--disable servicelb"
      "--disable-network-policy"
      "--disable traefik"
    ];
  };

  # preservation
  preservation = {
    enable = true;
    preserveAt."/nix/persistent" = {
      files = [
        { file = "/etc/machine-id"; inInitrd = true; }
        "/root/.config/sops/age/keys.txt"
        { file = "/etc/ssh/ssh_host_rsa_key"; how = "symlink"; configureParent = true; }
        { file = "/etc/ssh/ssh_host_ed25519_key"; how = "symlink"; configureParent = true; }
        "/root/.local/share/fish/fish_history"
      ];
      directories = [
        "/etc/rancher"
        "/root/nix"
        "/root/K3s"
        "/var/lib/sbctl"
        "/var/lib/kubelet" 
        "/var/lib/rancher"
      ];
    };
  };
  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
  
  system.stateVersion = "26.11";
}

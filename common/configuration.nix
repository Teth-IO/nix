{
  modulesPath,
  lib,
  pkgs,
  inputs,
  ...
} @ args:
{
  # boot
  boot = {
    plymouth.enable = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.systemd.enable = true;
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
  };
  # optmisation réseau
  boot.kernel.sysctl = {
    ## TCP hardening
    # Prevent bogus ICMP errors from filling up logs.
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    # Reverse path filtering causes the kernel to do source validation of
    # packets received from all interfaces. This can mitigate IP spoofing.
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    # Do not accept IP source route packets (we're not a router)
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    # Don't send ICMP redirects (again, we're not a router)
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    # Refuse ICMP redirects (MITM mitigations)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    # Protects against SYN flood attacks
    "net.ipv4.tcp_syncookies" = 1;
    # Incomplete protection again TIME-WAIT assassination
    "net.ipv4.tcp_rfc1337" = 1;
    
    ## TCP optimization
    # TCP Fast Open is a TCP extension that reduces network latency by packing
    # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
    # both incoming and outgoing connections:
    "net.ipv4.tcp_fastopen" = 3;
    # Enable IPv4 forwarding for VPN/container routing
    "net.ipv4.ip_forward" = 1;
    # Bufferbloat mitigations + slight improvement in throughput & latency
    #"net.ipv4.tcp_congestion_control" = "bbr"; inclue dans xanmod
    "net.core.default_qdisc" = "cake";
    ## Network performance optimizations
    # Increase network buffer sizes
    "net.core.rmem_default" = 262144;
    "net.core.rmem_max" = 134217728;
    "net.core.wmem_default" = 262144;
    "net.core.wmem_max" = 134217728;
    # TCP buffer sizes
    "net.ipv4.tcp_rmem" = "4096 131072 134217728";
    "net.ipv4.tcp_wmem" = "4096 65536 134217728";
    # TCP performance
    "net.ipv4.tcp_window_scaling" = 1;
    "net.ipv4.tcp_timestamps" = 1;
    "net.ipv4.tcp_sack" = 1;
    "net.ipv4.tcp_fack" = 1;
    "net.ipv4.tcp_low_latency" = 1;
    "net.ipv4.tcp_adv_win_scale" = 1;
    # Reduce TIME_WAIT sockets
    "net.ipv4.tcp_fin_timeout" = 15;
    "net.ipv4.tcp_tw_reuse" = 1;
  };
  boot.kernelModules = ["tcp_bbr"];

  # cache v2
  nix.binaryCaches = [ "https://aseipp-nix-cache.global.ssl.fastly.net" ];
  
  # zram
  zramSwap.enable = true;

  # timezone
  time.timeZone = "Europe/Paris";

  # power management 
  services.upower.enable = true;
  services.tuned.enable = true;

  # btrfs
  services.btrfs.autoScrub.enable = true;
  services.fstrim.enable = true;

  # firmware update
  services.fwupd.enable = true;

  # openssh
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };
  # clef ssh
  users.users.root.openssh.authorizedKeys.keys =
  [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFifozEGfBRs7Plw9XZh0E+/eAL5FnZFUjYZx4NvUTsg"
  ];

  # tailscale
  services.tailscale.enable = true;

  # flake
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 

  # maj auto et optimisation
  system.autoUpgrade = {
    enable = true;
    flake = "git+https://gitea.lan/admin/nix";
    dates = "10:00";
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;

  # certs
  security.pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ./certs/lan.pem ];

  # ne pas toucher après l'install
  system.stateVersion = "25.05";


}


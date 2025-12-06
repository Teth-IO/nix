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
  options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  # certs
  security.pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ./certs/lan.pem ];

  # ne pas toucher après l'install
  system.stateVersion = "25.05";

}
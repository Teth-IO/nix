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
    #plymouth.enable = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.systemd.enable = true;
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
  };

  imports = [ inputs.niri.nixosModules.niri ];
  nixpkgs.overlays = [ 
    inputs.niri.overlays.niri
    (final: prev: {
    # on créer kernllvmPackages au lieu de remplacer llvmPackages lui même sinon tout les packets en clang vont devoir être recompiler comme aucun artefact correspond à ces builds ne sera dans le cache
    kernllvmPackages = prev.llvmPackages // {
      stdenv = prev.llvmPackages.stdenv // {
        mkDerivation =
          attrs:
          (prev.llvmPackages.stdenv.mkDerivation attrs).overrideAttrs (this: {
            env = (this.env or { }) // {
              # Fix `--target` spam.
              NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING = 1;
              # Fix `-nostdinc` warnings.
              NIX_CFLAGS_COMPILE = prev.lib.concatStringsSep " " [
                (this.env.NIX_CFLAGS_COMPILE or "")
                "-Wno-unused-command-line-argument"
              ];
            };
          });
      };
    };
  })
  ];

  boot.kernel.sysctl = {
	  ## https://wiki.archlinux.org/title/Sysctl#Improving_performance
	  "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
	  "net.ipv4.conf.default.rp_filter" = 1;
	  "net.ipv4.conf.all.rp_filter" = 1;
	  "net.ipv4.conf.all.accept_source_route" = 0;
	  "net.ipv6.conf.all.accept_source_route" = 0;
	  "net.ipv4.conf.all.send_redirects" = 0;
	  "net.ipv4.conf.default.send_redirects" = 0;
	  "net.ipv4.conf.all.accept_redirects" = 0;
	  "net.ipv4.conf.default.accept_redirects" = 0;
	  "net.ipv4.conf.all.secure_redirects" = 0;
	  "net.ipv4.conf.default.secure_redirects" = 0;
	  "net.ipv6.conf.all.accept_redirects" = 0;
	  "net.ipv6.conf.default.accept_redirects" = 0;
	  "net.ipv4.tcp_fastopen" = 3;
	  "net.ipv4.ip_forward" = 1;
	  "net.ipv4.tcp_congestion_control" = "bbr";
	  "net.core.default_qdisc" = "fq_codel";
	  "net.ipv4.tcp_window_scaling" = 1;
	  "net.ipv4.tcp_low_latency" = 1;
	  "net.ipv4.tcp_adv_win_scale" = 1;
	  "net.ipv4.tcp_fin_timeout" = 10;
	  "net.ipv4.tcp_tw_reuse" = 1;
	};
  # add BBR patch
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
  nix.settings.tarball-ttl = "0";

  # certs
  security.pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ./certs/lan.pem ];

  # notifications des services en echec
  systemd.services."notify-failure@nixos-upgrade" = {
    enable = true;
    description = "Failure notification for %i";
    scriptArgs = "%i"; # Content after '@' will be sent as '$1' in the below script
    script = ''${pkgs.curl}/bin/curl \
             --fail `#fail fast on server errors` \
             --show-error --silent `#show error <=> it fails` \
             --max-time 10 \
             --retry 3 \
             --data "$1 exited with errors" ntfy.lan/nix'';
  };
}
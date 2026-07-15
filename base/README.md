# configuration.nix

la configuration communes a toutes mes installations

## Boot

On utilise limine comme bootloader moderne qui support le secure boot et measured boot pour nixos. On monte aussi le tmp sur tmpfs et divers amléioration réseau par sysctl (TCP fast open, ...) et l'activation du bbr.  

```nix
  boot = {
    loader = {
      limine.enable = true;
      efi.canTouchEfiVariables = true;
    };
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
    kernel.sysctl = {
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
    kernelModules = ["tcp_bbr"];
  };
```

## Nix

parametrage specifique a nixos

```nix
  nix = {
    settings = {
      # cache v2
      substituters = [ "https://aseipp-nix-cache.global.ssl.fastly.net" ];
      # store optimisation
      auto-optimise-store = true;
      # ttl du cache des dépôts
      tarball-ttl = "0";
    };
    # cleaning des vielles générations
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
```

Garbage Collection qui supprime les configuration systèmes précédentes après 7 jours et le lancement automatique de l’optimisateur du nix store après chaque build.  
Le substituters est le cache v2 qui permet un telechargement beaucoup plus rapide que depuis le cache par defaut https://wiki.nixos.org/wiki/Maintainers:Fastly#Cache_v2_plans  
le tarball ttl a 0 permet d'eviter le comportement par defaut qui est de mettre en cache pendant 1h les depots avec lesquels on interagit (ce aui pose probleme quand on maj le notre pour debug)

Manuellement on utilise :
- `nix flake update` (depuis un dossier avec le flake à dispo, maj le flake.lock)
- `nixos-rebuild switch --flake git+https://gitea.lan/admin/nix#server`

le lock file est mis à jour directement depuis le dépôt par une action

## FR

locales, clavier et timezone

```nix
  # timezone
  time.timeZone = "Europe/Paris";

  # locales
  i18n.defaultLocale = "fr_FR.UTF-8";

  # Apply system keymap to decrypt/login on boot
  console = {
    earlySetup = true;
    useXkbConfig = true;
  };

  services = {
    xserver = {
      xkb.layout = "fr";
      xkb.variant = "latin9";
    };
  }; 
```

## shell

fish par defaut

```nix
  # Shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.shellAliases = {
    ls = "ls --color=auto";
    ll = "ls -la";
  };
```

## SSH

```nix
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
```

## note gestion de l'alimentation

upower par defaut pour tout le monde  
thermald pour les machines intel  
auto-cpufreq pour les laptop  

## autre

zram : partie de RAM compressé avec lz4 qui fait office de swap (pour ne pas utiliser de swap sur dique)  
clef publique perso  
fwupd (pour la maj de firmware)  

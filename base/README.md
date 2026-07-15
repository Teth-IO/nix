# configuration.nix

la configuration communes a toutes mes installations

## Boot

On utilise systemd-boot comme solution légère et moderne. On utilise aussi le module de kernel zram pour utiliser de la RAM compressé comme swap et on active le tmp sur tmpfs.  

```nix
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.systemd.enable = true;
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
  };
```
## optimisation reseau

https://wiki.archlinux.org/title/Sysctl#Improving_performance  
divers optimisation, notamment l'ajout du BBR et le TCP Fast Open  

## Nix

parametrage specifique a nixos

```nix
  nix.settings.substituters = [ "https://aseipp-nix-cache.global.ssl.fastly.net" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;
  nix.settings.tarball-ttl = "0";
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 
```

Garbage Collection qui supprime les configuration systèmes précédentes après 7 jours et le lancement automatique de l’optimisateur du nix store après chaque build.
Le substituters est le cache v2 qui permet un telechargement beaucoup plus rapide dea app que depuis le cache par defaut https://wiki.nixos.org/wiki/Maintainers:Fastly#Cache_v2_plans
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

zram (pour ne pas utiliser de swap disk)
clef publique perso
fwupd

# common.nix

la configuration communes a toutes mes installations

## Full disk encryption

lancer la commande `systemd-cryptenroll --tpm2-device auto /dev/nvme0n1p2` pour enroller le mot de passe de la partition LUKS dans le TPM2

## btrfs

trimming et scrubbing automatique

```nix
 services.btrfs.autoScrub.enable = true;
 services.fstrim.enable = true;
```

## Boot

On utilise systemd-boot comme solution légère et moderne. On utilise aussi le module de kernel zram pour utiliser de la RAM compressé comme swap et on active le tmp sur tmpfs.

```nix
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
```

## optimisation reseau

divers optimisation (buffer, ...), le kernel comprend deja le BBR, on active le TCP Fast Open

## Maintenance

On veut une mise à jour automatisé des applications.

```nix
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
```

la mise à jour se fait tout les jours à 10h, il y a aussi une Garbage Collection qui supprime les configuration systèmes précédentes après 7 jours et le lancement automatique de l’optimisateur du nix store après chaque build.  

Manuellement on utilise :
- `nix flake update` (depuis un dossier avec le flake à dispo, maj le flake.lock)
- `nixos-rebuild switch --flake git+https://gitea.lan/admin/nix#server`

le lock file est mis à jour directement depuis le dépôt par une action

# disk-config.nix

la configuration de disque utilisé par disko  
simple configuration sans fioriture et avec optimisation du BTRFS (voir les mountOptions) 

nvme0n1  
|- nvme0n1p1 VFAT 512M /boot  
|- nvme0n1p2 LUKS 100%  
 |- crypted BTRFS -f subvol /  


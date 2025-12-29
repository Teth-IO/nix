# configuration.nix

la configuration communes a toutes mes installations

## Boot

On utilise systemd-boot comme solution légère et moderne. On utilise aussi le module de kernel zram pour utiliser de la RAM compressé comme swap et on active le tmp sur tmpfs.  
Plymouth est desactive car j'aime voir ce qu'il se passe (et les potentiels erreurs) lors du boot.

```nix
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
```

## optimisation reseau

divers optimisation, notamment l'ajout du BBR et le TCP Fast Open  

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
  nix.settings.tarball-ttl = "0";
```

la mise à jour se fait tout les jours à 10h, il y a aussi une Garbage Collection qui supprime les configuration systèmes précédentes après 7 jours et le lancement automatique de l’optimisateur du nix store après chaque build.

Manuellement on utilise :
- `nix flake update` (depuis un dossier avec le flake à dispo, maj le flake.lock)
- `nixos-rebuild switch --flake git+https://gitea.lan/admin/nix#server`

le lock file est mis à jour directement depuis le dépôt par une action

# disk-config.nix

la configuration de disque utilisé par disko pour mes installs (hors ZFS)  
root on BTRFS sous LUKS

nvme0n1  
- nvme0n1p1 VFAT 512M /boot  
- nvme0n1p2 LUKS 100%  
-- crypted btrfs -f subvol /  

divers optimisation dans le parametrage du system de fichier :  

```
                        mountOptions = [ 
                          "rw"
                          "noatime"
                          "ssd"
                          "space_cache=v2"
                          "compress-force=zstd:1" 
                        ];
```

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

On utilise systemd-boot comme solution moderne, On utilise aussi le module de kernel zram pour utiliser de la RAM compressé comme swap.

```nix
  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  zramSwap.enable = true;
```

## Maintenance

On veut une mise à jour automatisé des applications.

```nix
  system.autoUpgrade = {
    enable = true;
    flake = git+https://gitea.lan/admin/nix;
    dates = "10:10";
  };
  nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;
```

la mise à jour se fait tout les jours, il y a aussi une Garbage Collection qui supprime les configuration systèmes précédentes après 30 jours et le lancement automatique de l’optimisateur du nix store.

Manuellement on utilise :
- `nix flake update` (depuis un dossier avec le flake à dispo, maj le flake.lock)
- `nixos-rebuild switch --flake git+https://gitea.lan/admin/nix#server`

le lock file est mis à jour directement depuis le dépôt par une action


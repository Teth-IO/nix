# gui.nix

La configuration communes a toutes mes installations avec interfaces graphique

## utilisateurs

ici `mutableUsers = false;` pour les rendre declaratif, autrement dit les utilisateurs ne seront pas gerables autrement que par les fichiers de configurations.

## securité

on utilise sudo-rs pour sudo et su  
on augmente aussi le nombre maximal de fichier pouvant etre ouvert, utile dans certaine situation notamment la compilation  

## BTRFS

a l'inverse du server qui lui est en LTS pour la compatibilite ZFS on utilise ici le kernel latest (voir kernel.nix) pour la performance et le BTFS pour beneficier du COW, checksumming et autres attributs d'un fs moderne.

## GUI

| type |  choix  | infos |
|----------|----------|----------|
| alimentation | tuned | moderne |
| desktop protocol | wayland | moderne |
| environnement | niri | hyper agreable |
| DE shell |  dankmaterialshell  | basé sur quickshell (best), integre aussi un greeter |
| terminal |  foot  | moderne, minimaliste, légé, rapide et supporte tout  [ranking](https://ucs-detect.readthedocs.io/results.html#general-tabulated-summary)|
| shell |  elvish  | meilleur navigation, completion et gestion d'erreur/hang |
| graphics |  vulkan  | moderne |
| sounds |  pipewire  | moderne |
| launcher |  fuzzel  | wayland natif, clean |
| icons | Papirus-Dark | top |
| cursor | Bibata-Original-Ice | top |

## autre

bluetooth  
keyring pour les apps qui l'utilises  
ssh-agent pour les gestion des clefs ssh par keepass   
police Inter pour les apps et blex mono nerd font pour le terminal

## Home-manager & home.nix

permet d'etendre la capacite de Nixos aux environnements utilisateur en les rendants declaratif.  
Integre la configuration de plusieurs app (yazi, nushell, foot, ...) et du theming (curseur, icon, ...)

# disk-config.nix

la configuration de disque utilisé par disko  
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

# kernel.nix

override du kernel latest avec optimization d'achitecure et compilé en thinlto  
https://wiki.gentoo.org/wiki/Kernel/Optimization

compilation :  
- en LLVM/clang  
- en march=native avec la config associe (kernel 6.16+)  
- avec thinlto et la config associe (kernel 5.12+)  
- en -O3 (n'est absolument pas recommandé)

note : les options de configuration du kernel en fonctionnement sont disponibles sous /proc/config.gz  
exemple :  
```
cat /proc/config.gz | gunzip > running.config
cat running.config | grep LTO  
cat running.config | grep NATIVE  
```

# ACKNOWLEDGEMENTS :  

[linuxmobile](https://github.com/linuxmobile/kaku)

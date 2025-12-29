# gui.nix

La configuration communes a toutes mes installations avec interfaces graphique

## utilisateurs

ici `mutableUsers = false;` pour les rendre declaratif, autrement dit les utilisateurs ne seront pas gerables autrement que par les fichiers de configurations.

## securite

on utilise sudo-rs pour sudo et su  
on augmente aussi le nombre maximal de fichier pouvant etre ouvert, utile dans certaine situation notamment la compilation  

## kernel et fs

a l'inverse du server qui lui est en LTS pour la compatibilite ZFS on utilise ici le kernel latest pour la performance et le BTFS pour beneficier du COW, checksumming et autres attributs d'un fs moderne.

## GUI

| type |  choix  | infos |
|----------|----------|----------|
| alimentation | tuned | le plus moderne |
| desktop protocol | wayland | le plus moderne |
| environnement | niri | hyper agreable |
| DE shell |  dankmaterialshell  | basé sur quickshell (best), integre aussi un greeter |
| terminal |  foot  | moderne, minimaliste, légé, rapide et supporte tout  [ranking](https://ucs-detect.readthedocs.io/results.html#general-tabulated-summary)|
| shell |  nushell  | operators pour les calculs, Everything is data et tout ce qu’on attend de base (completion, proposition, historique ) |
| graphics |  vulkan  | le plus moderne |
| sounds |  pipewire  | le plus moderne |
| launcher |  rofi  | populaire, modulable |
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

# ACKNOWLEDGEMENTS :  

[linuxmobile](https://github.com/linuxmobile/kaku)

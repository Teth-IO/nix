# gui.nix

La configuration communes a toutes mes installations avec interfaces graphique

## utilisateurs

ici `mutableUsers = false;` pour les rendre declaratif, autrement dit les utilisateurs ne seront pas gerables autrement que par les fichiers de configurations.

## sécurité

on utilise sudo-rs pour sudo et su  
on augmente aussi le nombre maximal de fichier pouvant etre ouvert, utile dans certaine situation notamment la compilation


# kernel  

on utilise le kernel de cachyos en lto.  
le kernel comprend de nombreux patch, est compile en LLVM/clang avec Thin LTO.  
Il propose plusieurs scheduler, certain built-in comme BORE, et d'autre selectionnable avec scx  

## GUI

Sous Wayland avec DankMaterialShell & niri :  
Niri est un Scrollable tiling compositeur pour wayland, il est intuitif, agréable (beaucoup plus que tout les autre que j'ai testé (sway, hyprland, i3, ...)) et puissant.  
DankMaterialShell sert de shell GUI et greeter, il est basé sur quickshell (best) et propose aussi un greeter en display manager. Il dispose d'une intégration directement avec niri ce qui en fait un choix tout désigné.  

## APPs

Stack CLI :  
emulateur de terminal foot avec shell nushell et multiplexer zellij  
foot est léger, rapide, nativement consu pour wayland et propose toute les features d'un emulateur moderne (et compète avec facilement avec les grand nom) [ranking](https://ucs-detect.readthedocs.io/results.html#general-tabulated-summary)  
theme d'application = [kanso.nvim zen](https://github.com/webhooked/kanso.nvim/tree/main/extras)  

## autre

audio avec pipewire (solution moderne)  
bluetooth  
keyring pour les apps qui l'utilises  
ssh-agent pour les gestion des clefs ssh par keepass  
kernel linux en latest  
police Inter pour les apps et blex mono nerd font pour le terminal

## Home-manager & home.nix

Permet d'etendre la capacite de Nixos aux environnements utilisateur en les rendants declaratif.  
Gère la configuration de plusieurs app (niri, dms, foot, yazi, ...) et du theming (curseur, icon, theme...)

# ACKNOWLEDGEMENTS :  

[linuxmobile](https://github.com/linuxmobile/kaku)




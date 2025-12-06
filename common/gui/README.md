# gui.nix

La configuration communes a toutes mes installations avec interfaces graphique

## utilisateurs

ici `mutableUsers = false;` pour les rendre declaratif, autrement dit les utilisateurs ne seront pas gerables autrement que par les fichiers de configurations.

## GUI

dankMaterialShell & niri (enciennement hyprland & caelestia)  
terminal foot avec shell nushell et multiplexer zellij  
theme d'application = kanso.nvim zen  

## autre

audio avec pipewire  
bluetooth  
keyring pour les apps qui l'utilises  
ssh-agent pour les gestion des clefs ssh par keepass  
kernel linux en latest  
police Inter pour les apps et blex mono nerd font pour le terminal

## Home-manager & home.nix

permet d'etendre la capacite de Nixos aux environnements utilisateur en les rendants declaratif.  
Integre la configuration de plusieurs app (hyprland, caelestia, kitty, yazi, ...) et du theming (curseur, icon, theme...)

# ACKNOWLEDGEMENTS :  

[linuxmobile](https://github.com/linuxmobile/kaku)


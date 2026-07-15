collections de configurations d'OS declaratives, immutables et reproductibles  
Installation automatisé  
Maintenant GitOps avec maj et maintenance automatique (scrubbing, trimming, snapshots, garbage collection, ...)  
moderne (zfs, btrfs, zram, ...)  
Sécurisé (FDE, secure boot, measured boot, zpool chiffré, SOPS, impermanence)  
optimizé (tcp fast open, bbr, parametrage des FS, kernel march=native et lto...)

# NixOS

NixOS est **déclaratif** (OS as Code) ce qui permet une grande capacité de customisation, une simplicité de configuration et de maintenance tout en gardant une **reproductibilitée** de l’OS désiré.  
Il est aussi **immutable** et garde à disposition le paramétrage et les binaires précédents ce qui permet de pouvoir **rollback** dans les générations précédentes de l’OS en cas de problème.  
Les mise à jours sont **atomiques**, comme les transactions d'un base de donnée, ce qui permet de s'assurer que le system n'est pas cassé suite au changement.

## flake.nix inputs

Des modules sont diponibles afin d’élargire ses fonctionnalités. Exemple :
- home-manager : Permet de gérer la configuration de l'environnement et des applications au niveau de l'utilisateurs (gtk, qt, desktop entries, énormements d'app, ...)  
- SOPS-Nix : SOPS est un outil permettant de chiffré les secrets contenu dans des fichier afin de pouvoir les stocker et utiliser de manière sécurisé. SOPS-nix permet de gérer ces secrets de façon déclaratif (e.g. les mot de passe utilisateurs, la clefs pour ouvrir un pool zfs est chiffré, ...). Il sont chiffrés pas age par la clefs publique (exemple : `sops encrypt -i --age age1dyl0es8xaqda3qr0dmlrapdgz5ffslkv2sag5amccus8qdfgtsqslmk4hy secrets.json`), la clefs privé indiqué sous `sops.age.keyFile` permet donc de déchiffrer `secrets.json` et les exposes sous `/var/run/secrets/`  
- preservation : un des modules pour l'impermanence, approche qui consiste à monter le disque de façon volatile et donc de l'effacer à chaque démarrage. C'est possible car nixos map / depuis /nix donc il suffit de faire persister ce dossier avec /boot pour avoir un système qui retouve un état de sortie d'installation. Le module permet de désigner les dossier et fichiers à faire persister. Cette approche est pratique car des fichiers orphelins s'accumulent au file du temps et des installations/désinstallations/maj d'app sur le système (regarder la tête des dossiers caché sous ~ ...).  

L'nstallation se fait ici à partir de l'iso minimal par ssh avec [nixos-anywhere](https://github.com/nix-community/nixos-anywhere/blob/main/docs/quickstart.md)

## flake.nix outputs

On désigne ici plusieurs nixosConfigurations, une par installation (server, pc portable, ...).  
Chacune avec les modules quelle utiliseront : inputs et la configuration à suivre (./server/server.nix; ./laptop/laptop.nix)

> **warning** Warning
> Le hostname doit correspondre au nom de la configuration pour le programme de maj identifie la configuration à appliquer

## Installation

Doit se faire depuis un NixOS avec flake vers une machine faisant tourner le media d'installation NixOS  

anywhere est lancé avec une commande :

`nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-facter ./facter.json --flake <path to configuration>#<configuration name> --target-host root@<ip address>`

`<path to configuration>` peut être un dépôt git ou un chemin (e.g. `.` )

> **warning** Warning
> lors d'une installation par nixos-anywhere c'est le pc source qui build les packages pour le pc de destination, il faut donc penser à remplacer l'import de kernel.nix par boot.kernelPackages = pkgs.linuxPackages_latest; pour éviter une compilation en march=native sur une mauvaise architecure

exemple depuis un dossier : `nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-facter ./facter.json  --flake .#hostname --target-host root@192.168.1.89`

exemple pour un dépôt : `nix run github:nix-community/nixos-anywhere -- --flake git+https://gitea.lan/admin/nix#hostname --target-host root@192.168.1.11`  
on ne met pas de --generate-hardware-config nixos-facter ./facter.json car le fichier doit être dispo dans le dépôt donc fait au préalable  

une fois le facter.json creer on l'ajoute dans flake.nix sous la configuration de l'hote

## premier boot

`systemd-cryptenroll --tpm2-device auto /dev/nvme0n1p2` (enrôle le mot de passe de la partition LUKS dans le TPM2)  
`nix-store --optimise` (on a l'optimization automatique mais elle ne s'applique qu'au nouveaux fichier)  

Secure boot ici par Limine :

`sbctl create-keys`  
les enroller en setup mode (par default sur la vm) :  
- vérifier avec `bootctl status` que Secure Boot: disabled (setup)  
- `sbctl enroll-keys -m -f` (-m seulement si le firmware n'est pas exposé comme pour vm)
ajouter `boot.loader.limine.secureBoot.enable = true;` dans la config

Limine procède aussi automatiquement au measured-boot :
> Forced to yes when Secure Boot is active, and forced back to no if the firmware does not expose a TPM 2.0/CC measurement interface. See USAGE.md

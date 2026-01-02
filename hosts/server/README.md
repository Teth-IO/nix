# Premier boot

(fait suite au premier README)  

> [!WARNING]
> commenter `boot.zfs.extraPools = [ "raid" ];` s'il n'est pas présent sinon bloque le boot

Importer la age key dans `/root/.config/sops/age/keys.txt`  
Rebuild pour que les SOPS se mettent  
lancer `zfs set keylocation=file:///run/secrets/ZFS raid/nas` pour que le dataset raid/nas cherche la clef dans le secret exposé par SOPS-nix au lieu de demander le mdp au boot   
connexion au tailnet  
fluxcd (voir k3s)

# zfs

## root on ZFS

dans le fichier disk-config on monte le dataset root sur /  
le pool est configure avec les options :

```
          compression = "lz4";
          acltype = "posixacl";
          xattr = "sa";
          atime = "off";
          recordsize = "1M";
        };
        options.ashift = "12";
```

ce qui correspond a :

* ashift = Ashift tells ZFS what the underlying physical block size your disks use is. ashift=12 means 4K sectors (used by most modern hard drives), and ashift=13 means 8K sectors (used by some modern SSDs).
* xattr = Sets Linux eXtended ATTRibutes directly in the inodes, rather than as tiny little files in special hidden folders.This can have a significant performance impact on datasets with lots of files in them, particularly if SELinux is in play.
* compression, lz4 est la plus rapide
* atime = If atime is on – which it is by default – your system has to update the “Accessed” attribute of every file every time you look at it. This can easily double the IOPS load on a system all by itself. Correspond à l’attribut noatime relatime quant à lui est activé par défaut et fait l'affaire.
* recordsize = you want to match the recordsize to the size of the reads or writes you’re going to be digging out of / cramming into those large files. 1M for reading and writing in fairly large chunks (jpeg, movies...). le recordsize peut pausé problème pour les bases de données en terme de COW (Copy On Write) si le recodsize du fs est inférieurs à celui qu’elles utilises, 1M ne pausera donc pas problème.

## pool pour les datas du serveur

Les données des applications hébergées sous K3S seront sous un pool ZFS en mirroir (RAID 1)

création du pool raid est dataset nas avec les meme options que ci-dessus :

`zpool create -o ashift=12 -O xattr=sa -O compression=lz4 -O atime=off -O -m /mnt/raid raid mirror /dev/sda /dev/sdb`

ajout du chiffrement au pool :

`zfs create -o encryption=on -o keylocation=prompt -o keyformat=passphrase raid/nas`

aussi possible de changer la keylocation par un fichier au lieu du prompt, ce qu'on fait ici avec SOPS (voir plus bas) :

`zfs set keylocation=file:///run/secrets/ZFS raid/nas`

## snapshots

snapshot automatiques (par défaut : 4 de 15 minutes, 24 toutes les heures, 7 journalières, 4 hebdomadères, 12 mensuelles), trim, scrub et paramétrage de ZED

> [!WARNING]
> besoin de `zfs set com.sun:auto-snapshot=true raid` pour que les snapshot auto soit accepté par le pool

```nix
 # boot
 boot.supportedFilesystems = ["zfs"];
 boot.zfs.extraPools = [ "raid" ];
 
 # Services
  services.zfs = {
    autoSnapshot.enable = true;
    autoScrub.enable = true;
    trim.enable = true;
    zed.settings =
    {
      ZED_USE_ENCLOSURE_LEDS = true;
      ZED_SYSLOG_SUBCLASS_EXCLUDE = "history_event";
      ZED_NOTIFY_VERBOSE = true;
      ZED_NTFY_TOPIC = "ZFS";
      ZED_NTFY_URL = "http://ntfy.lan";
    };
  };
```

le pool est monté au démarrage avec `boot.zfs.extraPools`, le dataset est programmé avec la commande `zfs set keylocation=file:///run/secrets/ZFS raid/nas` pour aller chercher le secret exposé par sops-nix

Le ZFS à aussi besoin du paramétrage `networking.hostId`

Les snapshot sont touvable à la racine du dataset dans un dossier caché .zfs (pool/datatset/.zfs)

# Boot

On utilise le kernel standard (en LTS) pour la compatibilite avec le ZFS

# SOPS-Nix

On chiffre nos secets avec age. La clef privé est déclaré avec  `sops.age.keyFile`. Les secrets dont on a besoin sont dans un fichier  secrets.json et monté avec `sops.defaultSopsFile`.

Exemple de fonctionnement :

secrets.json en clair
```json
{
  "ZFS" = "hunter2"
}
```

Pour chiffrer un fichier on doit soit déclarer la clef publique a utilsier dans la commande soit disposé d’un fichier .sops.yaml dans l’arborescence d’où l’on lance la comande

exemple sans yaml :
`sops encrypt -i --age age1dyl0es8xaqda3qr0dmlrapdgz5ffslkv2sag5amccus8qdfgtsqslmk4hy secrets.json`

La valeur hunter2 est maintenant chiffré 

```json
{
  "ZFS" = "ENC[AES256_GCM,data:PYIu5nGPSL56+hAFXA==,iv:PL6CKlYss9ZUL4Cz8tMT62Cr5C6X4/I/JjvCoaYY8JA=,tag:dT1PAdn9X3/tL5y6t71b+A==,type:str]",
        "sops": {
                "age": [
                        {...
}
```

le sercret est disponible en clair sous `/run/secrets/ZFS` lorsqu'il est déclaré avec `sops.secrets.ZFS`. On peut aussi affiné quel programme a accès à quel secret

Config utilisé :

```nix
  sops.age.keyFile = "/root/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ./secrets/secrets.json;
  sops.defaultSopsFormat = "json";
  sops.secrets.AWS_DEFAULT_REGION = {};
  sops.secrets.RESTIC_REPOSITORY = {};
  sops.secrets.AWS_ACCESS_KEY_ID = {};
  sops.secrets.AWS_SECRET_ACCESS_KEY = {};
  sops.secrets.RESTIC_PASSWORD = {};
  sops.secrets.ZFS = {};
```
# DNS

Le server est boostrap en 9.9.9.9
le server doit être exempt de l'override dns de tailscale sinon lui même et les conteneurs n'auront plus de DNS en cas de redémarrage :
tailscale set --accept-dns=false

# K3S

```nix
  services.k3s.enable = true;
  services.k3s.role = "server";
```

# note

Le server n'a aucun compte mis a part root et celui-ni n'a qu'une clef ssh pour se connecter.  
Le server est donc full remote, il sera impossible de s'y log en cas de probleme reseau.

# ACKNOWLEDGEMENTS  

[niki-on-github ](https://github.com/niki-on-github/nixos-k3s)

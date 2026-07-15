root on LUKS2 bcachefs avec impermanence = ok sauf usage spe -> containerd/k3s n'arrivent pas à suivre le bind mount vers bcachefs 
K3S x cilium = en cours
pool bcachefs = nok
whitelisting persistence = en cours

# root on bcachefs

attente correction bind mounts

# bcachefs RAID

`bcachefs format --compression=lz4 --background-compression=lz4 --encrypted --discard --force --replicas=2 /dev/vdb /dev/vdc /dev/vdd /dev/vde`

les replicas suivent les targets mais tiering pas utile ici
Layout is not fixed as with RAID10: a given extent can be replicated across any set of devices = donc osef d'essayer gérer les replicas
durability = osef au finale comme est une notion de tiering

en attente de la migration hors du kernel keyring (voir projet)

  - A faire :
voir pour l'automount (rien côté nixos) = fstab (+ auto passphrase-file pour quand resolution pb encryption key)
snapshot  = pas dans nixos ATM = imperatif
monitoring = créer un service qui envoie un rapport a ntfy toute les semaines

# impermanence

RAS

# k3s

## cilium

remplace tout le stack réseau par défaut

install cilium :
cilium install \
  --set k8sServiceHost=192.168.1.49 \
  --set k8sServicePort=6443 \
  --set kubeProxyReplacement=true \
  --set operator.replicas=1

les containers de base plante avec

## gitops forgejo

attente native kubernetes runner

## gateway API

support 1.6 pour UDP route

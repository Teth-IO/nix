#!/bin/sh

export AWS_DEFAULT_REGION=$(cat /run/secrets/AWS_DEFAULT_REGION)
export RESTIC_REPOSITORY=$(cat /run/secrets/RESTIC_REPOSITORY)
export AWS_ACCESS_KEY_ID=$(cat /run/secrets/AWS_ACCESS_KEY_ID)
export AWS_SECRET_ACCESS_KEY=$(cat /run/secrets/AWS_SECRET_ACCESS_KEY)
export RESTIC_PASSWORD=$(cat /run/secrets/RESTIC_PASSWORD)

curl -X POST -d "$(restic backup /mnt/raid/nas/ --exclude /mnt/raid/nas/jellyfin/data)" https://ntfy.lan/Backup
curl -X POST -d "$(restic forget --keep-last 12)" https://ntfy.lan/Backup
curl -X POST -d "$(restic prune)" https://ntfy.lan/Backup
exit

#!/bin/bash
curl -X POST -d "$(/home/core/restic backup /mnt/raid/nas/ --exclude /mnt/raid/nas/jellyfin/data)" https://ntfy.lan/Backup
curl -X POST -d "$(/home/core/restic forget --keep-last 12)" https://ntfy.lan/Backup
curl -X POST -d "$(/home/core/restic prune)" https://ntfy.lan/Backup
exit

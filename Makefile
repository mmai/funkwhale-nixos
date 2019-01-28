superuser:
	nixops ssh -d funkwhale funkwhale -t "cd ~funkwhale && sudo --user=funkwhale sh -c './createSuperUser.sh'"
import:
	rsync -azv ~/music/ root@funkwhale.local:/srv/funkwhale/data/music/imports/
	nixops ssh -d funkwhale funkwhale -t "chown -R funkwhale.funkwhale /srv/funkwhale/data/music/imports && sudo --user=funkwhale sh -c 'cd ~funkwhale && ./importMusic.sh idOfYourMusicLibrary'"

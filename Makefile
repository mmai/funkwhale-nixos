superuser:
	nixops ssh -d funkwhale funkwhale -t "cd /srv/funkwhale && sudo --user=funkwhale sh -c './createSuperUser.sh'"
import:
	rsync -azv ~/music/ root@funkwhale.local:/srv/funkwhale/music/imports/
	nixops ssh -d funkwhale funkwhale -t "chown -R funkwhale.funkwhale /srv/funkwhale/music/imports && sudo --user=funkwhale sh -c 'cd ~funkwhale && ./importMusic.sh idOfYourMusicLibrary'"
test:
	nixops destroy -d funkwhale-vbox
	nixops delete -d funkwhale-vbox
	nixops create ./deploy/logical.nix ./deploy/physical/virtualbox.nix -d funkwhale-vbox
	nixops deploy -d funkwhale-vbox --allow-reboot
	sleep 90
	nixops ssh -d funkwhale-vbox funkwhale -t "cd /srv/funkwhale && sudo --user=funkwhale sh -c './createSuperUser.sh'"
testmodule:
	nixos-rebuild build-vm --fast -I nixos-config=./configuration.nix -I nixpkgs=~/travaux/nixpkgs
test2machines:
	nixops destroy -d funkwhale2machines-vbox
	nixops delete -d funkwhale2machines-vbox
	nixops create ./deploy/logical2machines.nix ./deploy/physical/virtualbox2machines.nix -d funkwhale2machines-vbox
	nixops deploy -d funkwhale2machines-vbox --allow-reboot

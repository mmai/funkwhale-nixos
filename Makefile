superuser:
	nixops ssh -d funkwhale funkwhale -t "cd ~funkwhale && sudo --user=funkwhale sh -c './createSuperUser.sh'"

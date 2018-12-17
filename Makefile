superuser:
	nixops ssh -d funkwhale funkwhale -t "sudo --user=funkwhale sh -c 'cd ~ && ./createSuperUser.sh'"

# Funkwhale on NixOS

0. Prepare local environment 

Get nix packages updated with funkwhale, and this deployment template 

```bash
git clone https://github.com/mmai/nixpkgs.git
git clone https://github.com/mmai/funkwhale-nixos.git
cd funkwhale-nixos
nix-shell
```

1. Install _NixOps_ deployment tool

```bash
nixenv -i nixops
```

If you want to test on Virtualbox, you need it installed (of course) and started.

The vboxnet0 network has to exist - you can add it in the VirtualBox general settings under Networks - Host-only Networks if necessary.

2. Initiate deployment

```bash
nixops create ./deploy/logical.nix ./deploy/physical/virtualbox.nix -d funkwhale
```

3. Deploy

```
nixops deploy -d funkwhale
```

If you get an error `Exception: unable to activate new configuration` related to _virtualbox.service_, you can force deployment like this: 

```
nixops deploy --force-reboot -d funkwhale
```

Get the IP adress of the server :
```
nixops info -d funkwhale
```

Edit your _/etc/hosts_ file and associate the configured domain name with the IP adress :
```
192.168.56.101 funkwhale.localhost funkwhale.local
```

4. Create a Funkwhale admin user

```
make superuser
```

You should be able to login on http://funkwhale.local/login with the created account.

5. Other commands

Connect on the machine with
```
nixops ssh -d funkwhale funkwhale
```


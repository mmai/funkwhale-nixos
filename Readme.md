# Funkwhale on NixOS

An example of how to deploy Funkwhale on NixOS

This uses the Funkwhale package and module defined at the following path in NixOS packages repository:
- pkgs/servers/web-apps/funkwhale
- nixos/modules/services/web-apps/funkwhale

Those are not yet merged in the official repository, meanwhile we use the development repository (https://github.com/mmai/nixpkgs )

The following process shows how to deploy Funkwhale locally on a VirtualBox virtual machine.

## Prepare local environment 

```bash
git clone https://github.com/mmai/funkwhale-nixos.git
cd funkwhale-nixos
nix-shell
```

## Install _NixOps_ deployment tool

```bash
nixenv -i nixops
```

## Configure VirtualBox

If you want to test on Virtualbox, you need it installed (of course) and started.

The vboxnet0 network has to exist - you can add it in the VirtualBox general settings under Networks - Host-only Networks if necessary.

## Initiate deployment

```bash
nixops create ./deploy/logical.nix ./deploy/physical/virtualbox.nix -d funkwhale
```

## Deploy

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

## Create a Funkwhale admin user

```
make superuser
```

You should be able to login on http://funkwhale.local/login with the created account.

## Other commands

Connect on the machine with
```
nixops ssh -d funkwhale funkwhale
```


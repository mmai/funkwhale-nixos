# Funkwhale on NixOS

An example of how to deploy [Funkwhale](https://funkwhale.audio/) with NixOS and [NixOps](https://nixos.org/nixops/).

This uses the Funkwhale package and module, of which I am the maintainner. If you want to take a look, they are defined at the following path in NixOS packages repository:
- [pkgs/servers/web-apps/funkwhale](https://github.com/mmai/nixpkgs/tree/master/pkgs/servers/web-apps/funkwhale)
- [nixos/modules/services/web-apps/funkwhale](https://github.com/mmai/nixpkgs/tree/master/nixos/modules/services/web-apps/funkwhale)

## Prepare local environment 

Get this repository

```bash
git clone https://github.com/mmai/funkwhale-nixos.git
cd funkwhale-nixos
```

Install [Nix](https://nixos.org/nix/) and bootstrap an environment with Funkwhale packages and the _nixops_ deployment tool (the Funkwhale packages are not yet merged in the official NixOS repository, meanwhile the [maintainer repository](https://github.com/mmai/nixpkgs) is configured in _shell.nix_) :

```
curl https://nixos.org/nix/install | sh
nix-shell
nixenv -i nixops
```

## Set up deployment target

Here are instructions to set up the deployment depending on the targeted server.

You may want to test a local deployment on a virtual machine first, see the following Virtualbox section. 

### VirtualBox

[VirtualBox](https://www.virtualbox.org/) should be installed (of course) and started.

The _vboxnet0_ network has to exist - you can add it in the VirtualBox general settings under _Networks - Host-only Networks_ if necessary.

Then create the deployment configuration with :

```bash
nixops create ./deploy/logical.nix ./deploy/physical/virtualbox.nix -d funkwhale
```

### Amazon Web Services

TODO

### Hetzner VPS

TODO

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


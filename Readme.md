# Funkwhale on NixOS

An example of how to deploy [Funkwhale](https://funkwhale.audio/) with NixOS and [NixOps](https://nixos.org/nixops/).

This uses the Funkwhale package and module, of which I am the maintainer. If you want to take a look, they are defined at the following path in NixOS packages repository:
- [pkgs/servers/web-apps/funkwhale](https://github.com/mmai/nixpkgs/tree/master/pkgs/servers/web-apps/funkwhale)
- [nixos/modules/services/web-apps/funkwhale](https://github.com/mmai/nixpkgs/tree/master/nixos/modules/services/web-apps/funkwhale)

## Prepare local environment 

1. Get this repository

  ```bash
  git clone https://github.com/mmai/funkwhale-nixos.git
  cd funkwhale-nixos
  ```

2. Install [Nix](https://nixos.org/nix/)

  ```
  curl https://nixos.org/nix/install | sh
  ```

  Logout an login again to have the correct environment variables.

3. Bootstrap an environment with Funkwhale packages and the _nixops_ deployment tool (the Funkwhale packages are not yet merged in the official NixOS repository, meanwhile the maintainer repository is configured in _shell.nix_) :

  ```
  nix-shell
  nix-env -i nixops
  ```

  The nix-shell command takes some time to complete.

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

Set up an account on AWS. Copy your AWS access key and private key in ~/.ac2-keys, it should look like this :

```
youraccesskey yoursecretkey
```

On the AWS console, change settings for the default security group and allow ssh, http/https  inbound outbound.

Set the _accessKey_ and _region_ parameters in the _./deploy/physical/ec2.nix_ file.

Then create the deployment configuration with :

```bash
nixops create ./deploy/logical.nix ./deploy/physical/ec2.nix -d funkwhale
```
### Hetzner Cloud

Hetzner provides a NixOS ISO image, but it is not available at system creation.

- Create a server on Hetzner Cloud, you can choose a Ubuntu image and the cheap CX11 type at less than 3€/month.
- From the console, mount a NixOS ISO image on it, reboot and follow the NixOS installation process via the console. That will replace the Ubuntu system by NixOS. 
- add your ssh key to /etc/nixo/configuration.nix so that you and the _nixops_ command can connect. This is the hard part, because copy&paste doesn't work in the console! The easiest way I found was to publish my public keys on a web page (you can create a gist for example) and to get the content from the server with curl.
- copy the _/etc/nixos/hardware-configuration.nix_ and _/etc/nixos/configuration.nix_ files from your server to _./deploy/physical/hetzner/_
- reboot your server and test that you can connect via ssh.
- copy the IP of your server to _deploy/physical/nixos-hetzner.nix_

Then create the deployment configuration with :

```bash
nixops create ./deploy/logical.nix ./deploy/physical/nixos-hetzner.nix -d funkwhale
```

### Others

See https://nixos.org/nixops/manual/

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


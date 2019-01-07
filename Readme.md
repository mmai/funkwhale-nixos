# Funkwhale on NixOS

An example of how to deploy [Funkwhale](https://funkwhale.audio/) with NixOS and [NixOps](https://nixos.org/nixops/).

This uses the Funkwhale package and module for NixOS, of which I am the maintainer. If you want to take a look, they are defined at the following path in NixOS packages repository:
- [pkgs/servers/web-apps/funkwhale](https://github.com/mmai/nixpkgs/tree/funkwhale/pkgs/servers/web-apps/funkwhale)
- [nixos/modules/services/web-apps/funkwhale](https://github.com/mmai/nixpkgs/tree/funkwhale/nixos/modules/services/web-apps/funkwhale)

## Prepare local environment 

1. Install [Nix](https://nixos.org/nix/)

  ```
  curl https://nixos.org/nix/install | sh
  ```

  Logout an login again to have the correct environment variables.
  
2. Get this repository

  ```bash
  git clone https://github.com/mmai/funkwhale-nixos.git
  cd funkwhale-nixos
  ```
  
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

Make sure [VirtualBox](https://www.virtualbox.org/) is installed.

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

Here is a video of the process https://www.youtube.com/watch?v=YUfv3JFwHe0 , or you can follow the instructions below.

1. Server creation

  - Go to https://www.hetzner.com/cloud and create an account if you don't have one
  - Create a new project 
  - Add a server on this project, choose the defaults : ubuntu 18.04, small instance, create & buy
  - once the server is created, go to its page select mount an ISO image, choose "NixOS" and mount.
  - Connect via ssh with the password sent by mail at the server creation. You will be asked to change this password. So do it and disconnect.
  - copy your public ssh key to the server (you can create one by doing `ssh-keygen`) : `ssh-copy-id root@XX.XX.XX.XX`.
  - connect again, you should be able to do so without entering your password. Then reboot to boot on the NixOS ISO image and start the installer.

2. NixOS installation

On the Hetzner dashboard, open the console (top right button next to the lock ). Wait for the NixOS image to boot, you will be directly connected as root. 
If your keyboard is not _qwerty_, you can change the keyboard layout with _loadkeys_, for a french _azerty_ keyboard, type `loadkeys fr`.

First we copy our public key in a safe place, we will need it later 
  ```
  mount /dev/sda1 /mnt
  cp /mnt/root/.ssh/authorized_keys /root/
  unmount /mnt
  ```

We follow the instructions from https://nixos.org/nixos/manual/index.html#sec-installation legacy Boot (MBR), and a 2GiB swap partition :

Create a MBR partition table, add root and swap partitions : lauch `parted /dev/sda` and inside parted type :
    
    mklabel msdos
    mkpart primary 1MiB -2GiB
    mkpart primary linux-swap -2GiB 100%
    q
   
Initialize partitions

     mkfs.ext4 -L nixos /dev/sda1
     mkswap -L swap /dev/sda2


Configure nixos system

    mount /dev/disk/by-label/nixos /mnt
    swapon /dev/sda2
    nixos-generate-config --root /mnt
    cat ./authorized_keys >> /mnt/etc/nixos/configuration.nix # copy our ssh key to the conf file
    nano /mnt/etc/nixos/configuration.nix

In configuration.nix :
    
   - uncomment the `boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only` line
   - you can change your language and keyboard layout in the _i18n_ section
   - add the following lines before the closing bracket, replacing `sh-rsa xxxxx you@desktop` by your public key that we copied at the end of the file the step before with the `cat` command  (and remove that last line after that, the file should end with the closing bracket ) :
   
   ``` 
    users.users.root.openssh.authorizedKeys.keys = [
      "sh-rsa xxxxxx  you@desktop"
    ];

    networking.firewall.allowedTCPPorts = [ 22 ];
    services.openssh.enable = true;
  ```

And the last step :
  
  ```
  nixos-install
  ```
  
Wait for installation, enter a new root password when prompted.
Before rebooting, go to the Hetzner console and unmount the NixOS ISO image. Then you can reboot 
  
  ```
  reboot
  ```

3. Deployment configuration

After rebooting your server, ensure that you are able to connect to it via ssh without needing password :
```
ssh root@XX.XX.XX.XX
exit
```

If it works, you can copy its configuration to your local machine :
```
cd deploy/hetzner
scp root@XX.XX.XX.XX:/etc/nixos/configuration.nix .
scp root@XX.XX.XX.XX:/etc/nixos/hardware-configuration.nix .
cd ../..
```

Edit _physical/nixos-hetzner.nix_ file and set your server IP adress in the `deployment.targetHost` line.

Edit the main _configuration.nix_ file and replace `funkwhale.local` by the domain name you want, you will need to associate this domain to the IP adress of your server (or you can edit your local _/etc/hosts_ file to test it)

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


# Dev notes : how to upgrade

## Update nixpkgs repository

Make sure upstream repository is configured :
https://help.github.com/en/articles/configuring-a-remote-for-a-fork

```
cd ~/path-to/nixpkgs
git remote add upstream https://github.com/NixOS/nixpkgs.git
```

Sync repo :

```
git fetch upstream
git checkout master & git merge upstream/master
git checkout funkwhale & git merge master
```

(if it's a fix after a review : rebase, then force push (cf. https://nixos.org/nixpkgs/manual/#submitting-changes-commit-policy))

## Update funkwhale nixos pkgs

### Module

See changes in https://docs.funkwhale.audio/changelog.html
(look for manual actions...)


Funkwhale code is at https://dev.funkwhale.audio/funkwhale/funkwhale
Look at theses files and make changes in _nixos/modules/services/web-apps/funkwhale/funkwhale.nix_ :
- deploy/*.service
- deploy/nginx.template

Edit module in `nixos/modules/services/web-apps/funkwhale/`

### Package

Look for requirements changes ( ex : `git diff 0.18 0.19.0 -- api/requirements/base.txt`)
* system packages in api/requirements.apt
* python packages in api/requirements/base.txt (add missing requirements, then change versions by testing, don't forget to add new python modules in _pkgs/top-level/python-packages.nix_)


Edit pkg in `pkgs/servers/web-apps/funkwhale/`

* update release version
* update sha256 checksums

## Tests

Test packages :

`nix-build . -A funkwhale`
`nix-build . -A python36Packages.unicode-slugify`

Test module documentation :
```
cd nixos
nix-build release.nix -A manual.x86_64-linux
firefox result/share/doc/nixos/options.html
```
## Test deployment 

```
cd ~/path-to/funkwhale-nixos
nix-shell --run "nixops deploy -d funkwhale-vbox"


nixops info -d funkwhale-vbox
nixops ssh -d funkwhale-vbox funkwhale
make superuser
```


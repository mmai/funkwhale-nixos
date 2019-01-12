# Funkwhale on NixOS - journal

```bash
mkdir work
cd work 
git clone https://code.eliotberriot.com/funkwhale/funkwhale.git
cd funkwhale/api
git checkout 0.17
vim requirements/base.txt # requests-http-signature==0.1 à la place de git+https://github.com/EliotBerriot/requests-http-signature.git@signature-header-support
nixenv -i pypi2nix
pypi2nix -V "3.6" -e setuptools-scm -e isort -e m2r -r requirements/base.txt -E "postgresql libffi openssl openldap cyrus_sasl pkgconfig libjpeg openjpeg zlib libtiff freetype lcms2 libwebp tcl"
# (-e setuptools-scm est nécessaire pour certaindes dépendances (c. https://github.com/garbas/pypi2nix/issues/217)) tester avec:
nix-shell requirements.nix -A interpreter

```
provoque erreur 
```
error: infinite recursion encountered, at /nix/store/mxg4bbblxfns96yrz0nalxyiyjl7gj98-nix-2.1.2/share/nix/corepkgs/derivation.nix:18:9
(use '--show-trace' to show detailed location information)
```
`--show-trace` permet de voir quel paquet a des dépendances circulaires (ici _Twisted_)

Éditer le fichier `requirements_override.nix` et supprimer les dépendances circulaire sur ce modèle, en regardant dans requirements.nix quels paquets référencés dans _Twisted_ référencent eux-même _Twisted_ :

```
{ pkgs, python }:

let 
  removeDependencies = names: deps:
    with builtins; with pkgs.lib;
      filter
      (drv: all
        (suf:
          ! hasSuffix ("-" + suf)
          (parseDrvName drv.name).name
        )
        names
      )
      deps;
  in 

  self: super: {

   "Automat" = python.overrideDerivation super."Automat" (old: {
     propagatedBuildInputs =
      removeDependencies [ "Twisted" ] old.propagatedBuildInputs;
     buildInputs = old.buildInputs ++ [ self."m2r" self."setuptools-scm" ];
  });

  "incremental" = python.overrideDerivation super."incremental" (old: {
    propagatedBuildInputs =
      removeDependencies [ "Twisted" ] old.propagatedBuildInputs;
  });

}
```

problème `Could not find suitable distribution for Requirement.parse('pytest-runner')`, solution supprimer la dépendance dans Setup.py du paquet :

```
  "ffmpeg-python" = python.overrideDerivation super."ffmpeg-python" (old: {
    patchPhase = ''
      sed -i \
        -e "s|'pytest-runner'||" \
        setup.py
    '';
  });

```

setuptools-scm : en plus du `-e setuptools-scm`, ajouter :

```
  "python-dateutil" = python.overrideDerivation super."python-dateutil" (old: {
    buildInputs = old.buildInputs ++ [ self."setuptools-scm" ];
  });
```


problème compilation hiredis (encodage), solution : 
```
  "hiredis" = python.overrideDerivation super."hiredis" (old: {
    buildInputs = old.buildInputs ++ [ pkgs.glibcLocales ];
    preConfigure = ''
        export LANG=en_US.UTF-8
    '';
   });

```

```
cd ../..
cp work/funkwhale/api/requirements.nix . # référencer ce fichier dans packages/funkwhale.nix
```

## Mise à jour

Regarder les différences dans ces fichiers pour répercuter les changements dans _nixos/modules/services/web-apps/funkwhale/funkwhale.nix_ :
- deploy/*.service
- deploy/nginx.template

## Intégration dans dépôt officiel

```
cd ~/travaux/nixpkgs/
git checkout master && git pull
git checkout funkwhale && git merge master
```

- pkg dans _pkgs/servers/web-apps/funkwhale/_
- module dans _nixos/modules/services/web-apps/funkwhale/_

Edition de _shell.nix_ : `pkgsSrc = /home/henri/travaux/nixpkgs`

**Tester le déploiement avec** : 
```
nix-shell --run "nixops deploy -d vbox-funkwhale"
```

**Tester package :**

**Tester module :**
  documentation : `cd nixos ; nix-build release.nix -A manual.x86_64-linux ; firefox result/share/doc/nixos/options.html `

## Retours pull request

Pkg :
  TODO
  TOTEST
  DONE
    import 
    conserve behavior
  
Module :
  TODO
    requirements.nix

    raven option
    config ssl + suppr comments ssl
    FUNKWHALE_FRONTEND_PATH=/srv/funkwhale/front/dist ??? => creation dans nixos_funkwhale ...

    Configs séparées pour psql, redis ...

  TOTEST
    systemd.tmpfiles.rules -> tester avec config différente (home dir, etc.)
    convert aussi "/media/".alias = "${cfg.api.mediaRoot}/"; ?
  DONE
    meta module
    RuntimeDirectory
    inline funkwhale.env
    camelcase
    types.port
    description end with .
    types.enum
    fromEmail : not a default
    domain :not a default
    allowed_domain :not a default
    secret :not a default
    delete recommendedNginx options
    alias = cfg.api.mediaRoot;
    doc mails
    enclose description doc => generate doc
    link to upstream doc
  



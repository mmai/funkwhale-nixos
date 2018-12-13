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
`--show-trace` permet de voir quel paquet a des dépendances circulaires (Twisted)

Éditer le fichier `requirements_override.nix` et supprimer les dépendances circulaire sur ce modèle, en testant petit à petit les dépendances listées dans requirements.nix:

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

  "Twisted" = python.overrideDerivation super."Twisted" (old: {
    propagatedBuildInputs =
      removeDependencies [ "Automat" "incremental" ] old.propagatedBuildInputs;
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

Regarder les différences entre versions pour répercuter changements dans _components/funkwhale.nix_ :
- deploy/*.service
- deploy/nginx.template

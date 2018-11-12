# Funkwhale on NixOS - journal

```bash
mkdir work
cd work 
git clone https://code.eliotberriot.com/funkwhale/funkwhale.git
git checkout 0.17
cd funkwhale/api
nixenv -i pypi2nix
vim requirements/base.txt # requests-http-signature==0.1 à la place de git+https://github.com/EliotBerriot/requests-http-signature.git@signature-header-support

pypi2nix -V "3.6" -r requirements/base.txt -E postgresql -E libffi -E openssl -E openldap -E cyrus_sasl -E "pkgconfig libjpeg openjpeg zlib libtiff freetype lcms2 libwebp tcl"
cd ../..
cp work/funkwhale/api/requirements.nix . # référencer ce fichier dans packages/funkwhale.nix
```

## Mise à jour

Regarder les différences entre versions pour répercuter changements dans _components/funkwhale.nix_ :
- deploy/*.service
- deploy/nginx.template

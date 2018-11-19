{ config, pkgs, ... }:

with pkgs;

  let 
    myPython = import ./requirements_missing.nix { inherit pkgs; };
  in

{ 
  environment.systemPackages = (builtins.attrValues myPython.packages) ++ [
    pkgs.python36Packages.python
    pkgs.python36Packages.django
    pkgs.python36Packages.automat
    pkgs.python36Packages.markdown
    pkgs.python36Packages.pyhamcrest
    pkgs.python36Packages.pyjwt
    pkgs.python36Packages.pygments
    pkgs.python36Packages.twisted
    pkgs.python36Packages.amqp
    pkgs.python36Packages.asgiref
    pkgs.python36Packages.asn1crypto
    pkgs.python36Packages.async-timeout
    pkgs.python36Packages.attrs
    pkgs.python36Packages.audioread
    pkgs.python36Packages.autobahn
    pkgs.python36Packages.backcall
    pkgs.python36Packages.beautifulsoup4
    pkgs.python36Packages.billiard
    pkgs.python36Packages.celery
    pkgs.python36Packages.certifi
    pkgs.python36Packages.cffi
    pkgs.python36Packages.channels
    pkgs.python36Packages.chardet
    pkgs.python36Packages.constantly
    pkgs.python36Packages.cryptography
    pkgs.python36Packages.daphne
    pkgs.python36Packages.decorator
    pkgs.python36Packages.defusedxml
    pkgs.python36Packages.django-allauth
    pkgs.python36Packages.future
    pkgs.python36Packages.httplib2
    pkgs.python36Packages.hyperlink
    pkgs.python36Packages.idna
    pkgs.python36Packages.incremental
    pkgs.python36Packages.ipython
    pkgs.python36Packages.jedi
    pkgs.python36Packages.kombu
    pkgs.python36Packages.msgpack
    pkgs.python36Packages.musicbrainzngs
    pkgs.python36Packages.mutagen
    pkgs.python36Packages.oauth2client
    pkgs.python36Packages.oauthlib
    pkgs.python36Packages.olefile
    pkgs.python36Packages.parso
    pkgs.python36Packages.pendulum
    pkgs.python36Packages.pexpect
    pkgs.python36Packages.pickleshare
    pkgs.python36Packages.ptyprocess
    pkgs.python36Packages.pyacoustid
    pkgs.python36Packages.pyasn1
    pkgs.python36Packages.pyasn1-modules
    pkgs.python36Packages.pycparser
    pkgs.python36Packages.python-dateutil
    pkgs.python36Packages.python3-openid
    pkgs.python36Packages.pytz
    pkgs.python36Packages.pytzdata
    pkgs.python36Packages.raven
    pkgs.python36Packages.redis
    pkgs.python36Packages.requests
    pkgs.python36Packages.rsa
    pkgs.python36Packages.simplegeneric
    pkgs.python36Packages.six
    pkgs.python36Packages.traitlets
    pkgs.python36Packages.txaio
    pkgs.python36Packages.uritemplate
    pkgs.python36Packages.urllib3
    pkgs.python36Packages.vine
    pkgs.python36Packages.wcwidth
    pkgs.python36Packages.whitenoise
    pkgs.python36Packages.youtube-dl
    pkgs.python36Packages.django_environ
    pkgs.python36Packages.django_redis
    pkgs.python36Packages.django_taggit
    pkgs.python36Packages.djangorestframework
    pkgs.python36Packages.google_api_python_client
    pkgs.python36Packages.ipython_genutils
    pkgs.python36Packages.prompt_toolkit
    pkgs.python36Packages.psycopg2
    # pkgs.python36Packages.ldap
    pkgs.python36Packages.python_magic
    pkgs.python36Packages.requests_oauthlib
  ];

  imports = [
    ./components/funkwhale.nix 
  ];

  # See components/funkwhale.nix for all options
  services.funkwhale = {
    enable = true;
    hostname = "funkwhale.local";
    protocol = "http"; # Disable https for local tests
  };

  users.extraUsers.funkwhale = {
    home = "/srv/funkwhale";
    description = "Funkwhale server user";
    # extraGroups = [ "wheel" "networkmanager" ];
    # openssh.authorizedKeys.keys = sshkeys;
  };

  # Overrides default 30M
  services.nginx.clientMaxBodySize = "40m";

  services.fail2ban.enable = true;
  time.timeZone = "Europe/Paris";
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.09";
}

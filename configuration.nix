{ config, pkgs, ... }:

with pkgs;

  let 
    myPython = import ./requirements_missing.nix { inherit pkgs; };
  in

{ 
  environment.systemPackages = with pkgs; [
    (python36.withPackages(ps: with ps; (builtins.attrValues myPython.packages) ++ [
      python
      django
      automat
      markdown
      pyhamcrest
      pyjwt
      pygments
      twisted
      amqp
      asgiref
      asn1crypto
      async-timeout
      attrs
      audioread
      autobahn
      backcall
      beautifulsoup4
      billiard
      celery
      certifi
      cffi
      channels
      chardet
      constantly
      cryptography
      daphne
      decorator
      defusedxml
      django-allauth
      future
      httplib2
      hyperlink
      idna
      incremental
      ipython
      jedi
      kombu
      msgpack
      musicbrainzngs
      mutagen
      oauth2client
      oauthlib
      olefile
      parso
      pendulum
      pexpect
      pickleshare
      ptyprocess
      pyacoustid
      pyasn1
      pyasn1-modules
      pycparser
      python-dateutil
      python3-openid
      pytz
      pytzdata
      raven
      redis
      requests
      rsa
      simplegeneric
      six
      traitlets
      txaio
      uritemplate
      urllib3
      vine
      wcwidth
      whitenoise
      youtube-dl
      django_environ
      django_redis
      django_taggit
      djangorestframework
      google_api_python_client
      ipython_genutils
      prompt_toolkit
      psycopg2
    # ldap
    python_magic
    requests_oauthlib
  ]
    ))
  ];

  imports = [
    ./components/funkwhale.nix 
  ];

  # See components/funkwhale.nix for all options
  services.funkwhale = {
    enable = true;
    hostname = "funkwhale.local";
    protocol = "http"; # Disable https for local tests
    api = {
      django_allowed_hosts = "funkwhale.local";
    };
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

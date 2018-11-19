# generated using pypi2nix tool (version: 1.8.1)
# See more at: https://github.com/garbas/pypi2nix
#
# COMMAND:
#   pypi2nix -V 3.6 -r requirements/base.txt -E postgresql -E libffi -E openssl -E openldap -E cyrus_sasl -E pkgconfig libjpeg openjpeg zlib libtiff freetype lcms2 libwebp tcl
#

{ pkgs ? import <nixpkgs> {}
}:

let

  inherit (pkgs) makeWrapper;
  inherit (pkgs.stdenv.lib) fix' extends inNixShell;

  pythonPackages =
  import "${toString pkgs.path}/pkgs/top-level/python-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv;
    python = pkgs.python36;
    # patching pip so it does not try to remove files when running nix-shell
    overrides =
      self: super: {
        bootstrapped-pip = super.bootstrapped-pip.overrideDerivation (old: {
          patchPhase = old.patchPhase + ''
            sed -i               -e "s|paths_to_remove.remove(auto_confirm)|#paths_to_remove.remove(auto_confirm)|"                -e "s|self.uninstalled = paths_to_remove|#self.uninstalled = paths_to_remove|"                  $out/${pkgs.python35.sitePackages}/pip/req/req_install.py
          '';
        });
      };
  };

  # commonBuildInputs = with pkgs; [ postgresql libffi openssl openldap cyrus_sasl pkgconfig libjpeg openjpeg zlib libtiff freetype lcms2 libwebp tcl ];
  commonBuildInputs = with pkgs; [ 
   postgresql libffi openssl openldap cyrus_sasl pkgconfig libjpeg openjpeg zlib libtiff freetype lcms2 libwebp tcl 

   python36Packages.pytestrunner

    python36Packages.python
    python36Packages.django
    python36Packages.automat
    python36Packages.markdown
    python36Packages.pyhamcrest
    python36Packages.pyjwt
    python36Packages.pygments
    python36Packages.twisted
    python36Packages.amqp
    python36Packages.asgiref
    python36Packages.asn1crypto
    python36Packages.async-timeout
    python36Packages.attrs
    python36Packages.audioread
    python36Packages.autobahn
    python36Packages.backcall
    python36Packages.beautifulsoup4
    python36Packages.billiard
    python36Packages.celery
    python36Packages.certifi
    python36Packages.cffi
    python36Packages.channels
    python36Packages.chardet
    python36Packages.constantly
    python36Packages.cryptography
    python36Packages.daphne
    python36Packages.decorator
    python36Packages.defusedxml
    python36Packages.django-allauth
    python36Packages.future
    python36Packages.httplib2
    python36Packages.hyperlink
    python36Packages.idna
    python36Packages.incremental
    python36Packages.ipython
    python36Packages.jedi
    python36Packages.kombu
    python36Packages.msgpack
    python36Packages.musicbrainzngs
    python36Packages.mutagen
    python36Packages.oauth2client
    python36Packages.oauthlib
    python36Packages.olefile
    python36Packages.parso
    python36Packages.pendulum
    python36Packages.pexpect
    python36Packages.pickleshare
    python36Packages.ptyprocess
    python36Packages.pyacoustid
    python36Packages.pyasn1
    python36Packages.pyasn1-modules
    python36Packages.pycparser
    python36Packages.python-dateutil
    python36Packages.python3-openid
    python36Packages.pytz
    python36Packages.pytzdata
    python36Packages.raven
    python36Packages.redis
    python36Packages.requests
    python36Packages.rsa
    python36Packages.simplegeneric
    python36Packages.six
    python36Packages.traitlets
    python36Packages.txaio
    python36Packages.uritemplate
    python36Packages.urllib3
    python36Packages.vine
    python36Packages.wcwidth
    python36Packages.whitenoise
    python36Packages.youtube-dl
    python36Packages.django_environ
    python36Packages.django_redis
    python36Packages.django_taggit
    python36Packages.djangorestframework
    python36Packages.google_api_python_client
    python36Packages.ipython_genutils
    python36Packages.prompt_toolkit
    python36Packages.psycopg2
    python36Packages.ldap
    python36Packages.python_magic
    python36Packages.requests_oauthlib
    python36Packages.pillow
];
  commonDoCheck = false;

  withPackages = pkgs':
    let
      pkgs = builtins.removeAttrs pkgs' ["__unfix__"];
      interpreter = pythonPackages.buildPythonPackage {
        name = "python36-interpreter";
        buildInputs = [ makeWrapper ] ++ (builtins.attrValues pkgs);
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${pythonPackages.python.interpreter}               $out/bin/${pythonPackages.python.executable}
          for dep in ${builtins.concatStringsSep " "               (builtins.attrValues pkgs)}; do
            if [ -d "$dep/bin" ]; then
              for prog in "$dep/bin/"*; do
                if [ -f $prog ]; then
                  ln -s $prog $out/bin/`basename $prog`
                fi
              done
            fi
          done
          for prog in "$out/bin/"*; do
            wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
          done
          pushd $out/bin
          ln -s ${pythonPackages.python.executable} python
          ln -s ${pythonPackages.python.executable}               python3
          popd
        '';
        passthru.interpreter = pythonPackages.python;
      };
    in {
      __old = pythonPackages;
      inherit interpreter;
      mkDerivation = pythonPackages.buildPythonPackage;
      packages = pkgs;
      overrideDerivation = drv: f:
        pythonPackages.buildPythonPackage (drv.drvAttrs // f drv.drvAttrs //                                            { meta = drv.meta; });
      withPackages = pkgs'':
        withPackages (pkgs // pkgs'');
    };

  python = withPackages {};

  generated = self: {

    "PyMemoize" = python.mkDerivation {
      name = "PyMemoize-1.0.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/f9/31/9c561a845c929ba60c8df2b70be47bd0c0aadb3a55ddfa0cecd244bb6c6f/PyMemoize-1.0.3.tar.gz"; sha256 = "07c7b8f592b1f03af74289ef0e554520022dae378ba36d0dbc1f80532130197b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/mikeboers/PyMemoize";
        license = licenses.bsdOriginal;
        description = "Simple memoizing module.";
      };
    };

    "aioredis" = python.mkDerivation {
      name = "aioredis-1.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/16/b0/9230ebc51c92bdaab067376d88f466fec26ca9ff02192aa7751503c97745/aioredis-1.0.0.tar.gz"; sha256 = "9d735f09117e68fe8a2bf1e1d1d2d31287fffa023903a3629fdc43c391787c0f"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."hiredis"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/aio-libs/aioredis";
        license = licenses.mit;
        description = "asyncio (PEP 3156) Redis support";
      };
    };

    "channels-redis" = python.mkDerivation {
      name = "channels-redis-2.1.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/4c/f1/d74ba52bfd1ea1236c4a55e233d6cd8b3d91b34e44606940f979e5fb1d40/channels_redis-2.1.1.tar.gz"; sha256 = "688233f0114a921239345c388ae4ed3314de345b53832f67b85926b0040a279a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."aioredis"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/django/channels_redis/";
        license = licenses.bsdOriginal;
        description = "Redis-backed ASGI channel layer implementation";
      };
    };

    "django-auth-ldap" = python.mkDerivation {
      name = "django-auth-ldap-1.7.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/38/80/ee5f4322ffa91ff2779141fc7b151b413e4c07b7cb2bb336487cae641c0c/django-auth-ldap-1.7.0.tar.gz"; sha256 = "72848b3b036d299114be3c6ef38b12f83f6cf1cf1696c5f92e06fe45a1b8e27b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/django-auth-ldap/django-auth-ldap";
        license = licenses.bsdOriginal;
        description = "Django LDAP authentication backend";
      };
    };

    "django-cleanup" = python.mkDerivation {
      name = "django-cleanup-2.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/0a/82/7eb33c4af492858f302aa6033306c8eacbd69b061481c8d588486281e8ce/django-cleanup-2.1.0.tar.gz"; sha256 = "0e91783200d75f21a64cb5f9d9dbc1bedd377a7d8de97a55ec8a0e2e28abaf5d"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/un1t/django-cleanup";
        license = licenses.mit;
        description = "Deletes old files.";
      };
    };

    "django-cors-headers" = python.mkDerivation {
      name = "django-cors-headers-2.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/42/c4/5a9c89f4d10f26b71a012848901ebb744530a4277e8fd224abdfb4490131/django-cors-headers-2.1.0.tar.gz"; sha256 = "451bc37a514792c2b46c52362368f7985985933ecdbf1a85f82652579a5cbe01"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/ottoyiu/django-cors-headers";
        license = licenses.mit;
        description = "django-cors-headers is a Django application for handling the server headers required for Cross-Origin Resource Sharing (CORS).";
      };
    };

    "django-dynamic-preferences" = python.mkDerivation {
      name = "django-dynamic-preferences-1.5.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/94/95/18f1ca734ec19ad606cb9cdddee7ceb2b880ffb8a48e5f309596c04fb703/django-dynamic-preferences-1.5.1.tar.gz"; sha256 = "6879c70e874dd31a42a5b2c8f3c924663cfa8c80d30a65f5e3e86edb7df0c7a0"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."persisting-theory"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/EliotBerriot/django-dynamic-preferences";
        license = licenses.bsdOriginal;
        description = "Dynamic global and instance settings for your django project";
      };
    };

    "django-filter" = python.mkDerivation {
      name = "django-filter-1.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/db/12/491d519f5bee93709083c726b020ff9f09b95f32de36ae9023fbc89a21e4/django-filter-1.1.0.tar.gz"; sha256 = "ec0ef1ba23ef95b1620f5d481334413700fb33f45cd76d56a63f4b0b1d76976a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/carltongibson/django-filter/tree/master";
        license = licenses.bsdOriginal;
        description = "Django-filter is a reusable Django application for allowing users to filter querysets dynamically.";
      };
    };

    "django-rest-auth" = python.mkDerivation {
      name = "django-rest-auth-0.9.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/d3/21/059f2b44e0e4dc21a63f7d4095e7f22b159117de6bc38732813516aab2f9/django-rest-auth-0.9.3.tar.gz"; sha256 = "ad155a0ed1061b32e3e46c9b25686e397644fd6acfd35d5c03bc6b9d2fc6c82a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/Tivix/django-rest-auth";
        license = "";
        description = "Create a set of REST API endpoints for Authentication and Registration";
      };
    };

    # "Pillow" = python.mkDerivation {
    #   name = "Pillow-4.3.0";
    #   src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e0/82/ec499c78bfe4ecaa91c2f3000040451d187ed0a816d58b8543e29c48827f/Pillow-4.3.0.tar.gz"; sha256 = "a97c715d44efd5b4aa8d739b8fad88b93ed79f1b33fc2822d5802043f3b1b527"; };
    #   doCheck = commonDoCheck;
    #   buildInputs = commonBuildInputs;
    #   propagatedBuildInputs = [
    # ];
    #   meta = with pkgs.stdenv.lib; {
    #     homepage = "https://python-pillow.org";
    #     license = "Standard PIL License";
    #     description = "Python Imaging Library (Fork)";
    #   };
    # };

    "djangorestframework-jwt" = python.mkDerivation {
      name = "djangorestframework-jwt-1.11.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/35/83/5fdf29d87e5cc04c9ebd2cedf9cd0768c5cd85ed3ee6a4d1dfd1151990de/djangorestframework-jwt-1.11.0.tar.gz"; sha256 = "5efe33032f3a4518a300dc51a51c92145ad95fb6f4b272e5aa24701db67936a7"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GetBlimp/django-rest-framework-jwt";
        license = licenses.mit;
        description = "JSON Web Token based authentication for Django REST framework";
      };
    };


    "ffmpeg-python" = python.mkDerivation {
      name = "ffmpeg-python-0.1.10";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/87/32/d058ed61c6edcec01cbb2c40fc0fea5d074c339fef8c55c287a29efa5ccf/ffmpeg-python-0.1.10.tar.gz"; sha256 = "c4d1c075c3b25d7555001227eeda6c1a1ece2bfb893f54b98150b4bab8916e1b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/kkroening/ffmpeg-python";
        license = "License :: OSI Approved :: Apache Software License";
        description = "Python bindings for FFmpeg - with support for complex filtering";
      };
    };

    "hiredis" = python.mkDerivation {
      name = "hiredis-0.2.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/1b/98/4766d85124b785ff1989ee1c79631a1b6ecfcb444ff39999a87877b2027e/hiredis-0.2.0.tar.gz"; sha256 = "ca958e13128e49674aa4a96f02746f5de5973f39b57297b84d59fd44d314d5b5"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/redis/hiredis-py";
        license = licenses.bsdOriginal;
        description = "Python wrapper for hiredis";
      };
    };

    "persisting-theory" = python.mkDerivation {
      name = "persisting-theory-0.2.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/71/31/fce320615dc39f8942da2e7bc2d89620788a102c5326c46e70a40655f77a/persisting-theory-0.2.1.tar.gz"; sha256 = "00ff7dcc8f481ff75c770ca5797d968e8725b6df1f77fe0cf7d20fa1e5790c0a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://code.eliotberriot.com/eliotberriot/persisting-theory";
        license = licenses.bsdOriginal;
        description = "Registries that can autodiscover values accross your project apps";
      };
    };

    "requests-http-signature" = python.mkDerivation {
      name = "requests-http-signature-0.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/10/18/3744e7bc8b846dc7f4718ad189261f2eb47a70190a2f69a877f2ab51a77c/requests-http-signature-0.1.0.tar.gz"; sha256 = "0e39d928469e6f1411e3bffca74a280ac9375d4fa5bf03552974f0ba4ff4c37a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/kislyuk/requests-http-signature";
        license = "License :: OSI Approved :: Apache Software License";
        description = "A Requests auth module for HTTP Signature";
      };
    };

    # install failed because zope 4.5 already installed...
    # "zope.interface" = python.mkDerivation {
    #   name = "zope.interface-4.6.0";
    #   src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/4e/d0/c9d16bd5b38de44a20c6dc5d5ed80a49626fafcb3db9f9efdc2a19026db6/zope.interface-4.6.0.tar.gz"; sha256 = "1b3d0dcabc7c90b470e59e38a9acaa361be43b3a6ea644c0063951964717f0e5"; };
    #   doCheck = commonDoCheck;
    #   buildInputs = commonBuildInputs;
    #   propagatedBuildInputs = [ ];
    #   meta = with pkgs.stdenv.lib; {
    #     homepage = "https://github.com/zopefoundation/zope.interface";
    #     license = licenses.zpl21;
    #     description = "Interfaces for Python";
    #   };
    # };

    "django-versatileimagefield" = python.mkDerivation {
      name = "django-versatileimagefield-1.10";
        src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/d9/3a/4c1cf49526a43fe223edc99e3b444df33b0589bfac3e00006e288d864840/django-versatileimagefield-1.10.tar.gz"; sha256 = "886d084a95775a452602e3f63201022850281414affb4b7d0e3d3ddfb5361978"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/respondcreate/django-versatileimagefield/";
        license = licenses.mit;
        description = "A drop-in replacement for django's ImageField that provides a flexible, intuitive and easily-extensible interface for creating new images from the one assigned to the field.";
      };
    };

  };
  localOverridesFile = ./requirements_override.nix;
  overrides = import localOverridesFile { inherit pkgs python; };
  commonOverrides = [

  ];
  allOverrides =
    (if (builtins.pathExists localOverridesFile)
     then [overrides] else [] ) ++ commonOverrides;

in python.withPackages
   (fix' (pkgs.lib.fold
            extends
            generated
            allOverrides
         )
   )

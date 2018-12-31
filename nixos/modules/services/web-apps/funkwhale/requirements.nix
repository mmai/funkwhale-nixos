# generated using pypi2nix tool (version: 1.8.1)
# See more at: https://github.com/garbas/pypi2nix
#
# COMMAND:
#   pypi2nix -V 3.6 -e setuptools-scm -e m2r -r requirements/base.txt -E postgresql libffi openssl openldap cyrus_sasl pkgconfig libjpeg openjpeg zlib libtiff freetype lcms2 libwebp tcl
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

  commonBuildInputs = with pkgs; [ postgresql libffi openssl openldap cyrus_sasl pkgconfig libjpeg openjpeg zlib libtiff freetype lcms2 libwebp tcl ];
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

    "Automat" = python.mkDerivation {
      name = "Automat-0.7.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/4a/4f/64db3ffda8828cb0541fe949354615f39d02f596b4c33fb74863756fc565/Automat-0.7.0.tar.gz"; sha256 = "cbd78b83fa2d81fe2a4d23d258e1661dd7493c9a50ee2f1a5b2cac61c1793b0e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Twisted"
      self."attrs"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/glyph/Automat";
        license = licenses.mit;
        description = "Self-service finite-state machines for the programmer on the go.";
      };
    };



    "Django" = python.mkDerivation {
      name = "Django-2.0.9";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/fb/9f/cd3fe00fdaecc34a5ca1d667b8436de604543f77c9e16bc1396a40b720bb/Django-2.0.9.tar.gz"; sha256 = "d6d94554abc82ca37e447c3d28958f5ac39bd7d4adaa285543ae97fb1129fd69"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."pytz"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.djangoproject.com/";
        license = licenses.bsdOriginal;
        description = "A high-level Python Web framework that encourages rapid development and clean, pragmatic design.";
      };
    };



    "Markdown" = python.mkDerivation {
      name = "Markdown-2.6.11";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/b3/73/fc5c850f44af5889192dff783b7b0d8f3fe8d30b65c8e3f78f8f0265fecf/Markdown-2.6.11.tar.gz"; sha256 = "a856869c7ff079ad84a3e19cd87a64998350c2b94e9e08e44270faef33400f81"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://Python-Markdown.github.io/";
        license = licenses.bsdOriginal;
        description = "Python implementation of Markdown.";
      };
    };



    "Pillow" = python.mkDerivation {
      name = "Pillow-4.3.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e0/82/ec499c78bfe4ecaa91c2f3000040451d187ed0a816d58b8543e29c48827f/Pillow-4.3.0.tar.gz"; sha256 = "a97c715d44efd5b4aa8d739b8fad88b93ed79f1b33fc2822d5802043f3b1b527"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."olefile"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://python-pillow.org";
        license = "Standard PIL License";
        description = "Python Imaging Library (Fork)";
      };
    };



    "PyHamcrest" = python.mkDerivation {
      name = "PyHamcrest-1.9.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/a4/89/a469aad9256aedfbb47a29ec2b2eeb855d9f24a7a4c2ff28bd8d1042ef02/PyHamcrest-1.9.0.tar.gz"; sha256 = "8ffaa0a53da57e89de14ced7185ac746227a8894dbd5a3c718bf05ddbd1d56cd"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/hamcrest/PyHamcrest";
        license = licenses.bsdOriginal;
        description = "Hamcrest framework for matcher objects";
      };
    };



    "PyJWT" = python.mkDerivation {
      name = "PyJWT-1.7.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/2f/38/ff37a24c0243c5f45f5798bd120c0f873eeed073994133c084e1cf13b95c/PyJWT-1.7.1.tar.gz"; sha256 = "8d59a976fb773f3e6a39c85636357c4f0e242707394cadadd9814f5cbaa20e96"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."cryptography"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/jpadilla/pyjwt";
        license = licenses.mit;
        description = "JSON Web Token implementation in Python";
      };
    };



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



    "Pygments" = python.mkDerivation {
      name = "Pygments-2.3.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/63/a2/91c31c4831853dedca2a08a0f94d788fc26a48f7281c99a303769ad2721b/Pygments-2.3.0.tar.gz"; sha256 = "82666aac15622bd7bb685a4ee7f6625dd716da3ef7473620c192c0168aae64fc"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pygments.org/";
        license = licenses.bsdOriginal;
        description = "Pygments is a syntax highlighting package written in Python.";
      };
    };



    "Twisted" = python.mkDerivation {
      name = "Twisted-18.9.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/5d/0e/a72d85a55761c2c3ff1cb968143a2fd5f360220779ed90e0fadf4106d4f2/Twisted-18.9.0.tar.bz2"; sha256 = "294be2c6bf84ae776df2fc98e7af7d6537e1c5e60a46d33c3ce2a197677da395"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Automat"
      self."PyHamcrest"
      self."attrs"
      self."constantly"
      self."cryptography"
      self."hyperlink"
      self."idna"
      self."incremental"
      self."pyasn1"
      self."zope.interface"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://twistedmatrix.com/";
        license = licenses.mit;
        description = "An asynchronous networking framework written in Python";
      };
    };



    "aioredis" = python.mkDerivation {
      name = "aioredis-1.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/16/b0/9230ebc51c92bdaab067376d88f466fec26ca9ff02192aa7751503c97745/aioredis-1.0.0.tar.gz"; sha256 = "9d735f09117e68fe8a2bf1e1d1d2d31287fffa023903a3629fdc43c391787c0f"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."async-timeout"
      self."hiredis"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/aio-libs/aioredis";
        license = licenses.mit;
        description = "asyncio (PEP 3156) Redis support";
      };
    };



    "amqp" = python.mkDerivation {
      name = "amqp-2.3.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ca/0a/95f9fb2dd71578cb5629261230cb5b8b278c7cce908bca55af8030faceba/amqp-2.3.2.tar.gz"; sha256 = "073dd02fdd73041bffc913b767866015147b61f2a9bc104daef172fc1a0066eb"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."vine"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/celery/py-amqp";
        license = licenses.bsdOriginal;
        description = "Low-level AMQP client for Python (fork of amqplib).";
      };
    };



    "asgiref" = python.mkDerivation {
      name = "asgiref-2.3.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/2c/0d/a569ab76f6dcec1f1c9946c3ed1e65bb1aa853e620c7626729e1f84b9b2d/asgiref-2.3.2.tar.gz"; sha256 = "b21dc4c43d7aba5a844f4c48b8f49d56277bc34937fd9f9cb93ec97fde7e3082"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."async-timeout"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/django/asgiref/";
        license = licenses.bsdOriginal;
        description = "ASGI specs, helper code, and adapters";
      };
    };



    "asn1crypto" = python.mkDerivation {
      name = "asn1crypto-0.24.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"; sha256 = "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/wbond/asn1crypto";
        license = licenses.mit;
        description = "Fast ASN.1 parser and serializer with definitions for private keys, public keys, certificates, CRL, OCSP, CMS, PKCS#3, PKCS#7, PKCS#8, PKCS#12, PKCS#5, X.509 and TSP";
      };
    };



    "async-timeout" = python.mkDerivation {
      name = "async-timeout-3.0.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/a1/78/aae1545aba6e87e23ecab8d212b58bb70e72164b67eb090b81bb17ad38e3/async-timeout-3.0.1.tar.gz"; sha256 = "0c3c816a028d47f659d6ff5c745cb2acf1f966da1fe5c19c77a70282b25f4c5f"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/aio-libs/async_timeout/";
        license = licenses.asl20;
        description = "Timeout context manager for asyncio programs";
      };
    };



    "attrs" = python.mkDerivation {
      name = "attrs-18.2.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/0f/9e/26b1d194aab960063b266170e53c39f73ea0d0d3f5ce23313e0ec8ee9bdf/attrs-18.2.0.tar.gz"; sha256 = "10cbf6e27dbce8c30807caf056c8eb50917e0eaafe86347671b57254006c3e69"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
      self."zope.interface"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.attrs.org/";
        license = licenses.mit;
        description = "Classes Without Boilerplate";
      };
    };



    "audioread" = python.mkDerivation {
      name = "audioread-2.1.6";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/f0/41/8cd160c6b2046b997d571a744a7f398f39e954a62dd747b2aae1ad7f07d4/audioread-2.1.6.tar.gz"; sha256 = "b0b9270c20833a75ce0d167fb2fdad52ddcd8e8f300be8afad3ac9715850bc50"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/sampsyo/audioread";
        license = licenses.mit;
        description = "multi-library, cross-platform audio decoding";
      };
    };



    "autobahn" = python.mkDerivation {
      name = "autobahn-18.11.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/3a/9f/9552ce8fec2703370f63eedbedffa1151865f1265fbfc5c3bbd1029710cc/autobahn-18.11.2.tar.gz"; sha256 = "43262e500aaf8b89fb5f0b60ab13163500ee877908cdd6861208546d95c6dba0"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Twisted"
      self."cffi"
      self."six"
      self."txaio"
      self."zope.interface"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://crossbar.io/autobahn";
        license = licenses.mit;
        description = "WebSocket client & server library, WAMP real-time framework";
      };
    };



    "backcall" = python.mkDerivation {
      name = "backcall-0.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/84/71/c8ca4f5bb1e08401b916c68003acf0a0655df935d74d93bf3f3364b310e0/backcall-0.1.0.tar.gz"; sha256 = "38ecd85be2c1e78f77fd91700c76e14667dc21e2713b63876c0eb901196e01e4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/takluyver/backcall";
        license = licenses.bsdOriginal;
        description = "Specifications for callback functions passed in to an API";
      };
    };



    "beautifulsoup4" = python.mkDerivation {
      name = "beautifulsoup4-4.6.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/88/df/86bffad6309f74f3ff85ea69344a078fc30003270c8df6894fca7a3c72ff/beautifulsoup4-4.6.3.tar.gz"; sha256 = "90f8e61121d6ae58362ce3bed8cd997efb00c914eae0ff3d363c32f9a9822d10"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.crummy.com/software/BeautifulSoup/bs4/";
        license = licenses.mit;
        description = "Screen-scraping library";
      };
    };



    "billiard" = python.mkDerivation {
      name = "billiard-3.5.0.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/8b/b7/c2fe04f2522bb02d044347734eeda3ff5c7a632fa7d0401530a371ba73db/billiard-3.5.0.5.tar.gz"; sha256 = "42d9a227401ac4fba892918bba0a0c409def5435c4b483267ebfe821afaaba0e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/celery/billiard";
        license = licenses.bsdOriginal;
        description = "Python multiprocessing fork with improvements and bugfixes";
      };
    };



    "celery" = python.mkDerivation {
      name = "celery-4.1.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e9/cf/a4c0597effca20c57eb586324e41d1180bc8f13a933da41e0646cff69f02/celery-4.1.1.tar.gz"; sha256 = "d1f2a3359bdbdfb344edce98b8e891f5fe64f8a11c5a45538ec20ac237c971f5"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Django"
      self."billiard"
      self."kombu"
      self."pytz"
      self."redis"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://celeryproject.org";
        license = licenses.bsdOriginal;
        description = "Distributed Task Queue.";
      };
    };



    "certifi" = python.mkDerivation {
      name = "certifi-2018.11.29";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/55/54/3ce77783acba5979ce16674fc98b1920d00b01d337cfaaf5db22543505ed/certifi-2018.11.29.tar.gz"; sha256 = "47f9c83ef4c0c621eaef743f133f09fa8a74a9b75f037e8624f83bd1b6626cb7"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://certifi.io/";
        license = licenses.mpl20;
        description = "Python package for providing Mozilla's CA Bundle.";
      };
    };



    "cffi" = python.mkDerivation {
      name = "cffi-1.11.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"; sha256 = "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."pycparser"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://cffi.readthedocs.org";
        license = licenses.mit;
        description = "Foreign Function Interface for Python calling C code.";
      };
    };



    "channels" = python.mkDerivation {
      name = "channels-2.0.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/09/9b/61075a16af435d9a70d8b5cd2663ed63c8ba1eac29d355e55ed9e3455175/channels-2.0.2.tar.gz"; sha256 = "5d41e0f2aa40f9755f36c2c1dd83748b6793732190d577922e06294a3b37fd92"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Django"
      self."asgiref"
      self."daphne"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/django/channels";
        license = licenses.bsdOriginal;
        description = "Brings async, event-driven capabilities to Django. Django 1.11 and up only.";
      };
    };



    "channels-redis" = python.mkDerivation {
      name = "channels-redis-2.1.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/4c/f1/d74ba52bfd1ea1236c4a55e233d6cd8b3d91b34e44606940f979e5fb1d40/channels_redis-2.1.1.tar.gz"; sha256 = "688233f0114a921239345c388ae4ed3314de345b53832f67b85926b0040a279a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."aioredis"
      self."asgiref"
      self."async-timeout"
      self."channels"
      self."cryptography"
      self."msgpack"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/django/channels_redis/";
        license = licenses.bsdOriginal;
        description = "Redis-backed ASGI channel layer implementation";
      };
    };



    "chardet" = python.mkDerivation {
      name = "chardet-3.0.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"; sha256 = "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/chardet/chardet";
        license = licenses.lgpl2;
        description = "Universal encoding detector for Python 2 and 3";
      };
    };



    "constantly" = python.mkDerivation {
      name = "constantly-15.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/95/f1/207a0a478c4bb34b1b49d5915e2db574cadc415c9ac3a7ef17e29b2e8951/constantly-15.1.0.tar.gz"; sha256 = "586372eb92059873e29eba4f9dec8381541b4d3834660707faf8ba59146dfc35"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/twisted/constantly";
        license = licenses.mit;
        description = "Symbolic constants in Python";
      };
    };



    "cryptography" = python.mkDerivation {
      name = "cryptography-2.4.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/f3/39/d3904df7c56f8654691c4ae1bdb270c1c9220d6da79bd3b1fbad91afd0e1/cryptography-2.4.2.tar.gz"; sha256 = "05a6052c6a9f17ff78ba78f8e6eb1d777d25db3b763343a1ae89a7a8670386dd"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."asn1crypto"
      self."cffi"
      self."idna"
      self."pytz"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pyca/cryptography";
        license = licenses.bsdOriginal;
        description = "cryptography is a package which provides cryptographic recipes and primitives to Python developers.";
      };
    };



    "daphne" = python.mkDerivation {
      name = "daphne-2.0.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/9e/01/ff37624e8131a69dbf73ee0e5223ae96bfef6e85d5c90836d8e5f0c28600/daphne-2.0.4.tar.gz"; sha256 = "1fd2e0a3e72fdfcee082f3be83feee6670a637ce38b3c72a92e8c904b41153d4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Twisted"
      self."asgiref"
      self."autobahn"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/django/daphne";
        license = licenses.bsdOriginal;
        description = "Django ASGI (HTTP/WebSocket) server";
      };
    };



    "decorator" = python.mkDerivation {
      name = "decorator-4.3.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/6f/24/15a229626c775aae5806312f6bf1e2a73785be3402c0acdec5dbddd8c11e/decorator-4.3.0.tar.gz"; sha256 = "c39efa13fbdeb4506c476c9b3babf6a718da943dab7811c206005a4a956c080c"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/micheles/decorator";
        license = licenses.bsdOriginal;
        description = "Better living through Python with decorators";
      };
    };



    "defusedxml" = python.mkDerivation {
      name = "defusedxml-0.5.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/74/ba/4ba4e89e21b5a2e267d80736ea674609a0a33cc4435a6d748ef04f1f9374/defusedxml-0.5.0.tar.gz"; sha256 = "24d7f2f94f7f3cb6061acb215685e5125fbcdc40a857eff9de22518820b0a4f4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/tiran/defusedxml";
        license = licenses.psfl;
        description = "XML bomb protection for Python stdlib modules";
      };
    };



    "django-allauth" = python.mkDerivation {
      name = "django-allauth-0.36.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/28/86/186141ba1aa5eb98bb73ad7c010c1ce7d986f3c40655536ab156b36a2847/django-allauth-0.36.0.tar.gz"; sha256 = "7d9646e3560279d6294ebb4c361fef829708d106da697658cf158bf2ca57b474"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Django"
      self."python3-openid"
      self."requests"
      self."requests-oauthlib"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/pennersr/django-allauth";
        license = licenses.mit;
        description = "Integrated set of Django applications addressing authentication, registration, account management as well as 3rd party (social) account authentication.";
      };
    };



    "django-auth-ldap" = python.mkDerivation {
      name = "django-auth-ldap-1.7.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/38/80/ee5f4322ffa91ff2779141fc7b151b413e4c07b7cb2bb336487cae641c0c/django-auth-ldap-1.7.0.tar.gz"; sha256 = "72848b3b036d299114be3c6ef38b12f83f6cf1cf1696c5f92e06fe45a1b8e27b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Django"
      self."python-ldap"
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
      self."Django"
      self."persisting-theory"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/EliotBerriot/django-dynamic-preferences";
        license = licenses.bsdOriginal;
        description = "Dynamic global and instance settings for your django project";
      };
    };



    "django-environ" = python.mkDerivation {
      name = "django-environ-0.4.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/a5/b4/22015ec543bc33a68885eb1244d7928d851d7430d30372fb2c046a65e947/django-environ-0.4.5.tar.gz"; sha256 = "6c9d87660142608f63ec7d5ce5564c49b603ea8ff25da595fd6098f6dc82afde"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/joke2k/django-environ";
        license = licenses.mit;
        description = "Django-environ allows you to utilize 12factor inspired environment variables to configure your Django application.";
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



    "django-redis" = python.mkDerivation {
      name = "django-redis-4.5.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/70/5b/0aee365b8a54fbbf978121f10a374d3eed31e2502a0fbf14933f837dad53/django-redis-4.5.0.tar.gz"; sha256 = "57dfc7300fde5a091c63996b0b2bacdd3752fe37678c5a6eafe0b5cac35c0d9c"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."redis"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/niwibe/django-redis";
        license = licenses.bsdOriginal;
        description = "Full featured redis cache backend for Django.";
      };
    };



    "django-rest-auth" = python.mkDerivation {
      name = "django-rest-auth-0.9.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/d3/21/059f2b44e0e4dc21a63f7d4095e7f22b159117de6bc38732813516aab2f9/django-rest-auth-0.9.3.tar.gz"; sha256 = "ad155a0ed1061b32e3e46c9b25686e397644fd6acfd35d5c03bc6b9d2fc6c82a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Django"
      self."django-allauth"
      self."djangorestframework"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/Tivix/django-rest-auth";
        license = "";
        description = "Create a set of REST API endpoints for Authentication and Registration";
      };
    };



    "django-taggit" = python.mkDerivation {
      name = "django-taggit-0.22.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/87/19/5cf407969421f54029410616887592cfc0e8e30b64e465f583ccb4cb4a3a/django-taggit-0.22.2.tar.gz"; sha256 = "fd13e304ba37ff09e601c4797d893fb7d3e699a789b5afb0b09d686f94470441"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/alex/django-taggit/tree/master";
        license = licenses.bsdOriginal;
        description = "django-taggit is a reusable Django application for simple tagging.";
      };
    };



    "django-versatileimagefield" = python.mkDerivation {
      name = "django-versatileimagefield-1.9";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/5e/a4/f0c19859bac524e7a220cc79c44bda72cdd28b100999125c664cf27700e2/django-versatileimagefield-1.9.tar.gz"; sha256 = "2ebdd7125cc0e275a52d1119ae1fabefd76797c9de11f26099eb427f34f0c382"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Pillow"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/respondcreate/django-versatileimagefield/";
        license = licenses.mit;
        description = "A drop-in replacement for django's ImageField that provides a flexible, intuitive and easily-extensible interface for creating new images from the one assigned to the field.";
      };
    };



    "djangorestframework" = python.mkDerivation {
      name = "djangorestframework-3.7.7";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/6b/e0/e63919a37d0df8994cf97df19bffd6137957120b30915e6d57aa80e5408e/djangorestframework-3.7.7.tar.gz"; sha256 = "9f9e94e8d22b100ed3a43cee8c47a7ff7b185e778a1f2da9ec5c73fc4e081b87"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.django-rest-framework.org";
        license = licenses.bsdOriginal;
        description = "Web APIs for Django, made easy.";
      };
    };



    "djangorestframework-jwt" = python.mkDerivation {
      name = "djangorestframework-jwt-1.11.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/35/83/5fdf29d87e5cc04c9ebd2cedf9cd0768c5cd85ed3ee6a4d1dfd1151990de/djangorestframework-jwt-1.11.0.tar.gz"; sha256 = "5efe33032f3a4518a300dc51a51c92145ad95fb6f4b272e5aa24701db67936a7"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."PyJWT"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GetBlimp/django-rest-framework-jwt";
        license = licenses.mit;
        description = "JSON Web Token based authentication for Django REST framework";
      };
    };



    "docutils" = python.mkDerivation {
      name = "docutils-0.14";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"; sha256 = "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docutils.sourceforge.net/";
        license = licenses.publicDomain;
        description = "Docutils -- Python Documentation Utilities";
      };
    };



    "ffmpeg-python" = python.mkDerivation {
      name = "ffmpeg-python-0.1.10";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/87/32/d058ed61c6edcec01cbb2c40fc0fea5d074c339fef8c55c287a29efa5ccf/ffmpeg-python-0.1.10.tar.gz"; sha256 = "c4d1c075c3b25d7555001227eeda6c1a1ece2bfb893f54b98150b4bab8916e1b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."future"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/kkroening/ffmpeg-python";
        license = "License :: OSI Approved :: Apache Software License";
        description = "Python bindings for FFmpeg - with support for complex filtering";
      };
    };



    "future" = python.mkDerivation {
      name = "future-0.17.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/90/52/e20466b85000a181e1e144fd8305caf2cf475e2f9674e797b222f8105f5f/future-0.17.1.tar.gz"; sha256 = "67045236dcfd6816dc439556d009594abf643e5eb48992e36beac09c2ca659b8"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://python-future.org";
        license = licenses.mit;
        description = "Clean single-source support for Python 3 and 2";
      };
    };



    "google-api-python-client" = python.mkDerivation {
      name = "google-api-python-client-1.6.7";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e4/ae/67420c05e476c73ed871e5e01cffb4cff570810618422e20c0f80e543ea5/google-api-python-client-1.6.7.tar.gz"; sha256 = "05583a386e323f428552419253765314a4b29828c3cee15be735f9ebfa5aebf2"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."httplib2"
      self."oauth2client"
      self."six"
      self."uritemplate"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/google/google-api-python-client/";
        license = licenses.asl20;
        description = "Google API Client Library for Python";
      };
    };



    "hiredis" = python.mkDerivation {
      name = "hiredis-0.3.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/b3/e2/4a8ba6d00966e017b884c909aa826d42573b1d613e8813a78eb1af11512f/hiredis-0.3.0.tar.gz"; sha256 = "0c8cff472d579434c667e4c8243efe1a7f598b1f616f08d12c06770f8e4171c0"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/redis/hiredis-py";
        license = licenses.bsdOriginal;
        description = "Python wrapper for hiredis";
      };
    };



    "httplib2" = python.mkDerivation {
      name = "httplib2-0.12.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ce/ed/803905d670b52fa0edfdd135337e545b4496c2ab3a222f1449b7256eb99f/httplib2-0.12.0.tar.gz"; sha256 = "f61fb838a94ce3b349aa32c92fd8430f7e3511afdb18bf9640d647e30c90a6d6"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/httplib2/httplib2";
        license = licenses.mit;
        description = "A comprehensive HTTP client library.";
      };
    };



    "hyperlink" = python.mkDerivation {
      name = "hyperlink-18.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/41/e1/0abd4b480ec04892b1db714560f8c855d43df81895c98506442babf3652f/hyperlink-18.0.0.tar.gz"; sha256 = "f01b4ff744f14bc5d0a22a6b9f1525ab7d6312cb0ff967f59414bbac52f0a306"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."idna"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/python-hyper/hyperlink";
        license = licenses.mit;
        description = "A featureful, immutable, and correct URL for Python.";
      };
    };



    "idna" = python.mkDerivation {
      name = "idna-2.8";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"; sha256 = "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/kjd/idna";
        license = licenses.bsdOriginal;
        description = "Internationalized Domain Names in Applications (IDNA)";
      };
    };



    "incremental" = python.mkDerivation {
      name = "incremental-17.5.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/8f/26/02c4016aa95f45479eea37c90c34f8fab6775732ae62587a874b619ca097/incremental-17.5.0.tar.gz"; sha256 = "7b751696aaf36eebfab537e458929e194460051ccad279c72b755a167eebd4b3"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Twisted"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/twisted/incremental";
        license = licenses.mit;
        description = "UNKNOWN";
      };
    };



    "ipython" = python.mkDerivation {
      name = "ipython-6.5.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/1a/76/0b51dc7dd3a801477d00e6db065f50cce9fe5bdbea3c911fce62c9f02c23/ipython-6.5.0.tar.gz"; sha256 = "b0f2ef9eada4a68ef63ee10b6dde4f35c840035c50fd24265f8052c98947d5a4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Pygments"
      self."backcall"
      self."decorator"
      self."jedi"
      self."pexpect"
      self."pickleshare"
      self."prompt-toolkit"
      self."requests"
      self."simplegeneric"
      self."traitlets"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://ipython.org";
        license = licenses.bsdOriginal;
        description = "IPython: Productive Interactive Computing";
      };
    };



    "ipython-genutils" = python.mkDerivation {
      name = "ipython-genutils-0.2.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"; sha256 = "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://ipython.org";
        license = licenses.bsdOriginal;
        description = "Vestigial utilities from IPython";
      };
    };



    "jedi" = python.mkDerivation {
      name = "jedi-0.13.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/c1/fd/cba30adcd2a739b1288b9dc87830c28797181492757080294523d03599e6/jedi-0.13.1.tar.gz"; sha256 = "b7493f73a2febe0dc33d51c99b474547f7f6c0b2c8fb2b21f453eef204c12148"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."parso"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/davidhalter/jedi";
        license = licenses.mit;
        description = "An autocompletion tool for Python that can be used for text editors.";
      };
    };



    "kombu" = python.mkDerivation {
      name = "kombu-4.2.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/52/29/2c4e26fb944327f7043361243c46a141b62d34d55bdb5bbef5438c7dcff0/kombu-4.2.2.tar.gz"; sha256 = "52763f41077e25fe7e2f17b8319d8a7b7ab953a888c49d9e4e0464fceb716896"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."amqp"
      self."msgpack"
      self."redis"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://kombu.readthedocs.io";
        license = licenses.bsdOriginal;
        description = "Messaging library for Python.";
      };
    };



    "m2r" = python.mkDerivation {
      name = "m2r-0.2.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/39/e7/9fae11a45f5e1a3a21d8a98d02948e597c4afd7848a0dbe1a1ebd235f13e/m2r-0.2.1.tar.gz"; sha256 = "bf90bad66cda1164b17e5ba4a037806d2443f2a4d5ddc9f6a5554a0322aaed99"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."docutils"
      self."mistune"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/miyakogi/m2r";
        license = licenses.mit;
        description = "Markdown and reStructuredText in a single file.";
      };
    };



    "mistune" = python.mkDerivation {
      name = "mistune-0.8.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/2d/a4/509f6e7783ddd35482feda27bc7f72e65b5e7dc910eca4ab2164daf9c577/mistune-0.8.4.tar.gz"; sha256 = "59a3429db53c50b5c6bcc8a07f8848cb00d7dc8bdb431a4ab41920d201d4756e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/lepture/mistune";
        license = licenses.bsdOriginal;
        description = "The fastest markdown parser in pure Python";
      };
    };



    "msgpack" = python.mkDerivation {
      name = "msgpack-0.5.6";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/f3/b6/9affbea179c3c03a0eb53515d9ce404809a122f76bee8fc8c6ec9497f51f/msgpack-0.5.6.tar.gz"; sha256 = "0ee8c8c85aa651be3aa0cd005b5931769eaa658c948ce79428766f1bd46ae2c3"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://msgpack.org/";
        license = licenses.asl20;
        description = "MessagePack (de)serializer.";
      };
    };



    "musicbrainzngs" = python.mkDerivation {
      name = "musicbrainzngs-0.6";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/63/cc/67ad422295750e2b9ee57c27370dc85d5b85af2454afe7077df6b93d5938/musicbrainzngs-0.6.tar.gz"; sha256 = "28ef261a421dffde0a25281dab1ab214e1b407eec568cd05a53e73256f56adb5"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://python-musicbrainzngs.readthedocs.org/";
        license = licenses.bsdOriginal;
        description = "Python bindings for the MusicBrainz NGS and the Cover Art Archive webservices";
      };
    };



    "mutagen" = python.mkDerivation {
      name = "mutagen-1.39";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/61/cb/df5b1ed5276d758684b245ecde990b05ea7470d4fa9530deb86a24cf723b/mutagen-1.39.tar.gz"; sha256 = "9da92566458ffe5618ffd26167abaa8fd81f02a7397b8734ec14dfe14e8a19e4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/quodlibet/mutagen";
        license = licenses.gpl2;
        description = "read and write audio tags for many formats";
      };
    };



    "oauth2client" = python.mkDerivation {
      name = "oauth2client-3.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/c0/7b/bc893e35d6ca46a72faa4b9eaac25c687ce60e1fbe978993fe2de1b0ff0d/oauth2client-3.0.0.tar.gz"; sha256 = "5b5b056ec6f2304e7920b632885bd157fa71d1a7f3ddd00a43b1541a8d1a2460"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."httplib2"
      self."pyasn1"
      self."pyasn1-modules"
      self."rsa"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/google/oauth2client/";
        license = licenses.asl20;
        description = "OAuth 2.0 client library";
      };
    };



    "oauthlib" = python.mkDerivation {
      name = "oauthlib-2.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/df/5f/3f4aae7b28db87ddef18afed3b71921e531ca288dc604eb981e9ec9f8853/oauthlib-2.1.0.tar.gz"; sha256 = "ac35665a61c1685c56336bda97d5eefa246f1202618a1d6f34fccb1bdd404162"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."PyJWT"
      self."cryptography"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/oauthlib/oauthlib";
        license = licenses.bsdOriginal;
        description = "A generic, spec-compliant, thorough implementation of the OAuth request-signing logic";
      };
    };



    "olefile" = python.mkDerivation {
      name = "olefile-0.46";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/34/81/e1ac43c6b45b4c5f8d9352396a14144bba52c8fec72a80f425f6a4d653ad/olefile-0.46.zip"; sha256 = "133b031eaf8fd2c9399b78b8bc5b8fcbe4c31e85295749bb17a87cba8f3c3964"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.decalage.info/python/olefileio";
        license = licenses.bsdOriginal;
        description = "Python package to parse, read and write Microsoft OLE2 files (Structured Storage or Compound Document, Microsoft Office)";
      };
    };



    "parso" = python.mkDerivation {
      name = "parso-0.3.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/46/31/60de7c9cbb97cac56b193a5b61a1fd4d21df84843a570b370ec34781316b/parso-0.3.1.tar.gz"; sha256 = "35704a43a3c113cce4de228ddb39aab374b8004f4f2407d070b6a2ca784ce8a2"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/davidhalter/parso";
        license = licenses.mit;
        description = "A Python Parser";
      };
    };



    "pendulum" = python.mkDerivation {
      name = "pendulum-2.0.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/5b/57/71fc910edcd937b72aa0ef51c8f5734fbd8c011fa1480fce881433847ec8/pendulum-2.0.4.tar.gz"; sha256 = "cf535d36c063575d4752af36df928882b2e0e31541b4482c97d63752785f9fcb"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."python-dateutil"
      self."pytzdata"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://pendulum.eustace.io";
        license = "";
        description = "Python datetimes made easy";
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



    "pexpect" = python.mkDerivation {
      name = "pexpect-4.6.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/89/43/07d07654ee3e25235d8cea4164cdee0ec39d1fda8e9203156ebe403ffda4/pexpect-4.6.0.tar.gz"; sha256 = "2a8e88259839571d1251d278476f3eec5db26deb73a70be5ed5dc5435e418aba"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."ptyprocess"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://pexpect.readthedocs.io/";
        license = licenses.isc;
        description = "Pexpect allows easy control of interactive console applications.";
      };
    };



    "pickleshare" = python.mkDerivation {
      name = "pickleshare-0.7.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/d8/b6/df3c1c9b616e9c0edbc4fbab6ddd09df9535849c64ba51fcb6531c32d4d8/pickleshare-0.7.5.tar.gz"; sha256 = "87683d47965c1da65cdacaf31c8441d12b8044cdec9aca500cd78fc2c683afca"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pickleshare/pickleshare";
        license = licenses.mit;
        description = "Tiny 'shelve'-like database with concurrency support";
      };
    };



    "prompt-toolkit" = python.mkDerivation {
      name = "prompt-toolkit-1.0.15";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/8a/ad/cf6b128866e78ad6d7f1dc5b7f99885fb813393d9860778b2984582e81b5/prompt_toolkit-1.0.15.tar.gz"; sha256 = "858588f1983ca497f1cf4ffde01d978a3ea02b01c8a26a8bbc5cd2e66d816917"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
      self."wcwidth"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jonathanslenders/python-prompt-toolkit";
        license = licenses.bsdOriginal;
        description = "Library for building powerful interactive command lines in Python";
      };
    };



    "psycopg2-binary" = python.mkDerivation {
      name = "psycopg2-binary-2.7.6.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/59/64/7b0fea58c9b7c609717cc951607fe5edb73e86d46a47b0c7d58586335e53/psycopg2-binary-2.7.6.1.tar.gz"; sha256 = "8d517e8fda2efebca27c2018e14c90ed7dc3f04d7098b3da2912e62a1a5585fe"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://initd.org/psycopg/";
        license = licenses.lgpl2;
        description = "psycopg2 - Python-PostgreSQL Database Adapter";
      };
    };



    "ptyprocess" = python.mkDerivation {
      name = "ptyprocess-0.6.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/7d/2d/e4b8733cf79b7309d84c9081a4ab558c89d8c89da5961bf4ddb050ca1ce0/ptyprocess-0.6.0.tar.gz"; sha256 = "923f299cc5ad920c68f2bc0bc98b75b9f838b93b599941a6b63ddbc2476394c0"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pexpect/ptyprocess";
        license = "";
        description = "Run a subprocess in a pseudo terminal";
      };
    };



    "pyacoustid" = python.mkDerivation {
      name = "pyacoustid-1.1.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/da/d1/bf83cce400d5513891ea52e83fde42f17299f80a380f427d50428f817a3c/pyacoustid-1.1.5.tar.gz"; sha256 = "efb6337a470c9301a108a539af7b775678ff67aa63944e9e04ce4216676cc777"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."audioread"
      self."requests"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/sampsyo/pyacoustid";
        license = licenses.mit;
        description = "bindings for Chromaprint acoustic fingerprinting and the Acoustid API";
      };
    };



    "pyasn1" = python.mkDerivation {
      name = "pyasn1-0.4.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/10/46/059775dc8e50f722d205452bced4b3cc965d27e8c3389156acd3b1123ae3/pyasn1-0.4.4.tar.gz"; sha256 = "f58f2a3d12fd754aa123e9fa74fb7345333000a035f3921dbdaa08597aa53137"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/etingof/pyasn1";
        license = licenses.bsdOriginal;
        description = "ASN.1 types and codecs";
      };
    };



    "pyasn1-modules" = python.mkDerivation {
      name = "pyasn1-modules-0.2.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/37/33/74ebdc52be534e683dc91faf263931bc00ae05c6073909fde53999088541/pyasn1-modules-0.2.2.tar.gz"; sha256 = "a0cf3e1842e7c60fde97cb22d275eb6f9524f5c5250489e292529de841417547"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."pyasn1"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/etingof/pyasn1-modules";
        license = licenses.bsdOriginal;
        description = "A collection of ASN.1-based protocols modules.";
      };
    };



    "pycparser" = python.mkDerivation {
      name = "pycparser-2.19";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"; sha256 = "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/eliben/pycparser";
        license = licenses.bsdOriginal;
        description = "C parser in Python";
      };
    };



    "python-dateutil" = python.mkDerivation {
      name = "python-dateutil-2.7.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/0e/01/68747933e8d12263d41ce08119620d9a7e5eb72c876a3442257f74490da0/python-dateutil-2.7.5.tar.gz"; sha256 = "88f9287c0174266bb0d8cedd395cfba9c58e87e5ad86b2ce58859bc11be3cf02"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://dateutil.readthedocs.io";
        license = licenses.bsdOriginal;
        description = "Extensions to the standard Python datetime module";
      };
    };



    "python-ldap" = python.mkDerivation {
      name = "python-ldap-3.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/7f/1c/28d721dff2fcd2fef9d55b40df63a00be26ec8a11e8c6fc612ae642f9cfd/python-ldap-3.1.0.tar.gz"; sha256 = "41975e79406502c092732c57ef0c2c2eb318d91e8e765f81f5d4ab6c1db727c5"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."pyasn1"
      self."pyasn1-modules"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.python-ldap.org/";
        license = licenses.psfl;
        description = "Python modules for implementing LDAP clients";
      };
    };



    "python-magic" = python.mkDerivation {
      name = "python-magic-0.4.15";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/84/30/80932401906eaf787f2e9bd86dc458f1d2e75b064b4c187341f29516945c/python-magic-0.4.15.tar.gz"; sha256 = "f3765c0f582d2dfc72c15f3b5a82aecfae9498bd29ca840d72f37d7bd38bfcd5"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/ahupp/python-magic";
        license = licenses.mit;
        description = "File type identification using libmagic";
      };
    };



    "python3-openid" = python.mkDerivation {
      name = "python3-openid-3.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/9e/75/83541390a7fa0bc9083be88980e2fbd574f927a53a0e60cb61f0c28e83b6/python3-openid-3.1.0.tar.gz"; sha256 = "628d365d687e12da12d02c6691170f4451db28d6d68d050007e4a40065868502"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."defusedxml"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/necaris/python3-openid";
        license = "License :: OSI Approved :: Apache Software License";
        description = "OpenID support for modern servers and consumers.";
      };
    };



    "pytz" = python.mkDerivation {
      name = "pytz-2017.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/60/88/d3152c234da4b2a1f7a989f89609ea488225eaea015bc16fbde2b3fdfefa/pytz-2017.3.zip"; sha256 = "fae4cffc040921b8a2d60c6cf0b5d662c1190fe54d718271db4eb17d44a185b7"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pythonhosted.org/pytz";
        license = licenses.mit;
        description = "World timezone definitions, modern and historical";
      };
    };



    "pytzdata" = python.mkDerivation {
      name = "pytzdata-2018.7";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/d9/27/04b261a2d24a2658159e502fb01e9579f7a42d7a1c51ca5023190dff126b/pytzdata-2018.7.tar.gz"; sha256 = "10c74b0cfc51a9269031f86ecd11096c9c6a141f5bb15a3b8a88f9979f6361e2"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/sdispater/pytzdata";
        license = "";
        description = "The Olson timezone database for Python.";
      };
    };



    "raven" = python.mkDerivation {
      name = "raven-6.9.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/8f/80/e8d734244fd377fd7d65275b27252642512ccabe7850105922116340a37b/raven-6.9.0.tar.gz"; sha256 = "3fd787d19ebb49919268f06f19310e8112d619ef364f7989246fc8753d469888"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."celery"
      self."pytz"
      self."requests"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/getsentry/raven-python";
        license = licenses.bsdOriginal;
        description = "Raven is a client for Sentry (https://getsentry.com)";
      };
    };



    "redis" = python.mkDerivation {
      name = "redis-2.10.6";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/09/8d/6d34b75326bf96d4139a2ddd8e74b80840f800a0a79f9294399e212cb9a7/redis-2.10.6.tar.gz"; sha256 = "a22ca993cea2962dbb588f9f30d0015ac4afcc45bee27d3978c0dbe9e97c6c0f"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/andymccurdy/redis-py";
        license = licenses.mit;
        description = "Python client for Redis key-value store";
      };
    };



    "requests" = python.mkDerivation {
      name = "requests-2.21.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/52/2c/514e4ac25da2b08ca5a464c50463682126385c4272c18193876e91f4bc38/requests-2.21.0.tar.gz"; sha256 = "502a824f31acdacb3a35b6690b5fbf0bc41d63a24a45c4004352b0242707598e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."certifi"
      self."chardet"
      self."cryptography"
      self."idna"
      self."urllib3"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://python-requests.org";
        license = licenses.asl20;
        description = "Python HTTP for Humans.";
      };
    };



    "requests-http-signature" = python.mkDerivation {
      name = "requests-http-signature-0.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/10/18/3744e7bc8b846dc7f4718ad189261f2eb47a70190a2f69a877f2ab51a77c/requests-http-signature-0.1.0.tar.gz"; sha256 = "0e39d928469e6f1411e3bffca74a280ac9375d4fa5bf03552974f0ba4ff4c37a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."cryptography"
      self."requests"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/kislyuk/requests-http-signature";
        license = "License :: OSI Approved :: Apache Software License";
        description = "A Requests auth module for HTTP Signature";
      };
    };



    "requests-oauthlib" = python.mkDerivation {
      name = "requests-oauthlib-1.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/95/be/072464f05b70e4142cb37151e215a2037b08b1400f8a56f2538b76ca6205/requests-oauthlib-1.0.0.tar.gz"; sha256 = "8886bfec5ad7afb391ed5443b1f697c6f4ae98d0e5620839d8b4499c032ada3f"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."oauthlib"
      self."requests"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/requests/requests-oauthlib";
        license = licenses.bsdOriginal;
        description = "OAuthlib authentication support for Requests.";
      };
    };



    "rsa" = python.mkDerivation {
      name = "rsa-4.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/cb/d0/8f99b91432a60ca4b1cd478fd0bdf28c1901c58e3a9f14f4ba3dba86b57f/rsa-4.0.tar.gz"; sha256 = "1a836406405730121ae9823e19c6e806c62bbad73f890574fff50efa4122c487"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."pyasn1"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://stuvel.eu/rsa";
        license = "License :: OSI Approved :: Apache Software License";
        description = "Pure-Python RSA implementation";
      };
    };



    "setuptools-scm" = python.mkDerivation {
      name = "setuptools-scm-3.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/09/b4/d148a70543b42ff3d81d57381f33104f32b91f970ad7873f463e75bf7453/setuptools_scm-3.1.0.tar.gz"; sha256 = "1191f2a136b5e86f7ca8ab00a97ef7aef997131f1f6d4971be69a1ef387d8b40"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pypa/setuptools_scm/";
        license = licenses.mit;
        description = "the blessed package to manage your versions by scm tags";
      };
    };



    "simplegeneric" = python.mkDerivation {
      name = "simplegeneric-0.8.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/3d/57/4d9c9e3ae9a255cd4e1106bb57e24056d3d0709fc01b2e3e345898e49d5b/simplegeneric-0.8.1.zip"; sha256 = "dc972e06094b9af5b855b3df4a646395e43d1c9d0d39ed345b7393560d0b9173"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://cheeseshop.python.org/pypi/simplegeneric";
        license = licenses.zpl21;
        description = "Simple generic functions (similar to Python's own len(), pickle.dump(), etc.)";
      };
    };



    "six" = python.mkDerivation {
      name = "six-1.12.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"; sha256 = "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/benjaminp/six";
        license = licenses.mit;
        description = "Python 2 and 3 compatibility utilities";
      };
    };



    "traitlets" = python.mkDerivation {
      name = "traitlets-4.3.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/a5/98/7f5ef2fe9e9e071813aaf9cb91d1a732e0a68b6c44a32b38cb8e14c3f069/traitlets-4.3.2.tar.gz"; sha256 = "9c4bd2d267b7153df9152698efb1050a5d84982d3384a37b2c1f7723ba3e7835"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."decorator"
      self."ipython-genutils"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://ipython.org";
        license = licenses.bsdOriginal;
        description = "Traitlets Python config system";
      };
    };



    "txaio" = python.mkDerivation {
      name = "txaio-18.8.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/c1/99/81de004578e9afe017bb1d4c8968088a33621c05449fe330bdd7016d5377/txaio-18.8.1.tar.gz"; sha256 = "67e360ac73b12c52058219bb5f8b3ed4105d2636707a36a7cdafb56fe06db7fe"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Twisted"
      self."six"
      self."zope.interface"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/crossbario/txaio";
        license = licenses.mit;
        description = "Compatibility API between asyncio/Twisted/Trollius";
      };
    };



    "uritemplate" = python.mkDerivation {
      name = "uritemplate-3.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/cd/db/f7b98cdc3f81513fb25d3cbe2501d621882ee81150b745cdd1363278c10a/uritemplate-3.0.0.tar.gz"; sha256 = "c02643cebe23fc8adb5e6becffe201185bf06c40bda5c0b4028a93f1527d011d"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://uritemplate.readthedocs.org";
        license = licenses.bsdOriginal;
        description = "URI templates";
      };
    };



    "urllib3" = python.mkDerivation {
      name = "urllib3-1.24.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/b1/53/37d82ab391393565f2f831b8eedbffd57db5a718216f82f1a8b4d381a1c1/urllib3-1.24.1.tar.gz"; sha256 = "de9529817c93f27c8ccbfead6985011db27bd0ddfcdb2d86f3f663385c6a9c22"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."certifi"
      self."cryptography"
      self."idna"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://urllib3.readthedocs.io/";
        license = licenses.mit;
        description = "HTTP library with thread-safe connection pooling, file post, and more.";
      };
    };



    "vine" = python.mkDerivation {
      name = "vine-1.1.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/32/23/36284986e011f3c130d802c3c66abd8f1aef371eae110ddf80c5ae22e1ff/vine-1.1.4.tar.gz"; sha256 = "52116d59bc45392af9fdd3b75ed98ae48a93e822cee21e5fda249105c59a7a72"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/celery/vine";
        license = licenses.bsdOriginal;
        description = "Promises, promises, promises.";
      };
    };



    "wcwidth" = python.mkDerivation {
      name = "wcwidth-0.1.7";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"; sha256 = "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jquast/wcwidth";
        license = licenses.mit;
        description = "Measures number of Terminal column cells of wide-character codes";
      };
    };



    "whitenoise" = python.mkDerivation {
      name = "whitenoise-3.3.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/f8/ed/ee9f2b835b9937eb5756c95aacc003785e113e223ff7cf12fd0981da0743/whitenoise-3.3.1.tar.gz"; sha256 = "9d81515f2b5b27051910996e1e860b1332e354d9e7bcf30c98f21dcb6713e0dd"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://whitenoise.evans.io";
        license = licenses.mit;
        description = "Radically simplified static file serving for WSGI applications";
      };
    };



    "youtube-dl" = python.mkDerivation {
      name = "youtube-dl-2018.12.9";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/29/64/4089aba505cf20954226b382164cc8d8da452330be142270d2e7c054e146/youtube_dl-2018.12.9.tar.gz"; sha256 = "eaf1cd7ea0b599268a9c1f506afa8945ec85e6b4f7243108f9b40a150097bfbe"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/rg3/youtube-dl";
        license = licenses.publicDomain;
        description = "YouTube video downloader";
      };
    };



    "zope.interface" = python.mkDerivation {
      name = "zope.interface-4.6.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/4e/d0/c9d16bd5b38de44a20c6dc5d5ed80a49626fafcb3db9f9efdc2a19026db6/zope.interface-4.6.0.tar.gz"; sha256 = "1b3d0dcabc7c90b470e59e38a9acaa361be43b3a6ea644c0063951964717f0e5"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/zopefoundation/zope.interface";
        license = licenses.zpl21;
        description = "Interfaces for Python";
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
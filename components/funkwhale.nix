{ config, pkgs, ... }:

with pkgs;

let
  cfg = config.services.funkwhale;
  # funkwhalePkg = (import ../packages/funkwhale.nix) { cfg = cfg; stdenv=stdenv; fetchurl=fetchurl; unzip=unzip; };
  funkwhalePkg = (import ../packages/funkwhale.nix) { inherit cfg pkgs; };
  # python = import ./requirements.nix { inherit pkgs; };
  funkwhaleEnv = {
    STATIC_ROOT = "${cfg.api.static_root}";
    MEDIA_ROOT = "${cfg.api.media_root}";
    DATABASE_URL = "${cfg.api.database_url}";
    DJANGO_ALLOWED_HOSTS = "${cfg.api.django_allowed_hosts}";
    DJANGO_SECRET_KEY = "${cfg.api.django_secret_key}";
    MUSIC_DIRECTORY_PATH = "${cfg.api.music_directory_path}";
  };
in 
{ 
  options = {
    services.funkwhale = {
      enable = mkEnableOption "funkwhale";

      api_ip = mkOption {
        type = types.str;
        default = "127.0.0.1";
      };

      api_port = mkOption {
        type = types.str;
        default = "5000";
      };

      hostname = mkOption {
        type = types.str;
        default = "yourdomain";
        description = ''
          The definitive, public domain you will use for your instance
        '';
      };

      protocol = mkOption {
        type = types.str;
        default = "https";
        description = ''
          http or https
        '';
      };

      email_config = mkOption {
        type = types.str;
        default = "consolemail://";
        description = ''
          Configure email sending using this variale
          By default, funkwhale will output emails sent to stdout
          here are a few examples for this setting
          consolemail://         # output emails to console (the default)
          dummymail://          # disable email sending completely
          On a production instance, you'll usually want to use an external SMTP server:
          smtp://user@:password@youremail.host:25
          smtp+ssl://user@:password@youremail.host:465
          smtp+tls://user@:password@youremail.host:587
        '';
      };

      default_from_email = mkOption {
        type = types.str;
        default = "noreply@yourdomain";
        description = ''
          The email address to use to send system emails
        '';
      };

      # reverse_proxy_type = mkOption {
      #   type = types.str;
      #   default = "nginx";
      #   description = ''
      #     Depending on the reverse proxy used in front of your funkwhale instance,
      #     the API will use different kind of headers to serve audio files
      #     Allowed values: nginx, apache2
      #   '';
      # };

    api = {
      database_url = mkOption {
        type = types.str;
        default = "postgresql://funkwhale@:5432/funkwhale";
        description = ''
          Database configuration
          Examples:
          postgresql://<user>:<password>@<host>:<port>/<database>
          postgresql://funkwhale:passw0rd@localhost:5432/funkwhale_database
        '';
      };

      cache_url = mkOption {
        type = types.str;
        default = "redis://127.0.0.1:6379/0";
        description = ''
          Cache configuration
          Examples:
          redis://<host>:<port>/<database>
          redis://localhost:6379/0
        '';
      };

      media_root = mkOption {
        type = types.str;
        default = "/srv/funkwhale/data/media";
        description = ''
          Where media files (such as album covers or audio tracks) should be stored on your system?
          (Ensure this directory actually exists)
        '';
      };

      static_root = mkOption {
        type = types.str;
        default = "/srv/funkwhale/data/static";
        description = ''
          Where static files (such as API css or icons) should be compiled on your system?
          (Ensure this directory actually exists)
        '';
      };

      django_allowed_hosts = mkOption {
        type = types.str;
        default = "yourdomain";
        description = ''
          Update it to match the domain that will be used to reach your funkwhale instance
        '';
      };

      django_secret_key = mkOption {
        type = types.str;
        default = "";
        description = ''
          Generate one using `openssl rand -base64 45`, for example
        '';
      };
    };

    music_directory_path = mkOption {
        type = types.str;
        default = "/srv/funkwhale/data/music";
        description = ''
          In-place import settings
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    services.ntp.enable = true; 
    services.redis.enable =  true;
    services.postgresql = {
      enable = true;
      # package = pkgs.postgresql100;
      # enableTCPIP = true;
      # authentication = pkgs.lib.mkOverride 10 ''
      #   local all all trust
      #   host all all ::1/128 trust
      # '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE funkwhale WITH LOGIN PASSWORD 'funkwhale' CREATEDB;
        CREATE DATABASE funkwhale WITH ENCODING 'utf8';
        GRANT ALL PRIVILEGES ON DATABASE funkwhale TO funkwhale;
      '';
    };
    services.nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      proxyWebsockets = true;
      clientMaxBodySize = "30M";
      virtualHosts = {
        "${cfg.hostname}" = {
        # enableACME = true; #Ask Let's Encrypt to sign a certificate for this vhost
        # addSSL = true;
        # forceSSL = true;
          root = "${funkwhalePkg}/front";
          default = true;
          locations = {
            "/".tryFiles = "$uri $uri/ @rewrites";
            "@rewrites".extraConfig = ''
                rewrite ^(.+)$ /index.html last;
              '';
            "/api/".proxyPass = "http://funkwhale-api/api/";
            "/federation/".proxyPass = "http://funkwhale-api/federation/";
            "/rest/".proxyPass = "http://funkwhale-api/api/subsonic/rest/";
            "/.well-known/".proxyPass = "http://funkwhale-api/.well-known/";
            "/media/".alias = "${cfg.api.media_root}/";
            "/_protected/media" = {
              extraConfig = ''
                internal;
              '';
              alias = "${cfg.api.media_root}";
            };
            "/_protected/music" = {
              extraConfig = ''
                internal;
              '';
              alias = "${cfg.music_directory_path}";
            };
            "/staticfiles/".alias = "${cfg.api.static_root}/";
          };
        };
        };
      };

      systemd.services = {
        funkwhale.target = {
          description = "Funkwhale";
          wants = ["funkwhale-server.service" "funkwhale-worker.service" "funkwhale-beat.service"];
        };
        funkwhale-init = {
          description = "Funkwhale initialization";
          after = [ "postgresql.service" ];
          before = ["funkwhale-server.service" "funkwhale-worker.service" "funkwhale-beat.service"];
          environment = funkwhaleEnv;
          script = ''
            if ! test -e ${cfg.api.media_root}; then
            mkdir -p ${cfg.api.media_root}
            mkdir -p ${cfg.api.static_root}
            chown -R ${users.extraUsers.funkwhale} ${users.extraUsers.funkwhale.home} 

            python ${funkwhalePkg}/api/manage.py migrate
            python ${funkwhalePkg}/api/manage.py createsuperuser
            python ${funkwhalePkg}/api/manage.py collectstatic
            fi
          '';
        };
      };

      funkwhale-server = {
        description = "Funkwhale application server";
        after = [ "redis.service" "postgresql.service" ];
        partOf = [ "funkwhale.target" ];

        User = "funkwhale";
        WorkingDirectory = "${funkwhalePkg}/api";
        environment = funkwhaleEnv;
        script = "${funkwhalePkg}.daphne -b ${cfg.api_ip} -p ${cfg.api_port} config.asgi:application --proxy-headers";

        wantedBy = [ "multi-user.target" ];
      };

      funkwhale-worker = {
        description = "Funkwhale celery worker";
        after = [ "redis.service" "postgresql.service" ];
        partOf = [ "funkwhale.target" ];

        User = "funkwhale";
        WorkingDirectory = "${funkwhalePkg}/api";
        environment = funkwhaleEnv;
        script = "${funkwhalePkg}.celery -A funkwhale_api.taskapp worker -l INFO";

        wantedBy = [ "multi-user.target" ];
      };

      funkwhale-beat = {
        description = "Funkwhale celery beat process";
        after = [ "redis.service" "postgresql.service" ];
        partOf = [ "funkwhale.target" ];

        User = "funkwhale";
        WorkingDirectory = "${funkwhalePkg}/api";
        environment = funkwhaleEnv;
        script = "${funkwhalePkg}.celery -A funkwhale_api.taskapp beat -l INFO";

        wantedBy = [ "multi-user.target" ];
      };

  };
}

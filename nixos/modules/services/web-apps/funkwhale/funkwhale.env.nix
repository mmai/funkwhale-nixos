{pkgs, cfg}:

pkgs.writeText "funkwhale.env" ''
# If you have any doubts about what a setting does,
# check https://docs.funkwhale.audio/configuration.html#configuration-reference

# If you're tweaking this file from the template, ensure you edit at least the
# following variables:
# - DJANGO_SECRET_KEY
# - DJANGO_ALLOWED_HOSTS
# - FUNKWHALE_HOSTNAME
# - EMAIL_CONFIG and DEFAULT_FROM_EMAIL if you plan to send emails)
# On non-docker setup **only**, you'll also have to tweak/uncomment those variables:
# - DATABASE_URL
# - CACHE_URL
#
# You **don't** need to update those variables on pure docker setups.
#
# Additional options you may want to check:
# - MUSIC_DIRECTORY_PATH and MUSIC_DIRECTORY_SERVE_PATH if you plan to use
#   in-place import
#
# Docker only
# -----------

# The tag of the image we should use
# (it will be interpolated in docker-compose file)
# You can comment or ignore this if you're not using docker
FUNKWHALE_VERSION=latest

# End of Docker-only configuration

# General configuration
# ---------------------

# Set this variables to bind the API server to another interface/port
# example: FUNKWHALE_API_IP=0.0.0.0
# example: FUNKWHALE_API_PORT=5678
FUNKWHALE_API_IP=${cfg.api_ip}
FUNKWHALE_API_PORT=${cfg.api_port}

# Replace this by the definitive, public domain you will use for
# your instance
FUNKWHALE_URL = "${cfg.hostname}";
FUNKWHALE_HOSTNAME=${cfg.hostname}
FUNKWHALE_PROTOCOL=${cfg.protocol}

# Configure email sending using this variale
# By default, funkwhale will output emails sent to stdout
# here are a few examples for this setting
# EMAIL_CONFIG=consolemail://         # output emails to console (the default)
# EMAIL_CONFIG=dummymail://          # disable email sending completely
# On a production instance, you'll usually want to use an external SMTP server:
# EMAIL_CONFIG=smtp://user@:password@youremail.host:25
# EMAIL_CONFIG=smtp+ssl://user@:password@youremail.host:465
# EMAIL_CONFIG=smtp+tls://user@:password@youremail.host:587
EMAIL_CONFIG=${cfg.email_config}

# The email address to use to send system emails.
# DEFAULT_FROM_EMAIL=noreply@yourdomain
DEFAULT_FROM_EMAIL=${cfg.default_from_email}

# Depending on the reverse proxy used in front of your funkwhale instance,
# the API will use different kind of headers to serve audio files
# Allowed values: nginx, apache2
REVERSE_PROXY_TYPE=nginx

# API/Django configuration

# Database configuration
# Examples:
#  DATABASE_URL=postgresql://<user>:<password>@<host>:<port>/<database>
#  DATABASE_URL=postgresql://funkwhale:passw0rd@localhost:5432/funkwhale_database
# Use the next one if you followed Debian installation guide
# DATABASE_URL=postgresql://funkwhale@:5432/funkwhale
DATABASE_URL=${cfg.api.database_url}

# Cache configuration
# Examples:
#  CACHE_URL=redis://<host>:<port>/<database>
#  CACHE_URL=redis://localhost:6379/0
# Use the next one if you followed Debian installation guide
CACHE_URL=${cfg.api.cache_url}

# Where media files (such as album covers or audio tracks) should be stored
# on your system?
# (Ensure this directory actually exists)
MEDIA_ROOT=${cfg.api.media_root}

# Where static files (such as API css or icons) should be compiled
# on your system?
# (Ensure this directory actually exists)
STATIC_ROOT=${cfg.api.static_root}

# Update it to match the domain that will be used to reach your funkwhale
# instance
# Example: DJANGO_ALLOWED_HOSTS=funkwhale.yourdomain.com
DJANGO_ALLOWED_HOSTS=${cfg.api.django_allowed_hosts}

# which settings module should django use?
# You don't have to touch this unless you really know what you're doing
DJANGO_SETTINGS_MODULE=config.settings.production

# Generate one using `openssl rand -base64 45`, for example
DJANGO_SECRET_KEY=${cfg.api.django_secret_key}

# You don't have to edit this, but you can put the admin on another URL if you
# want to
# DJANGO_ADMIN_URL=^api/admin/

# Sentry/Raven error reporting (server side)
# Enable Raven if you want to help improve funkwhale by
# automatically sending error reports our Sentry instance.
# This will help us detect and correct bugs
RAVEN_ENABLED=false
RAVEN_DSN=https://44332e9fdd3d42879c7d35bf8562c6a4:0062dc16a22b41679cd5765e5342f716@sentry.eliotberriot.com/5

# In-place import settings
# You can safely leave those settings uncommented if you don't plan to use
# in place imports.
# Typical docker setup:
#   MUSIC_DIRECTORY_PATH=/srv/funkwhale/data/music
#   MUSIC_DIRECTORY_SERVE_PATH=/music  # docker-only
# Typical non-docker setup:
#   MUSIC_DIRECTORY_PATH=/srv/funkwhale/data/music
#   # MUSIC_DIRECTORY_SERVE_PATH= # stays commented, not needed

MUSIC_DIRECTORY_PATH=${cfg.music_directory_path}
MUSIC_DIRECTORY_SERVE_PATH=${cfg.music_directory_path}

# LDAP settings
# Use the following options to allow authentication on your Funkwhale instance
# using a LDAP directory.
# Have a look at https://docs.funkwhale.audio/installation/ldap.html for
# detailed instructions.

# LDAP_ENABLED=False
# LDAP_SERVER_URI=ldap://your.server:389
# LDAP_BIND_DN=cn=admin,dc=domain,dc=com
# LDAP_BIND_PASSWORD=bindpassword
# LDAP_SEARCH_FILTER=(|(cn={0})(mail={0}))
# LDAP_START_TLS=False
# LDAP_ROOT_DN=dc=domain,dc=com

FUNKWHALE_FRONTEND_PATH=/srv/funkwhale/front/dist

# Nginx related configuration
NGINX_MAX_BODY_SIZE=30M
''

{ config, pkgs, ... }:

with pkgs;

{ 
  # See nixos/modules/services/web-apps/funkwhale.nix for all available options
  services.funkwhale = {
    enable = true;
    hostname = "funkwhale.local";
    protocol = "http"; # Disable https for local tests
    api = {
      django_allowed_hosts = "funkwhale.local";
      # Generate one using `openssl rand -base64 45`, for example
      django_secret_key = "i1vh21SWg1CEyM5KJILxn4aE1jEhvbF9XSxsT8chovgJll1v54VsH0X3AGsJ";
    };
  };

  users.extraUsers.funkwhale = {
    createHome = true;
    isNormalUser = true;
    home = "/srv/funkwhale";
    description = "Funkwhale server user";
  };

  # We use the default location in /srv/funkwhale, so we need to make it accessible
  system.activationScripts.enableHomeDirsInSrv = ''
        if ! test -e /srv; then
           mkdir /srv 
        fi
        chmod a+x /srv 
      '';
  # Overrides default 30M
  services.nginx.clientMaxBodySize = "40m";

  services.fail2ban.enable = true;
  time.timeZone = "Europe/Paris";
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "19.03";
}

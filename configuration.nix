{ config, pkgs, ... }:

with pkgs;

{ 
  # See nixos/modules/services/web-apps/funkwhale.nix for all available options
  services.funkwhale = {
    enable = true;
    hostname = "funkwhale.local";
    defaultFromEmail = "noreply@funkwhale.local";
    protocol = "http"; # Disable https for local tests
    api = {
      # Generate one using `openssl rand -base64 45`, for example
      djangoSecretKey = "i1vh21SWg1CEyM5KJILxn4aE1jEhvbF9XSxsT8chovgJll1v54VsH0X3AGsJ";
    };
  };

  # Overrides default 30M
  services.nginx.clientMaxBodySize = "100m";

  services.fail2ban.enable = true;
  time.timeZone = "Europe/Paris";
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "19.03";
}

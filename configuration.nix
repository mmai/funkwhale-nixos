{ config, pkgs, ... }:

with pkgs;

{ 
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

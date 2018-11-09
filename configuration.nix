{ config, pkgs, ... }:

with pkgs;

let
  funkwhale = (import ./packages/funkwhale.nix) { stdenv=stdenv; fetchurl=fetchurl; unzip=unzip; };
in 
{ 
  services.nginx = {
    enable = true;
    virtualHosts.default.root = "${funkwhale}/dist";
  };

  services.ntp.enable = true; 
  time.timeZone = "Europe/Paris";
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.09";
}

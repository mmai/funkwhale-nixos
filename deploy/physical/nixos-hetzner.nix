{
  # all in one server
  funkwhale =
    { config, pkgs, ... }:
    { deployment.targetHost = "IP.of.your.server";
      imports = [ 
        ./hetzner/configuration.nix
      ];
    };
}

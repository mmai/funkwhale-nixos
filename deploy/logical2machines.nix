{
  funkwhale = import ../configuration2machines.nix;
  postgresql =
    { pkgs, ... }:
    { services.postgresql.enable = true;
      services.postgresql.package = pkgs.postgresql;
      services.postgresql.enableTCPIP = true;
      services.postgresql.authentication = ''
        local all all                trust
        host  all all funkwhale      trust
      '';

    services.postgresql.initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE funkwhale WITH LOGIN PASSWORD 'funkwhalepass';
      CREATE DATABASE funkwhale;
      GRANT ALL PRIVILEGES ON DATABASE funkwhale TO funkwhale;
      \c funkwhale
      CREATE EXTENSION IF NOT EXISTS "unaccent";
    '';
      networking.firewall.allowedTCPPorts = [ 5432 ];


    };
}

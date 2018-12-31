let
  # Use a specific version of nixpkgs:
  # pkgsSrc = builtins.fetchTarball {
  #   url = https://github.com/nixos/nixpkgs-channels/archive/19879836d10f64a10658d1e2a84fc54b090e2087.tar.gz;
  #   sha256 = "f01e3a617e5b1d3c2ee8e525f3a48d1c4402d7c47f5cbf772c48ff57056481f4";
  # };
  
  # Use a local version of nixpkgs:
  pkgsSrc = ../nixpkgs;

  pkgs = (import pkgsSrc {});
in
pkgs.stdenv.mkDerivation rec {
  name = "nixops-env";
  buildInputs = with pkgs; [ pkgs.nixops ];
  shellHook = ''
    export NIX_PATH=${pkgs.path}:nixpkgs=${pkgs.path}:.
  '';
}

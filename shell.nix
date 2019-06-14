let
  # Use a local version of nixpkgs:
  # pkgs = (import /home/henri/travaux/nixpkgs {});

  # Use a specific version of nixpkgs:
  # cf. https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs
  #   Commit hash as of 2019-06-14
  #   `git ls-remote https://github.com/mmai/nixpkgs funkwhale`
  rev = "8f2a49c652902058c0a8731106955deade8910b6";
  pkgsSrc = builtins.fetchGit {
    url = https://github.com/mmai/nixpkgs;
    ref = "funkwhale";
    rev = rev;
  };
  pkgs = (import pkgsSrc {});

in
pkgs.stdenv.mkDerivation rec {
  name = "nixops-env";
  buildInputs = with pkgs; [ pkgs.nixops ];
  shellHook = ''
    export NIX_PATH=${pkgs.path}:nixpkgs=${pkgs.path}:.
  '';
}

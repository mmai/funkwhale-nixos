let
  # Use a local version of nixpkgs:
  pkgs = (import /home/henri/travaux/nixpkgs {});

  # Use a specific version of nixpkgs:
  # cf. https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs
  #   Commit hash as of 2019-06-14
  #   `git ls-remote https://github.com/mmai/nixpkgs funkwhale`
  # rev = "3f3490063dee41ab6da51f18634e42ca1df7cbf9";
  # pkgsSrc = builtins.fetchGit {
  #   url = https://github.com/mmai/nixpkgs;
  #   ref = "funkwhale";
  #   rev = rev;
  # };
  # pkgs = (import pkgsSrc {});

in
pkgs.stdenv.mkDerivation rec {
  name = "nixops-env";
  buildInputs = with pkgs; [ pkgs.nixops ];
  shellHook = ''
    export NIX_PATH=${pkgs.path}:nixpkgs=${pkgs.path}:.
  '';
}

let
  # Use a specific version of nixpkgs:
  pkgsSrc = builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-funkwhale-2019-01-01";
    url = https://github.com/mmai/nixpkgs;
    # Commit hash as of 2019-01-01
    # `git ls-remote https://github.com/mmai/nixpkgs`
    rev = "75ca6faece8f06096fb45d0b341c39a7ad47c256";
  };
  
  # Use a local version of nixpkgs:
  # pkgsSrc = /home/henri/travaux/nixpkgs;

  pkgs = (import pkgsSrc {});
in
pkgs.stdenv.mkDerivation rec {
  name = "nixops-env";
  buildInputs = with pkgs; [ pkgs.nixops ];
  shellHook = ''
    export NIX_PATH=${pkgs.path}:nixpkgs=${pkgs.path}:.
  '';
}

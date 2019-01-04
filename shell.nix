let
  # Use a local version of nixpkgs:
  # pkgsSrc = /home/henri/Travaux/nixpkgs;
  # pkgs = (import pkgsSrc {});

  # Use a specific version of nixpkgs:
  # cf. https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs
  #   Commit hash as of 2019-01-04
  #   `git ls-remote https://github.com/mmai/nixpkgs master`
  rev = "f3bd9d0b9f6517f1ef6b018e8ee7cd2b397a302b";
  pkgsSrc = builtins.fetchGit {
    url = https://github.com/mmai/nixpkgs;
    rev = rev;
  };

  # Patch top-level/default.nix on nixos-unstable (cf. bug https://github.com/NixOS/nixpkgs/issues/51858)
  pkgs = let
    hostPkgs = (import pkgsSrc {});
    patches = [ ./top-level.patch ];
    patchedPkgs = hostPkgs.runCommand "nixpkgs-${rev}"
    {
      inherit pkgsSrc;
      inherit patches;
    }
    ''
    cp -r $pkgsSrc $out
    chmod -R +w $out
    for p in $patches; do
      echo "Applying patch $p";
      patch -d $out -p1 < "$p";
    done
    '';
  in import patchedPkgs {};

in
pkgs.stdenv.mkDerivation rec {
  name = "nixops-env";
  buildInputs = with pkgs; [ pkgs.nixops ];
  shellHook = ''
    export NIX_PATH=${pkgs.path}:nixpkgs=${pkgs.path}:.
  '';
}

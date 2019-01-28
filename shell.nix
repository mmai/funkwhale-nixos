let
  # Use a local version of nixpkgs:
  pkgs = (import /home/henri/Travaux/nixpkgs {});

  # Use a specific version of nixpkgs:
  # cf. https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs
  #   Commit hash as of 2019-01-28
  #   `git ls-remote https://github.com/mmai/nixpkgs funkwhale`
  # rev = "69c6ba8b5bcb47fec423ca1d296b7613d50d6801";
  # pkgsSrc = builtins.fetchGit {
  #   url = https://github.com/mmai/nixpkgs;
  #   ref = "funkwhale";
  #   rev = rev;
  # };
  #
  # # Patch top-level/default.nix on nixos-unstable (cf. bug https://github.com/NixOS/nixpkgs/issues/51858)
  # pkgs = let
  #   hostPkgs = (import pkgsSrc {});
  #   patches = [ ./top-level.patch ];
  #   patchedPkgs = hostPkgs.runCommand "nixpkgs-${rev}"
  #   {
  #     inherit pkgsSrc;
  #     inherit patches;
  #   }
  #   ''
  #   cp -r $pkgsSrc $out
  #   chmod -R +w $out
  #   for p in $patches; do
  #     echo "Applying patch $p";
  #     patch -d $out -p1 < "$p";
  #   done
  #   '';
  # in import patchedPkgs {};

in
pkgs.stdenv.mkDerivation rec {
  name = "nixops-env";
  buildInputs = with pkgs; [ pkgs.nixops ];
  shellHook = ''
    export NIX_PATH=${pkgs.path}:nixpkgs=${pkgs.path}:.
  '';
}

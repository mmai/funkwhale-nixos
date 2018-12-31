{ pkgs ? import <nixpkgs> {} }:
with pkgs;

let
  release = "0.17";
  srcsUrl  = "https://code.eliotberriot.com/funkwhale/funkwhale/-/jobs/artifacts/${release}/download?job=";
  srcs = {
    api = fetchurl {
      url =  "${srcsUrl}build_api";
      name =  "api.zip";
      sha256 = "18qi94l6v61h3z4pcjvvggj1h3iqnzz4z45kz1zmbrndhvzvj4c2";
    };
    frontend = fetchurl {
      url =  "${srcsUrl}build_front";
      name =  "frontend.zip";
      sha256 = "18mlp3zqg33l4h5rhk41alj1yl8q3vg4vab09qf6hy551p3f2y1m";
    };
  };
in stdenv.mkDerivation {
  name = "funkwhale";
  version = "${release}";
  src = srcs.api;
  buildInputs = [ pkgs.unzip ];
  propagatedBuildInputs = [ ];
  patches = [ ./0001-changes.patch ];
  installPhase = ''
    mkdir $out
    cp -R ./* $out
    unzip ${srcs.frontend} -d $out
    mv $out/front/ $out/front_tmp
    mv $out/front_tmp/dist $out/front
    rmdir $out/front_tmp
    '';
  }

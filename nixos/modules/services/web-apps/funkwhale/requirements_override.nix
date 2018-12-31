{ pkgs, python }:

let 
  removeDependencies = names: deps:
    with builtins; with pkgs.lib;
      filter
      (drv: all
        (suf:
          ! hasSuffix ("-" + suf)
          (parseDrvName drv.name).name
        )
        names
      )
      deps;
  in 

  self: super: {

  # "Twisted" = python.overrideDerivation super."Twisted" (old: {
  #   propagatedBuildInputs =
  #     removeDependencies [ "Automat" "incremental" ] old.propagatedBuildInputs;
  # });

   "Automat" = python.overrideDerivation super."Automat" (old: {
     propagatedBuildInputs =
      removeDependencies [ "Twisted" ] old.propagatedBuildInputs;
     buildInputs = old.buildInputs ++ [ self."m2r" self."setuptools-scm" ];
  });

  "incremental" = python.overrideDerivation super."incremental" (old: {
    propagatedBuildInputs =
      removeDependencies [ "Twisted" ] old.propagatedBuildInputs;
  });

  "python-magic" = pkgs.python36Packages.python_magic;

  "django-taggit" = python.overrideDerivation super."django-taggit" (old: {
    patchPhase = ''
      sed -i \
        -e "s|'isort'||" \
        setup.py
    '';
  });

  "ffmpeg-python" = python.overrideDerivation super."ffmpeg-python" (old: {
    patchPhase = ''
      sed -i \
        -e "s|'pytest-runner'||" \
        setup.py
    '';
  });

  "daphne" = python.overrideDerivation super."daphne" (old: {
    patchPhase = ''
      sed -i \
        -e "s|"pytest-runner"||" \
        setup.py
    '';
  });

  "hiredis" = python.overrideDerivation super."hiredis" (old: {
    buildInputs = old.buildInputs ++ [ pkgs.glibcLocales ];
    preConfigure = ''
        export LANG=en_US.UTF-8
    '';
   });

  "rsa" = python.overrideDerivation super."rsa" (old: {
    buildInputs = old.buildInputs ++ [ pkgs.glibcLocales ];
    preConfigure = ''
        export LANG=en_US.UTF-8
    '';
  });
    
  "python-dateutil" = python.overrideDerivation super."python-dateutil" (old: {
    buildInputs = old.buildInputs ++ [ self."setuptools-scm" ];
  });

}

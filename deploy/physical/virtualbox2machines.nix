let vbox =
  { config, pkgs, ... }:
  { deployment.targetEnv = "virtualbox";
    deployment.virtualbox.memorySize = 1024; # megabytes
    deployment.virtualbox.vcpu = 2; # number of cpus
  };
in
{
  funkwhale = vbox;
  postgresql = vbox;
}

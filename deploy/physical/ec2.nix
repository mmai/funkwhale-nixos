let
  # Insert your AWS access key here
  accessKey = "youraccesskey";
  region = "eu-west-3"; # Paris
in {
  # Mapping of our 'helloserver' machine
  funkwhale = { resources, ... }:
    { deployment.targetEnv = "ec2";
      deployment.ec2.region = region;
      deployment.ec2.instanceType = "t1.micro";
      deployment.ec2.accessKeyId = accessKey;
      # We'll let NixOps generate a keypair automatically
      deployment.ec2.keyPair = resources.ec2KeyPairs.funkwhale-kp.name;
    };

  # Here we create a keypair in the same region as our deployment
  resources.ec2KeyPairs.funkwhale-kp = {
    region = region;
    accessKeyId = accessKey;
  };
}

#In the above expression, no AWS secret key is provided, you need to put that in your ~/.ec2-keys file where each line specifies a access key, followed by the secret key, e.g.:
# youraccesskey yoursecretkey

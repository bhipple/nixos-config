let
  region = "us-east-1";
  accessKeyId = "bhipple";
in
{
  network.description = "NixOps";
  loki =
    { config, resources, pkgs, ... }:
    {
      deployment.targetEnv = "ec2";
      deployment.ec2.accessKeyId = accessKeyId;
      deployment.ec2.region = region;
      deployment.ec2.instanceType = "t2.micro";
      deployment.ec2.keyPair = resources.ec2KeyPairs.my-key-pair;

      imports = [
        ../base.nix
      ];
    };

  # Provision an EC2 key pair.
  resources.ec2KeyPairs.my-key-pair =
    { inherit region accessKeyId; };
}

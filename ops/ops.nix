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

      # WIP
      deployment.ec2.blockDeviceMapping = {
        "/dev/xvdg".disk = resources.ebsVolumes.lokidata;
      };

      imports = [
        ../base.nix
      ];
    };

  # Provision an EC2 key pair.
  resources.ec2KeyPairs.my-key-pair = { inherit region accessKeyId; };

  resources.ebsVolumes.lokidata = {
    inherit region accessKeyId;
    name = "Loki EBS";
    size = 100;
    volumeType = "standard";
    zone = "us-east-1a";
  };
}

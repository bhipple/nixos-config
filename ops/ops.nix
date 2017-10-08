let
  region = "us-east-1";
  zone = "us-east-1a";
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
      deployment.ec2.zone = zone;
      deployment.ec2.instanceType = "t2.micro";
      deployment.ec2.keyPair = resources.ec2KeyPairs.my-key-pair;

      # WIP
      deployment.ec2.blockDeviceMapping = {
        "/dev/xvdg".disk = resources.ebsVolumes.bigdata;
      };

      fileSystems = {
      "/mnt/storage" = {
        device = "/dev/xvdg";
        label = "ebs-volume";
        fsType = "ext4";
        autoFormat = true;
      };

      };

      imports = [
        ../base.nix
      ];
    };

  # Provision an EC2 key pair.
  resources.ec2KeyPairs.my-key-pair = { inherit region accessKeyId; };

  resources.ebsVolumes.bigdata = {
    inherit region accessKeyId zone;
    name = "ebs-volume";
    size = 25;
    volumeType = "gp2";
  };
}

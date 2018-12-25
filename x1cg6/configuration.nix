{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../base.nix
      ../brh-base.nix
      # ../hosts.nix
      ../xserver.nix

      # VPN
      # ../vpn.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [{
    name = "root";
    device = "/dev/nvme0n1p2";
    preLVM = true;
    allowDiscards = true;
  }];

  networking.hostName = "x1cg6";
}

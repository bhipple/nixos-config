{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../base.nix
    ../brh-base.nix
    ../cron.nix
    ../hosts.nix
    ../xserver.nix

    # VPN
    ../vpn.nix
  ];

  boot.kernelParams = [ "intel_pstate=no_hwp" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices.root = {
    name = "root";
    device = "/dev/sda2";
    preLVM = true;
    allowDiscards = true;
  };

  networking.hostName = "brh-x1cg4";

  services.upower.enable = true;
}

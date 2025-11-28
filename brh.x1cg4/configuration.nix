{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../base.nix
    ../brh-base.nix
    ../cron.nix
    ../email.nix
    ../hosts.nix
    ../sudo.nix
    ../udev.nix
    ../xserver.nix

    # VPN
    ../vpn/vpn.nix
  ];

  boot.kernelParams = [ "intel_pstate=no_hwp" ];

  boot.loader.grub.enable = true;
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

  system.stateVersion = "25.05";

}

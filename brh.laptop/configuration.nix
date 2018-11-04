{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../base.nix
      ../brh-base.nix
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

  boot.initrd.luks.devices = [{
    name = "root";
    device = "/dev/sda2";
    preLVM = true;
    allowDiscards = true;
  }];

  networking.hostName = "brh.laptop";

  services.monero.enable = false;

  virtualisation = {
    docker.enable = true;
    virtualbox.host.enable = false;
    virtualbox.guest.enable = false;
  };
}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../base.nix

      # VPN
      #./private-internet-access.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdd";
  boot.loader.grub.efiSupport = false;

  networking.hostName = "smilodon";

  users.extraUsers.smilodon = {
    isNormalUser = true;
    description = "Smilodon";
    extraGroups = [ "adbusers" "smilodon" "docker" "ipfs" "networkmanager" "wheel" ];
  };
}

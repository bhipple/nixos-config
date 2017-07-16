{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../base.nix
      ../private-internet-access.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
  boot.loader.grub.efiSupport = false;

  networking.hostName = "brh.desktop";

  environment.systemPackages = with pkgs; [
    amdappsdkFull
  ];

  services = {
    xserver = {
      # Sets the center monitor to be the primary.
      # Will move the login screen and xmobar onto the center monitor.
      # Waiting on https://github.com/NixOS/nixpkgs/pull/15353 to be merged
      # xrandrHeads = [ "DisplayPort-0"
      #                 { output = "HDMI-0"; primary = true; monitorConfig = ""; }
      #                 "DVI-0"
      #               ];

      # Use proprietary AMD drivers
      videoDrivers = [ "amdgpu-pro" ];
    };
  };

  programs = {
    adb.enable = true;
  };
}
